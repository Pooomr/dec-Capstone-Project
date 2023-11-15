def run_airbyte_pull(connId: str, airbyteUser: str, airbytePw: str):
    import requests
    from requests.auth import HTTPBasicAuth

    url = "http://host.docker.internal:8006/v1/jobs"
    
    print(connId)
    print(airbyteUser)
    print(airbytePw)
    
    connId = "144bffb3-1811-4235-8b69-5c68553ba875"
    
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