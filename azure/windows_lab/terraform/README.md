# cloud-resume
# Setup authentication to Azure

## Install AzureCLI (Skip if already installed)
```shell
brew update && brew install azure-cli
```
## Login to Azure via Azure CLI
```shell
az login
```
- This will open a web page in your browser; follow the login prompts. 
- One can also register via device code if a web browser is not available on the system you would like to register
  - `az login --use-device-code`

## Configure an Azure Service Principal (not required)

#### Set environment variable (Only required if you want to configure a Service Principal)
```shell
export MSYS_NO_PATHCONV=1
```
- valid only for current terminal session

#### Create Service Principal (not required)
```shell
az ad sp create-for-rbac --name {SP_NAME} --role Contributor --scopes /subscriptions/{SUB_ID}
```
- replace `{SP_NAME}` with your preferred custom name for this service principal. 
- After this completes, it will output several parameters [appId, password, tenant]
- The password value cannot be retrieved moving forward (only reset), save these values somewhere safe for later retrieval. 

e.g. 
```shell
az ad sp create-for-rbac --name custom-name-for-service-principle --role Contributor --scopes /subscriptions/{SUB_ID}
Creating 'Contributor' role assignment under scope '/subscriptions/{SUB_ID}'
The output includes credentials that you must protect. Be sure that you do not include these credentials in your code or check the credentials into your source control. For more information, see https://aka.ms/azadsp-cli
{
  "appId": "12345678-1234-1234-1234-123456789012",
  "displayName": "custom-name-for-service-principle",
  "password": "given-password-for-azure-service-principle",
  "tenant": "12345678-1234-1234-1234-123456789012"
}
```

#### Add the outputs to your ~/.bashrc (only required for Service Principal)
```shell
export ARM_SUBSCRIPTION_ID="{azure_subscription_id}"
export ARM_TENANT_ID="{azure_subscription_tenant_id}"
export ARM_CLIENT_ID="{service_principal_appid}"
export ARM_CLIENT_SECRET="{service_principal_password}"
```
- Replace the values for each of the above variables with what was output from the Service Principal section.
- Paste into your ~/.bashrc (or ~/.zshrc)
- run `source ~/.bashrc` (or `source ~/.zshrc`) to add these new values to your current environment. It will automatically be added to all new terminal sessions
- run `printenv | grep "^ARM*"` to confirm these variables have been added to your environment variables




# How to Deploy a Lab Environment

## Prepare for Terraform Initialization 
- Move your directory to the terraform directory
- The following procedure will not work unless terraform and azurecli have already been installed
### Example:
- Assuming you are in the Git Repo directory, run the following command
```shell
cd azure/terraform
```
- Your working directory should now look like this:
```shell
{git_path}/azure/terraform
```

## Initialize Terraform for deployment
- `{LAB_NAME}` is an arbitrary value that refers to the name you would like to like to name your lab. This value must be the same throughout the deployment process. This must be overwritten and needs to be a unique value such as `cwe1234` or `cve2023-1234`. This will also be the name of the resource group deployed in Azure. 
- `-var-file` is a file which contains several variables that are pre-configured for the researchers and ensures a smooth deployment
- run `pwd` to verify you are in the correct directory
- The following procedure will not work unless terraform and azurecli have already been installed

```shell
terraform init -upgrade -backend-config="key={LAB_NAME}.terraform.tfstate" -reconfigure
```

Example
```shell
terraform init -upgrade -backend-config="key=deploy-test.terraform.tfstate" -reconfigure
```

- Your output should be something similar to this:
```shell
Upgrading modules...
- compute in modules/compute
- network in modules/network
- storage in modules/storage

Initializing the backend...

Successfully configured the backend "azurerm"! Terraform will automatically
use this backend unless the backend configuration changes.

Initializing provider plugins...
- Finding hashicorp/azurerm versions matching "3.34.0"...
- Finding hashicorp/random versions matching "3.4.3"...
- Using previously-installed hashicorp/azurerm v3.34.0
- Using previously-installed hashicorp/random v3.4.3

Terraform has been successfully initialized!

You may now begin working with Terraform. Try running "terraform plan" to see
any changes that are required for your infrastructure. All Terraform commands
should now work.

If you ever set or change modules or backend configuration for Terraform,
rerun this command to reinitialize your working directory. If you forget, other
commands will detect it and remind you to do so if necessary.
```

## Plan your Lab Deployment
- `{LAB_NAME}` is an arbitrary value that refers to the name you would like to like to name your lab. This value must be the same throughout the deployment process. This must be overwritten and needs to be a unique value such as `cwe1234` or `cve2023-1234`. This will also be the name of the resource group deployed in Azure. 
- `-var-file` is a file which contains several variables that are pre-configured for the researchers and ensures a smooth deployment
- This step is not neccessary so feel free to skip, however it can identify issues before creating resources in Azure

