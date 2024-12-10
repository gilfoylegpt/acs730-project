### Directory Introduction
modules: modules used by the project.   

        global: global variables(like prefix) and external resource(like amazon linux image)   

        network: vpc, subnet, igw, natgw   

        keypair: ssh key pair 

        security group: different kinds of security groups used         

        instance: instance needed

        loadbalancer: load balancer, target group

        autoscalinggroup: launched template, autoscaling group

arch: invoke modules/network to create the infrastructure of the network 

web: invoke modules/* to create the web services

dev: invoke arch && web to create the dev environment 

staging: invoke arch && web to create the staging environment

prod: invoke arch && web to create the prod environment 

ansible: connect the vm5&&6 to configure the web service 

.github/workflow: 

        tf_sec.yml: execute security scans on each push && pull request to dev, staging, prod branches

        staging_deploy.yml: execute terraform && ansible pipeline on each push && pull request to staging branch

        prod_deploy.yml: execute terraform && ansible pipeline on each push && pull request to prod branch


### Branch and Environment
dev: we use dev branch to development and build the environment to self-test

staging: once dev branch merged into staging branch, it will trigger the whole pipeline of staging environment building

prod: once staging branch merged into prod branch, it will trigger the whole pipeline of prod environment building


### Branch and Work Mode 
1. we use dev branch to develop, commit and push to origin
2. we do a pull request from dev to staging to see how it works for a while
3. once staging environment works like we expected, pull request from staging to prod 
4. prod environment should keep stable and don't change frequently


### Pipeline pre-requisites:
Two s3 buckets needed:
        
        acs730-project: to store terraform state

        acs730-images: to store images 


### Pipeline Process
1. push or merged pull request events on staging or prod branch happen
2. terraform build the ${environment}/network
3. terraform build the ${environment}/service
4. ansible configure the vm5&&6


### Clean Up process 
1. Delete the services 
``` 
 cd ${environment}/service
 tf init
 tf refresh
 tf destroy  
```
2. Delete the network
```
 cd ${environment}/network
 tf init
 tf refresh
 tf destroy
```
