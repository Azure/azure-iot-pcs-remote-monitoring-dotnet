Setting Up Azure Dev Spaces for Remote Monitoring Services
==========================================================

The following should be done for any of the Remote Monitoring web services where you'd like to use [Azure Dev Spaces][azds] with Visual Studio. Examples below use `asamanager` as the microservice, but similar steps would be used for other services.

*Remember that [Azure Dev Spaces][azds] is in preview and subject to change.*

## Prerequisites

1. Create a [Kubernetes cluster (AKS) enabled for Azure Dev Spaces](https://docs.microsoft.com/en-us/azure/dev-spaces/get-started-netcore-visualstudio#create-a-kubernetes-cluster-enabled-for-azure-dev-spaces)


1. Install the [Visual Studio Tools for Kubernetes][azds-vs] extension.

1. Pull the code from the repo: [azure-iot-pcs-remote-monitoring-dotnet](https://github.com/Azure/azure-iot-pcs-remote-monitoring-dotnet)


## Create your Dev Space

1. Open the solution in Visual Studio.

1. For the service you're configuring, right click on the `WebService` project in the Solution Explorer then click `Set as StartUp Project`.

1. Open the emulator drop down which is next to the green `Run` button (it likely says `IIS Express`. Select `Azure Dev Spaces` from the drop down.

1. In the dialog that comes up (you might have to login), select the [Azure Kubernetes Service][aks] cluster you created above.

1. In spaces, create a new space. 

1. Select it to be publicly accessible.

This will create dev space for you in the cluster. For more information on how to use a dev space, see [Team Development with Azure Dev Spaces][azds-team]. 


## Modify the configuration

As part of the [Azure Dev Spaces][azds] set up, files are added to the `WebService` project. These will need to be modified to match our configuration.

1. In the newly created `WebService/charts` folder, rename the `webservice` folder as the microservice name: `asamanager`.
    
1. Replace string `webservice` with the microservice name (`asamanager`) in **ALL** of the following
    1. All files under the `WebService/charts` folder and its subdirectories.
    1. `WebService/azds.yaml`
    1. `Dockerfile`
    1. `Dockerfile.develop`
    
    Examples:
        ```
        name: asamanager
        ```
        or 
        ```
        {{- define "asamanager.name" -}}
        ```

1. In the `WebService/charts/asamanager/values.yml` file, set the service ports. Remove the `port` setting under `service`. Instead, add `internalPort` and `externalPort`.
    ```
    service:
        type: ClusterIp
        internalPort: 9024
        externalPort: 9024
    ```
    - For asamanager, the port is `9024`. This will be different for other services.

1. In the `WebService/charts/asamanager/templates/service.yaml` file, change the ports under the `spec` subsection to use the `internalPort` and `externalPort` settings.
    ```
    - port: {{ .Values.service.externalPort }}
        targetPort: {{ .Values.service.internalPort }}
        protocol: TCP
    name: http
    ```

1. Create a new entrypoint script called `azds_entrypoint.sh`. This will set up the required environment variables and run the service.
    ```
    export PCS_SAMPLE_ENVIRONMENT_VAR=sampleValue
    ...
    rem --- insert actual environment variables here ---
    ...
    echo "Set environment variables"
    env | grep PCS
    echo "Run ASA manager..."
    sleep 20
    dotnet run --no-restore --no-build --no-launch-profile
    ```
    - Check the `WebService/appsettings.ini` file for more on which environment variables are required by the service.

1.	In Dockerfile
    1. Change the command to expose port out of the container (instead of 80)
        ```
        EXPOSE 9024
        ```
    1. Add a command to copy the entrypoint script after the `COPY` lines for each of the `*.csproj` files.
        ```
        COPY ["asa-manager/WebService/azds_entrypoint.sh", "asa-manager/WebService/azds_entrypoint.sh"]
        ```
    1. Change the `ENTRYPOINT` command at the end of the file to run our new script.
        ```
        ENTRYPOINT  ["sh", "/src/asa-manager/WebService/azds_entrypoint.sh"]
        ```

1. In Dockerfile.develop
    1. Change the command to expose port out of the container (instead of 80)
        ```
        EXPOSE 9024
        ```
    1. Add a command to copy the entrypoint script after the `COPY` lines for each of the `*.csproj` files.
        ```
        COPY ["asa-manager/WebService/azds_entrypoint.sh", "asa-manager/WebService/azds_entrypoint.sh"]
        ```
    1. Add a command to allow execute permissions on the entrypoint script.
        ```
        RUN chmod 777 /src/asa-manager/WebService/azds_entrypoint.sh
        ```
    1. Change the `ENTRYPOINT` command at the end of the file to run our new script.
        ```
        ENTRYPOINT  ["sh", "/src/asa-manager/WebService/azds_entrypoint.sh"]
        ```

**Congratulations, you should be able to use your dev space now.**
For more information on how to use it, see [Team Development with Azure Dev Spaces][azds-team]. 


## More Information
- [Azure Kubernetes Service][aks]
- [Azure Dev Spaces][azds]
- [Visual Studio Tools for Kubernetes][azds-vs]
- [Team Development with Azure Dev Spaces][azds-team]



[aks]: https://azure.microsoft.com/en-us/services/kubernetes-service
[azds]: https://docs.microsoft.com/en-us/azure/dev-spaces/azure-dev-spaces
[azds-vs]: https://aka.ms/get-azds-visualstudio
[azds-team]: https://docs.microsoft.com/en-us/azure/dev-spaces/team-development-netcore-visualstudio