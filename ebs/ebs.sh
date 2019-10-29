## SETUP EBS ##

# connect ot ec2 instance
#ssh -i $PathToKey/mykey.pem ec2-user@$PublicName

# confirm that ebs disk is attached
sudo fdisk -l

# make ext 4 file system on ebs storage
sudo mkfs -t ext4 /dev/xvdf

# install device
sudo mkdir /mnt/volume
sudo mount /dev/xvdf /mnt/volume

# verify
df -h


## CONFIRM THAT EBS IS INDEPENDENT ON EC2 ##

# add test file and deinstall disk
sudo touch /mnt/volume/testfile
sudo umount /mnt/volume

# modify ebs.yaml file changing parameter AttachVolume to no
# update CloudFormation stack

# confirm that disk is not attached
sudo fdisk -l

# this returns false
#ls /mnt/volume/testfile

# add EBS disk again upgrating the CloudFormation stack with changed AttachVolume parameter to yes

# install disk again
sudo mount /dev/xvdf /mnt/volume/

# this returns true now
ls /mnt/volume/testfile