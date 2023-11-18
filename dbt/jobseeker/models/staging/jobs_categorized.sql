{{
    config(
        materialized='table',
        database='jobseeker',
        schema='staging'
    )
}}
{% set ns = namespace(likeValue='') %}
{% set ns.job_roles=('Data Engineer', 'Data Analyst', 'Data Scientist') %}
{% for job in ns.job_roles %}
    {% set words = job.split(' ') %}
    {% set ns.likeValue = '' %}
        {% for word in words %}
            {% set ns.likeValue = ns.likeValue + '%' + word %}
        {% endfor %}
    (
    select
        '{{ job }}' as jobCategory,
        "jobId",
        "jobTitle",
        "date",
        "expirationDate",
        "locationName",
        "minimumSalary",
        "maximumSalary",
        "currency",
        "employerId",
        "employerName",
        "applications",
        "jobDescription",
        "jobUrl"
    from {{source('reed_jobs_data','REED_JOBS_DATA')}}
    where upper("jobTitle") like '{{ ns.likeValue | upper }}%'
    )
    {% if not loop.last %}
    union all
    {% endif %}
{% endfor %}
