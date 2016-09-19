#!/usr/bin/env bash

#####################################
# Boostrap script for bastion hosts #
#####################################

# Test for package management tool
if [ -n "$(command -v yum)" ]; then
    # We are a yum based house
    yum update -y
    yum install -y aws-cfn-bootstrap

    # TODO: figure out which one to use and what are the exact steps
    #curl https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.src.rpm
    #curl https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.amzn1.noarch.rpm

    # AWS Specific stuff
    CFN_INIT='/opt/aws/bin/cfn-init'

elif [ -n "$(command -v apt-get)" ]; then
    # we are an apt based house
    # See https://gist.github.com/kixorz/10194688
    # Also see http://docs.aws.amazon.com/AWSCloudFormation/latest/UserGuide/cfn-helper-scripts-reference.html

    apt-get -y update
    apt-get -y upgrade
    apt-get -y install python-setuptools

    mkdir aws-cfn-bootstrap-latest
    curl https://s3.amazonaws.com/cloudformation-examples/aws-cfn-bootstrap-latest.tar.gz | \
        tar xz -C aws-cfn-bootstrap-latest --strip-components 1
    easy_install aws-cfn-bootstrap-latest

    ln -s /root/aws-cfn-bootstrap-latest/init/ubuntu/cfn-hup /etc/init.d/cfn-hup

    CFN_INIT='/usr/local/bin/cfn-init'
fi

# Execute cfn-init
`$CFN_INIT -s {{stack}} -r {{logicalId}} --region {{region}} || error_exit 'Failed to run cfn-init'`