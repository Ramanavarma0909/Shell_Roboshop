#!/bin/bash

SG_ID="sg-0f808eb36964cf691" # replace with your ID
AMI_id="ami-0220d79f3f480ecf5" # replace with your AMI ID
ZONE_ID="Z005333411PGFYRZVJTNW" # replace with your ZONE ID
DOMAIN_NAME="ddaaws92s.store"

for instance in $@  

do
    INSTANCE_ID=$( aws ec2 run-instances \
    --image-id $AMI_id \
    --instance-type "t3.micro" \
    --security-group-ids $SG_ID \
    --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=$instance}]" \
    --query 'Instances[0].InstanceId' \
    --output text )

    if [ $instance == "frontend" ]; then
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[].Instances[].PublicIpAddress' --output text
        )
        RECORD_NAME="$DOMAIN_NAME" #ddaaws92s.store
    else
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $INSTANCE_ID \
            --query 'Reservations[].Instances[].PrivateIpAddress' --output text
        )
        RECORD_NAME="$instance.$DOMAIN_NAME" #mongodb.ddaaws92s.store
    fi

    echo "IP address of $instance is $IP"
aws route53 change-resource-record-sets \
    --hosted-zone-id $ZONE_ID \
    --change-batch '
     {
  "Comment": "Updating the A record for the main website",
  "Changes": [
    {
      "Action": "UPSERT",
      "ResourceRecordSet": {
        "Name": "'$RECORD_NAME'",
        "Type": "A",
        "TTL": 300,
        "ResourceRecords": [
          {
            "Value": "'$IP'"
          }
        ]
      }
    }
  ]
}
    '
     echo "A record for $instance is $IP"
done