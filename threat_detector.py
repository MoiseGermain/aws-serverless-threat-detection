import json
import boto3
import os

sns_client = boto3.client('sns')
SNS_TOPIC_ARN = os.environ['SNS_TOPIC_ARN']

def lambda_handler(event, context):
    # Parse CloudTrail event
    event_name = event.get('detail', {}).get('eventName', '')
    
    # Define suspicious events
    suspicious_events = ["ConsoleLogin", "CreateUser", "AttachUserPolicy", "DeleteBucket"]
    
    if event_name in suspicious_events:
        message = f"Suspicious activity detected: {event_name}\nDetails: {json.dumps(event, indent=2)}"
        print(message)
        
        # Publish alert to SNS
        sns_client.publish(
            TopicArn=SNS_TOPIC_ARN,
            Subject=f"Alert: {event_name}",
            Message=message
        )
    
    return {"status": "processed"}
