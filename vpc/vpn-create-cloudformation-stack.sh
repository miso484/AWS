#!/bin/bash -ex

# get standard VPN
VpcId="$(aws ec2 describe-vpcs --filter "Name=isDefault, Values=true" --query "Vpcs[0].VpcId" --output text)"

# get standard subnet
SubnetId="$(aws ec2 describe-subnets --filters "Name=vpc-id,Values=$VpcId" --query "Subnets[0].SubnetId" --output text)"

# create secret
SharedSecret="$(openssl rand -base64 30)"
Password="$(openssl rand -base64 30)"

# create cloudformation stack
aws cloudformation create-stack --stack-name vpn --template-url https://s3.amazonaws.com/awsinaction-code2/chapter05/vpn-cloudformation.yaml --parameters ParameterKey=KeyName,ParameterValue=mykey "ParameterKey=VPC,ParameterValue=$VpcId" "ParameterKey=Subnet,ParameterValue=$SubnetId" "ParameterKey=IPSecSharedSecret,ParameterValue=$SharedSecret" ParameterKey=VPNUser,ParameterValue=vpn "ParameterKey=VPNPassword,ParameterValue=$Password"

# vait until the stack is created
aws cloudformation wait stack-create-complete --stack-name vpn

# get stack output
aws cloudformation describe-stacks --stack-name vpn --query "Stacks[0].Outputs"
