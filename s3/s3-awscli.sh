#!/bin/bash -e

bkppath="C:/Backups"
rstpath="C:/Restore"
s3bucket="awsinaction-miso"
s3path="s3://$s3bucket/backup"

mkdir C:/Backups
echo "This is test file" > C:/Backups/testfile1.txt
echo "This is test file" > C:/Backups/testfile2.txt
echo "This is test file" > C:/Backups/testfile3.txt
mkdir C:/Restore

# create s3 bucket
aws s3 mb s3://$s3bucket

# list existing s3 buckets
aws s3 ls

# list objects in s3 backet
aws s3 ls s3://$s3bucket

# list objects in s3 backet path
aws s3 ls $s3path

# sync directorium to s3
aws s3 sync $bkppath $s3path

# list objects in s3 backet path
aws s3 ls $s3path

# remove object from s3 bucket path
aws s3 rm $s3path/testfile.txt
aws s3 ls $s3path

# enable versions
#aws s3api put-bucket-versioning --bucket $s3bucket --versioning-configuration Status=Enabled
#aws s3api list-object-versions --bucket $s3bucket

# test restore
#aws s3 cp --recursive $s3path $rstpath

# cleanup
#aws s3 rb --force s3://$s3bucket


#for n in 1 2 3; do aws s3 rm $s3path/f$n.txt; done