```shell
terraform plan -var-file=env_vars/default.tfvars -var="lab_id={LAB_NAME}"
```

Example:
```shell
terraform plan -var-file=env_vars/default.tfvars -var="lab_id=deploy-test"
```

## Deploy your Lab Environment
- `{LAB_NAME}` is an arbitrary value that refers to the name you would like to like to name your lab. This value must be the same throughout the deployment process. This must be overwritten and needs to be a unique value such as `cwe1234` or `cve2023-1234`. This will also be the name of the resource group deployed in Azure. 
- `-var-file` is a file which contains several variables that are pre-configured for the researchers and ensures a smooth deployment
- The `apply` command will prompt you before it deploys. This prompt requires you to type `yes`. 
- Should you not want to answer the prompt each time, you can pass the `-auto-approve` argument. Example of this is below
```shell
terraform apply -var-file=env_vars/default.tfvars -var="lab_id={LAB_NAME}"
```

### Examples: 
Standard Deployment:
```shell
terraform apply -var-file=env_vars/default.tfvars -var="lab_id=deploy-test"
```

Standard Deployment using `-auto-approve` argument:
```shell
terraform apply -var-file=env_vars/default.tfvars -var="lab_id=deploy-test" -auto-approve
```

The end of the output should look similar to this:
```shell
Plan: 64 to add, 0 to change, 0 to destroy.

Changes to Outputs:
  + bastion_fqdn           = (known after apply)
  + rg_id                  = (known after apply)
  + rg_location            = "eastus"
  + rg_name                = "deploy-test-rg"
  + sa_name                = (known after apply)
  + windows_admin_password = (sensitive value)

Do you want to perform these actions?
  Terraform will perform the actions described above.
  Only 'yes' will be accepted to approve.

  Enter a value:
```
## Accesing Lab Environment
- Go to https://portal.azure.com/
- Follow the logon prompts as required
- Open `Subscriptions` and navigate to the appropriate one where your lab is deployed.
- In the sidebar (on the left) navigate to `Resource groups` and click on the appropriate resource group as specified by the `rg_name` output from the deployment. This will also match the `LAB_NAME` specified during deployment without the added suffix `-rg`.

### Accessing Virtual Machines
- At this point you should see a list of resources. Feel free to sort by `Type` to easily identify your Virtual Machines (VMs).
- Click on any VM you would like to access.
- You should now see a `Connect` drop-down listed on the top bar. Choose this, and then click `Bastion`.
- Follow the credentials listed in `Bastion Credentials` for which credentials to use for each VM. 
- Additionally, under the `Connection Settings` drop-down you are able to select either SSH or RDP as well as what port you would like to connect over. 
  - Typically for Windows, this will be RDP and for Linux, this will be SSH. Using something like xRDP will enable GUI access on Linux and enable you to RDP into it. 

### Accessing Storage within the Lab
- Each lab is deployed with a `Storage Account` (SA), which is similar to an S3 Bucket from AWS. This is where you can store data that you need to import or export from the lab such as files, screenshots, or PCAPs. 
- Please note, the entirety of the SA will be removed, including all data and files, when the lab is torn down. I recommned exporting all files needed before the lab is destroyed. There is no way to recover deleted data. This is permanent. 
- Within the SA, in the sidebar you will see `Containers` and `File shares` under the `Data Storage` category. 
 - `Containers` is purely object storage.
 - `File shares` can be mounted via SMB or NFS. Scripts will be deployed to each VM that will allow you to do this on a per VM basis. 
  - For Windows, these scripts can be found in `C:\terraform`. For Linux, they will be in the home directory of the user created by terraform.
  - File shares will be the easiest method of moving artifacts in/out of the lab environment.  


## Bastion Credentials for Lab Environment
### Windows Hosts
`azureuser` | `password`
- password can be exported from host where lab was deployed by running the following command
```shell
terraform output -raw windows_admin_password
```

#### Commando VM
`azureuser` | `Azureuser123!`

### Kali Host
`kali` | `ssh_key`
- ssh key can be found in cloned git repo in the following path
- Use the private key found in this path.
- For the Bastion connection options, use `SSH Private Key from Local File`
`.../azure/terraform/modules/compute/ssh/`

