#!/bin/bash
export NEW_AMI=$(jq -r '.builds[].artifact_id' manifest.json | cut -d':' -f2)
echo "From Packer post processor - the AMI created: ${NEW_AMI}"
echo "Capturing AMI in ami.txt locally..."
echo -n $NEW_AMI > ./ami.txt

aws ec2 describe-images --owners 023451010066 \
    --filters "Name=name,Values=base_*" \
    --query 'sort_by(Images, &CreationDate)[].Name' \
    --region eu-west-1