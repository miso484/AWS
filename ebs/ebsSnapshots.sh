# get EBS volume ID
VolumeId=$(aws ec2 describe-volumes --region eu-central-1 \
--filters "Name=size,Values=5" --query "Volumes[].VolumeId" \
--output text)

# create volume snapshot
aws ec2 create-snapshot --region eu-central-1 --volume-id $VolumeId
