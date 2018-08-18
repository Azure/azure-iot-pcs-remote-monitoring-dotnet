
Local Deployment
================
### Overview
This document and other documents, referenced here, contain steps to git clone the latest repository, deploying the microservices locally and also a walk through the general repository and microservice structure.
&nbsp; 
### Steps to clone the restructured repository
#### If you have an existing cloned repository
1) Use recursive clone to clone the repository and the sub-modules.
````console
#### For git version 2.17.1
abc@pcs git clone --recurse-submodules  https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet.git
Cloning into 'azure-iot-pcs-remote-monitoring-dotnet'...
remote: Counting objects: 774, done.
.....
Submodule 'cli' (https://github.com/Azure/pcs-cli.git) registered for path 'cli'
Submodule 'services' (https://github.com/Azure/remote-monitoring-services-dotnet.git) registered for path 'cli'
Submodule 'webui' (https://github.com/Azure/azure-iot-pcs-remote-monitoring-webui.git) registered for path 'webui'
.....
````
2) It is safe to delete existing microservice folders (except for services folder) under the top-level of the repository. Please do not delete web-ui, cli and reverse-proxy folders.
&nbsp; 
#### If you have do not have an existing cloned repository
1) Follow the step 1  of "existing cloned repo". You will not require to delete anything. Ensure you have services sub-module, which contains all the microservices.
&nbsp; 
### Steps to deploy the microservices locally
Follow the documentation [here](https://github.com/Azure/remote-monitoring-services-dotnet).
&nbsp; 
### Structure of repository and microservices
#### Repository
#### Microservices
Each microservice comprises of following projects/folders. 
1) scripts 
2) WebService  
3) Service  
4) WebService.Test  
5) Service.Test

Description: 
1) Scripts  
The scripts folder is organized as follows\
i. **docker** sub folder for building docker containers of the current microservice.\
ii. **root** folder contains scripts for building and running services natively.\
&nbsp; 
![script folder structure](https://user-images.githubusercontent.com/39531904/44290937-10df4e00-a230-11e8-9cd4-a9c0644e166b.PNG "Caption")\
The docker build scripts require environment variables to be set up before execution. The run scripts can run both natively built and dockerized microservice. The run script under docker folder can also be independently used to pull and run published docker images. One can modify the tag and the account to pull different version or privately built docker images.
&nbsp; 

2) WebService  
It contains code for REST endpoints of the microservice.
&nbsp;  

3) Service  
It contains business logic and code interfacing various SDKs. 
&nbsp;

4) WebService.Test  
It contains unit tests for the REST endpoints of the microservice. 
&nbsp; 

5) Service  
It contains unit tests for the business logic and code interfacing various SDKs.
&nbsp;  

6) Other Projects  
The microservice might contain other projects such as RecurringTaskAgent etc.

