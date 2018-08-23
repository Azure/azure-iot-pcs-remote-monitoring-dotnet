
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
Submodule 'services' (https://github.com/Azure/remote-monitoring-services-dotnet.git) registered for path 'services'
Submodule 'webui' (https://github.com/Azure/azure-iot-pcs-remote-monitoring-webui.git) registered for path 'webui'
.....
````
2) Update submodules
````console
abs@pcs git submodule update --recursive --remote
Submodule path 'cli': checked out '0ff9bad05c5a12df572ab45c07ac903bfd9fe58e'
Submodule path 'device-simulation': checked out 'a7ef4c3d243cc2aa98f0f69029b2eb74bc9067d4'
Submodule path 'services': checked out '11f025f25f86dadb4eb07c58ce0623b09cadb585'
.....
````
3) It is safe to delete existing microservice folders (except for services folder) under the top-level of the repository. Please do not delete web-ui, cli and reverse-proxy folders.
&nbsp; 
#### If you have do not have an existing cloned repository
1) Follow the step 1 and 2 of "existing cloned repo". You will not require to delete anything. Ensure you have services sub-module, which contains all the microservices.
&nbsp; 
### Steps to deploy the microservices locally
Follow the documentation [here](https://github.com/Azure/remote-monitoring-services-dotnet/blob/master/docs/LOCAL_DEPLOYMENT.md).
&nbsp; 

## Structure of repository
The repository comprises of following projects/submodules. 
1) scripts 
2) cli 
3) services  
4) webui   
5) reverse-proxy

Description: 
1) Scripts
The scripts folder is organized as follows\
i. **docker** scripts to deploy "released" tagged containers using docker-compose.\
ii. **local** scripts to deploy "testing" tagged containers using docker-compose.\
iii. **iothub** scripts to deploy create azure iot hub.\
&nbsp; 
![top-level-scripts](https://user-images.githubusercontent.com/39531904/44433416-f4f2e980-a55a-11e8-8e3b-fc784788da58.PNG)\
The docker build scripts require environment variables to be set before execution.  

2) [CLI](https://github.com/Azure/pcs-cli): This submodule contains cli source code, which can be used to deploy azure resources or create basic or standard deployments of the product.  

3) [Services](https://github.com/Azure/remote-monitoring-services-dotnet): This submodule is a link to the repository containing all the microservices.  

4) [Webui](https://github.com/Azure/pcs-remote-monitoring-webui): This submodule is a link to ui component of the project. 
&nbsp;  

5) [Reverse-proxy](https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet/tree/master/reverse-proxy): This submodule is a link to the repository containing preconfigured nginx used as a load balancer. 
