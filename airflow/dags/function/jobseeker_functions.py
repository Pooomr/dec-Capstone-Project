def run_airbyte_pull(connId: str, airbyteUser: str, airbytePw: str):
    import requests
    import time
    from requests.auth import HTTPBasicAuth

    url = "http://host.docker.internal:8006/v1/jobs"
    
    print(connId)
    print(airbyteUser)
    print(airbytePw)
    
    #connId = "144bffb3-1811-4235-8b69-5c68553ba875"
    
    payload = {
        "jobType": "sync",
        "connectionId": connId
    }
    headers = {
        "accept": "application/json",
        "content-type": "application/json"
    }

    response = requests.post(url, json=payload, headers=headers, auth=HTTPBasicAuth(airbyteUser,airbytePw))
    #response = requests.post(url, json=payload, headers=headers, auth=HTTPBasicAuth('airbyte','password'))

    print(response.text)
    
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
        print("Current status is {}".format(status))
        response = requests.get(url, json=payload, headers=headers, auth=HTTPBasicAuth(airbyteUser,airbytePw))
        print(response.text)
        statusCheck = response.json()
        for job in statusCheck["data"]:
            if job["jobId"] == jobId:
                status = job["status"]
        
    print("Final status is {}".format(status))