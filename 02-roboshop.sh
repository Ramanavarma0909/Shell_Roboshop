#!/bin/bash

SG_ID="sg-0f808eb36964cf691" # replace with your ID
AMI_id="ami-0220d79f3f480ecf5" # replace with your AMI ID

for instance in $@  

do
    instance_id=$(aws ec2 run-instances \
    --image-id $AMI_id \
    --instance-type t3.micro \
    --security-group-ids $SG_ID \
    --tag-specifications 'ResourceType=instance,Tags=[{Key=Name,Value=$instance}]' \
    --query 'Instances[0].InstancesId' \
    --output text)

    if [ $instance == "frontend" ]; then
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $instance_id \
            --query 'Reservations[].Instances[].PublicIpAddress' --output text
        )
    else
        IP=$(
            aws ec2 describe-instances \
            --instance-ids $instance_id \
            --query 'Reservations[].Instances[].PrivateIpAddress' --output text
        )
    fi
done