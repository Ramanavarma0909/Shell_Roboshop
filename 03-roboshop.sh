#!/bin/bash
 
ami_id="ami-0055977a6e828a4f4" 
instance_type="t3.micro"
hosted_zone_id="Z005333411PGFYRZVJTNW" 
domain_name="ddaaws92s.store"

for instance in $@
do
    echo "creating instance: $instance" 
done