#!/bin/bash -ex

# create app (logical container)
aws elasticbeanstalk create-application --application-name etherpad

# create aws version
aws elasticbeanstalk create-application-version --application-name etherpad \
--version-label 1 \
--source-bundle "S3Bucket=awsinaction-code2,S3Key=chapter05/etherpad.zip"

# get the latest node.js version
SolutionStackName = "$(aws elasticbeanstalk list-available-solution-stacks --output text --query "SolutionStacks [?contains(@, 'running Node.js')] | [0]")"

# run environment which runs single instance without scalling possibility
aws elasticbeanstalk create-environment --environment-name etherpad \
--application-name etherpad \
--optin-settings Namespace=aws:elasticbeanstalk:environment, \
OptionName=EnvironmentType,Value=SingleInstance \
--solution-stack-name "$SolutionStackName" \
--version-label 1

# check status
aws elasticbeanstalk describe-environments --environment-name etherpad

# clean up
#aws elasticbeanstalk terminate-environment --environment-name etherpad

# check status
aws elasticbeanstalk describe-environments --environment-name etherpad \
--output text --query "Environments[].Status"