## Tear Down the Lab Environment
- `{LAB_NAME}` is an arbitrary value that refers to the name you would like to like to name your lab. This value must be the same throughout the deployment process. This must be overwritten and needs to be a unique value such as `cwe1234` or `cve2023-1234`. This will also be the name of the resource group deployed in Azure. 
- `-var-file` is a file which contains several variables that are pre-configured for the researchers and ensures a smooth deployment
- The `destroy` command will prompt you before it tears down the environment. This prompt requires you to type `yes`. 
- Should you not want to answer the prompt each time, you can pass the `-auto-approve` argument. Example of this is below

```shell
terraform destroy -var-file=env_vars/default.tfvars -var="lab_id={LAB_NAME}"
```

### Examples:
Standard Deployment:
```shell
terraform destroy -var-file=env_vars/default.tfvars -var="lab_id=deploy-test"
```

Standard Deployment using `-auto-approve` argument:
```shell
terraform destroy -var-file=env_vars/default.tfvars -var="lab_id=deploy-test" -auto-approve
```

# How to obtain PCAPs from the environment

Prerequisites:
- Azure CLI must be installed
- Network Watcher Extension is installed on the VM from which the PCAP is being captured on
- Network Watcher is running in the region where the environment is deployed
- A storage account is deployed in the lab

## Start PCAP

- `-g` is the resource group name
- `-n` is the name of the packet capture
- `--time-limit`
		- Maximum duration of the capture session in seconds.
	- `--capture-limit`
		- The maximum size in bytes of the capture output.
	- `--capture-size`
		- Number of bytes captured per packet. Excess bytes are truncated.
	- `--filters`
		- JSON encoded list of packet filters. Use `@{path}` to load from file.
```shell
az network watcher packet-capture create -g {INSERT_RESOURCE_GROUP_NAME} -n {INSERT_NAME_OF_CAPTURE} --vm {INSERT_NAME_OF_VM} --storage-account {INSERT_SA_NAME_VALUE}
```

### Examples:

Standard Packet Capture
```shell
az network watcher packet-capture create -g deploy-test-rg -n capture-name-0 --vm wks-win10-0 --storage-account tfst12345
```

Packet Capture with Time Limit set
- this remove the requirement for running the 'Stop PCAP' command
```shell
az network watcher packet-capture create -g deploy-test-rg -n capture-name-0 --vm wks-win10-0 --storage-account tfst12345 --time-limit 5
```

Packet Capture with Filters enabled
```shell
az network watcher packet-capture create -g deploy-test-rg -n capture-name-0 --vm wks-win10-0 \
    --storage-account tfst12345 --filters '[ \
        { \
            "protocol":"TCP", \
            "remoteIPAddress":"1.1.1.1-255.255.255", \
            "localIPAddress":"10.0.0.3", \
            "remotePort":"20" \
        }, \
        { \
            "protocol":"TCP", \
            "remoteIPAddress":"1.1.1.1-255.255.255", \
            "localIPAddress":"10.0.0.3", \
            "remotePort":"80" \
        }, \
        { \
            "protocol":"TCP", \
            "remoteIPAddress":"1.1.1.1-255.255.255", \
            "localIPAddress":"10.0.0.3", \
            "remotePort":"443" \
        }, \
        { \
            "protocol":"UDP" \
        }]'
```

### Check Status of Packet Capture

Examples:
```shell
az network watcher packet-capture show-status --location eastus --name capture-name
```

## Stop PCAP
- `-n` is the name of the packet capture
- `-l` is location (Region the lab is deployed in. Typically either eastus or westus)

```shell
az network watcher packet-capture stop -n {INSERT_NAME_OF_CAPTURE} -l {INSERT_REGION_WHERE_LAB_IS_DEPLOYED}
```

### Example
Stops a previously run packet capture
```shell
az network watcher packet-capture stop -n capture-name-0 -l eastus
```

## Download PCAP
- The PCAP will save to current directory in CLI
- `--file` the name of the downloaded file. This can be found at the end of the URI
- `--blob-url` This value is provided by the `start pcap` output under `storagePath`
- `--container-name` this value will be the same each time. This is the container create within the storage account. This is the root directory within the SA.
```shell
az storage blob download --account-name {INSERT_SA_NAME_VALUE} --container-name network-watcher-logs --auth-mode key --blob-url {INSERT_URI_FROM_PCAP_START_COMMAND} --file {INSERT_NAME_OF_PCAP_FILE}.cap
```

### Example
```shell
az storage blob download --account-name tfst12345 --container-name network-watcher-logs --auth-mode key --blob-url https://tfst12345.blob.core.windows.net/network-watcher-logs/subscriptions/{SUB_ID}/resourcegroups/deploy-test-rg/providers/microsoft.compute/virtualmachines/wks-win10-0/2023/12/12/packetcapture_11_11_22_22.cap --file packetcapture_11_11_22_22.cap
```
