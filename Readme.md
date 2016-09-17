## Build Services in AWS ##

### Files & Folders ###

* ansible-provision.yml :: as the name suggests this is the main entry point. It requires an S3 bucket to be created first.
* aws-params.json :: some default params for the template
* cft :: all templates used to create the vpc. Main entry point: build-services-vpc.template
* boostrap :: shell scripts to bootstrap the servers.

### Usage ###

blah

### Flow ###

1. The ansible playbook uploads all files from the _bootstrap_ folder into S3. Bucket have to be created first.
2. The ansible playbook uploads the CloudFormation template into S3. Bucket have to be created first.
3. The VPC creation starts based on the template. The following resources are created:
    * VPC to hold things together
    * NAT GW to provide outbound communication
    * Bastion host for Ansible & Human access for the servers
    * Two EIP allocations for the NAT GW & for the Bastion host
    * Security groups to enable access
    * Public subnet for the load balancers, bastion and nat gw
    * Private subnet for the servers
    * Private subnets for rds
    * Servers:
        - Jenkins
        - Nexus
        - Config service (Consul)
        - MySQL for ...
    * Application load balancers [internal & external] for the services
4. Server instances are bootstrapping incorporating the bootstrap files provided
5. All the various server roles are provisioned via Ansbile