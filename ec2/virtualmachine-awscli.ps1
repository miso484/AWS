# To start PowerShell scripts first start PowerShell as Administrator
# to allow unsigned scripts to be executed. To do so enter:
# Set-ExecutionPolicy Unrestricted
# Close the PowerShell window (you don't need Administrator privileges to run the scripts)
#
# You also need to install the AWS Command Line Interface from http://aws.amazon.com/cli/
#
# Right click on the *.ps1 file and select Run with PowerShell
$ErrorActionPreference = "Stop"

# get ids
$AMIID=aws ec2 describe-images --filters "Name=name,Values=amzn-ami-hvm-2017.09.1.*-x86_64-gp2" --query "Images[0].ImageId" --output text
$VPCID=aws ec2 describe-vpcs --filter "Name=isDefault, Values=true" --query "Vpcs[0].VpcId" --output text
$SUBNETID=aws ec2 describe-subnets --filters "Name=vpc-id, Values=$VPCID" --query "Subnets[0].SubnetId" --output text

# create security group
$SGID=aws ec2 create-security-group --group-name mysecuritygroup --description "My security group" --vpc-id $VPCID --output text
aws ec2 authorize-security-group-ingress --group-id $SGID --protocol tcp --port 22 --cidr 0.0.0.0/0

# run ec2 instance
$INSTANCEID=aws ec2 run-instances --image-id $AMIID --key-name mykey --instance-type t2.micro --security-group-ids $SGID --subnet-id $SUBNETID --query "Instances[0].InstanceId" --output text
Write-Host "waiting for $INSTANCEID ..."
aws ec2 wait instance-running --instance-ids $INSTANCEID

# get public DNS name of the ec2 instance
$PUBLICNAME=aws ec2 describe-instances --instance-ids $INSTANCEID --query "Reservations[0].Instances[0].PublicDnsName" --output text

# ssh info about ec2 instance
Write-Host "$INSTANCEID is accepting SSH connections under $PUBLICNAME"
Write-Host "connect to $PUBLICNAME via SSH as user ec2-user"
Write-Host "Press [Enter] key to terminate $INSTANCEID ..."
Read-Host

# terminate the ec2 instance
aws ec2 terminate-instances --instance-ids $INSTANCEID
Write-Host "terminating $INSTANCEID ..."
aws ec2 wait instance-terminated --instance-ids $INSTANCEID

# delete security group
aws ec2 delete-security-group --group-id $SGID
Write-Host "done."
