#!/bin/bash -ex

# get vpc
VpcId="$(aws ec2 describe-vpcs --filter "Name=isDefault, Values=true" --query "Vpcs[0].VpcId" --output text)"

# create cloud formation stack
aws cloudformation create-stack --stack-name irc --template-url https://s3.amazonaws.com/awsinaction-code2/chapter05/irc-cloudformation.yaml --parameters "ParameterKey=VPC,ParameterValue=$VpcId"

# wait for CREATE_COMPLETE stack status
aws cloudformation wait stack-create-complete --stack-name irc
