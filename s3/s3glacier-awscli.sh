#!/bin/bash -e

bkppath="C:/Backups"
rstpath="C:/Restore"
myvault="awsinaction-misostamenic"
s3path="s3://$s3bucket/backup"

mkdir C:\Backups
echo "This is test file" > C:\Backups\testfile.txt
mkdir C:\Restore

# get help
aws glacier help

# create s3 bucket
aws glacier create-vault --account-id - --vault-name $myvault

# initiate multipart upload
aws glacier initiate-multipart-upload --account-id - --archive-description "multipart upload test" --part-size 1048576 --vault-name $myvault
UPLOADID=""

# upload file(s)
aws glacier upload-multipart-part --upload-id $UPLOADID --body chunkaa --range 'bytes 0-1048575/*' --account-id - --vault-name $myvault
aws glacier upload-multipart-part --upload-id $UPLOADID --body chunkab --range 'bytes 1048576-2097151/*' --account-id - --vault-name $myvault
aws glacier upload-multipart-part --upload-id $UPLOADID --body chunkac --range 'bytes 2097152-3145727/*' --account-id - --vault-name $myvault

# sync directorium to s3
aws s3 sync $bkppath $s3path

# enable versions
#aws s3api put-bucket-versioning --bucket awsinaction-$yourname --versioning-configuration Status=Enabled
#aws s3api list-object-versions --bucket $s3bucket

# test restore
#aws s3 cp --recursive $s3path $rstpath

# cleanup
#aws s3 rb --force s3://$s3bucket