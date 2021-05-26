#Function to create function apps in powershell
#To do- Add exception handling if resource or name exists
function Create-FunctionApp{
    param (
        # Parameter: Resource Group Name
        [Parameter(Mandatory)]
        [string] $RGName,

        [Parameter(Mandatory)]
        [string] $name,
        # Must be lowercase
        [Parameter(Mandatory)]
        [string] $storageAcctname
    )

    az storage account create --name $storageAcctname `
                              --resource-group $RGName

    $plan = az functionapp plan create -g $RGName `
                                -n $($name + 'plan') `
                                --min-instances 1 `
                                --max-burst 5 `
                                --sku EP1
    $plan
    
    az functionapp create -g $RGName `
                          -n $name `
                          -p $($name + 'plan') `
                          --runtime powershell `
                          -s $storageAcctname `
                          --functions-version 2

}