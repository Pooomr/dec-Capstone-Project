import datetime
import pendulum

from airflow import DAG
from airflow.operators.python import PythonOperator
from airflow.operators.bash import BashOperator
from function.jobseeker_functions import run_airbyte_pull

with DAG(
        dag_id='jobseeker_etl',
        schedule_interval='0 0 * * *',
        start_date=pendulum.datetime(2023, 1, 1, tz="UTC"),
        catchup=False,
        render_template_as_native_obj=True,
        dagrun_timeout=datetime.timedelta(minutes=5),
        tags=['reed.co.uk jobseeker'],
) as dag:

    connId = "{{var.value.AIRBYTE_CONNECTION_ID}}"
    airbyteUser = "{{var.value.AIRBYTE_USER}}"
    airbytePw = "{{var.value.AIRBYTE_PASSWORD}}"

    pull_data = PythonOperator(
        task_id="run_airbyte_pull",
        python_callable=run_airbyte_pull,
        op_kwargs={
            "connId": connId,
            "airbyteUser": airbyteUser,
            "airbytePw": airbytePw
        }
    )

    run_dbt = BashOperator(
        task_id="dbt_run",
        bash_command="cp -R /opt/airflow/dags/dbt /tmp;\
        cd /tmp/dbt/jobseeker;\
        export DBT_PASSWORD={{ var.value.DBT_PASSWORD }};\
        set;\
        /usr/local/airflow/dbt_env/bin/dbt deps;\
        /usr/local/airflow/dbt_env/bin/dbt build --project-dir /tmp/dbt/jobseeker/ --profiles-dir . --target prod;\
        cat /tmp/dbt/jobseeker/logs/dbt.log"
    )

    pull_data >>  run_dbt