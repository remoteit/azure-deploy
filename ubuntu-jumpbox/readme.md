# Deploy a remote.it proxy server on Ubuntu.

<!--
<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/lamp-app/PublicLastTestDate.svg" />&nbsp;
<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/lamp-app/PublicDeployment.svg" />&nbsp;

<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/lamp-app/FairfaxLastTestDate.svg" />&nbsp;
<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/lamp-app/FairfaxDeployment.svg" />&nbsp;

<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/lamp-app/BestPracticeResult.svg" />&nbsp;
<IMG SRC="https://azurequickstartsservice.blob.core.windows.net/badges/lamp-app/CredScanResult.svg" />&nbsp;
-->


<a href="https://portal.azure.com/#create/Microsoft.Template/uri/https%3A%2F%2Fraw.githubusercontent.com%2remoteit%2Fzsure-deploy%2Fmaster%2Fubuntu-jumpbox%2Fazuredeploy.json" target="_blank"><img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/deploytoazure.png"/></a>

<a href="http://armviz.io/#/?load=https://raw.githubusercontent.com/remoteit/azure-deploy%2Fmaster%2Fubuntu-jumpbox%2Fazuredeploy.json" target="_blank"><img src="https://raw.githubusercontent.com/Azure/azure-quickstart-templates/master/1-CONTRIBUTION-GUIDE/images/visualizebutton.png"/></a>

This template uses the Azure Linux CustomScript extension to deploy a remote.it Jumpbox on headless Ubuntu. It creates an Ubuntu VM, does a silent install remote.it Jumpbox and registeres the Jumpbox to a remote.it account.   
