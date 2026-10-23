#!/bin/bash
 
ami_id="ami-0055977a6e828a4f4" 
instance_type="t3.micro"
hosted_zone_id="Z005333411PGFYRZVJTNW" 
domain_name="ddaaws92s.store"
sg_id="sg-06e0ed1e66a39d8d3"

for instance in $@
do
    echo "creating instance: $instance" 

    instance_id=$(aws ec2 run-instances \
        --image-id $ami_id \
        --instance-type $instance_type \
        --security-groups $sg_id \
        --tag-specifications "ResourceType=instance,Tags=[{Key=Name,Value=roboshop-$instance}]" \
        --query 'Instances[0].InstanceId' \
        --output text
    )

    echo "$instance ID: $instance_id"
done