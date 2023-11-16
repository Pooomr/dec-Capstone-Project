def run_airbyte_pull(connId: str, airbyteUser: str, airbytePw: str):
    import requests
    import time
    from requests.auth import HTTPBasicAuth

    url = "http://host.docker.internal:8006/v1/jobs"
    
    payload = {
        "jobType": "sync",
        "connectionId": connId
    }
    headers = {
        "accept": "application/json",
        "content-type": "application/json"
    }

    response = requests.post(url, json=payload, headers=headers, auth=HTTPBasicAuth(airbyteUser,airbytePw))
    
    respData = response.json()
    
    #Get Job ID and status
    jobId = respData["jobId"]
    status = respData["status"]
    tries = 0
    
    payload = {
        "connectionId": connId,
        "jobId": jobId
    }
    
    #Loop until process is done
    while status == "running" and tries < 10:
        time.sleep(10)
        response = requests.get(url, json=payload, headers=headers, auth=HTTPBasicAuth(airbyteUser,airbytePw))
        statusCheck = response.json()
        for job in statusCheck["data"]:
            if job["jobId"] == jobId:
                status = job["status"]
