@echo off
echo "=================================================== PREREQUISITES ===================================================="
echo "Step #0) Install Azure CLI (https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-install/)"
echo "Step #1) Login into proper subscription (https://azure.microsoft.com/en-us/documentation/articles/xplat-cli-connect/)"
echo "======================================================================================================================"

echo "Step #2) Configure Azure CLI to be used in ARM (Azure Resource Manager) mode"
call azure config mode arm

echo "Step #3) Create a Resource Group"
call azure group create --name "MesosRG" --location "westus"

echo "Step# 4) Create the Virtual Network (192.168.0.0/16)"
call azure network vnet create ^
	--resource-group "MesosRG" ^
	--name "MesosVN" ^
	--address-prefixes 192.168.0.0/16 ^
	--location "westus"

echo "Step #5) Create MesosMaster SubNet (192.168.1.0/29)"
call azure network vnet subnet create ^
	--resource-group "MesosRG" ^
	--vnet-name "MesosVN" ^
	--name "MesosMasterSubNet" ^
	--address-prefix 192.168.1.0/29

echo "Step #6) Create MesosSalve SubNet (192.168.2.0/29)"
call azure network vnet subnet create ^
	--resource-group "MesosRG" ^
	--vnet-name "MesosVN" ^
	--name "MesosSlaveSubNet" ^
	--address-prefix 192.168.2.0/29

echo "Setp #7) Create Mesos Master Availability Set"
call azure availset create ^
	--resource-group "MesosRG" ^
	--name "MesosMasterAS" ^
	--location "westus"

echo "Setp #8) Create Mesos Slave Availability Set"
call azure availset create ^
	--resource-group "MesosRG" ^
	--name "MesosSlaveAS" ^
	--location "westus"

echo "Step #9) Create NIC for MesosMaster-1 having ip 192.168.1.4 (192.168.1.1/192.168.1.2/192.168.1.3 are reserved by Azure)"
call azure network nic create ^
	--resource-group "MesosRG" ^
	--name "MesosMaster-1-NIC" ^
	--location "westus" ^
	--private-ip-address 192.168.1.4 ^
	--subnet-vnet-name "MesosVN" ^
	--subnet-name "MesosMasterSubNet"

echo "Step #10) Create NIC for MesosMaster-2 having ip 192.168.1.5 (192.168.1.1/192.168.1.2/192.168.1.3 are reserved by Azure)"
call azure network nic create ^
	--resource-group "MesosRG" ^
	--name "MesosMaster-2-NIC" ^
	--location "westus" ^
	--private-ip-address 192.168.1.5 ^
	--subnet-vnet-name "MesosVN" ^
	--subnet-name "MesosMasterSubNet"

echo "Step #11) Create NIC for MesosMaster-3 having ip 192.168.1.6 (192.168.1.1/192.168.1.2/192.168.1.3 are reserved by Azure)"
call azure network nic create ^
	--resource-group "MesosRG" ^
	--name "MesosMaster-3-NIC" ^
	--location "westus" ^
	--private-ip-address 192.168.1.6 ^
	--subnet-vnet-name "MesosVN" ^
	--subnet-name "MesosMasterSubNet"

echo "Step #12) Create NIC for MesosSlave-1 having ip 192.168.2.4 (192.168.2.1/192.168.2.2/192.168.2.3 are reserved by Azure)"
call azure network nic create ^
	--resource-group "MesosRG" ^
	--name "MesosSlave-1-NIC" ^
	--location "westus" ^
	--private-ip-address 192.168.2.4 ^
	--subnet-vnet-name "MesosVN" ^
	--subnet-name "MesosSlaveSubNet"

echo "Step #13) Create NIC for MesosSlave-1 having ip 192.168.2.5 (192.168.2.1/192.168.2.2/192.168.2.3 are reserved by Azure)"
call azure network nic create ^
	--resource-group "MesosRG" ^
	--name "MesosSlave-2-NIC" ^
	--location "westus" ^
	--private-ip-address 192.168.2.5 ^
	--subnet-vnet-name "MesosVN" ^
	--subnet-name "MesosSlaveSubNet"

echo "Step #14) Create NIC for MesosSlave-1 having ip 192.168.2.6 (192.168.2.1/192.168.2.2/192.168.2.3 are reserved by Azure)"
call azure network nic create --resource-group "MesosRG" ^
	--resource-group "MesosRG" ^
	--name "MesosSlave-3-NIC" ^
	--location "westus" ^
	--private-ip-address 192.168.2.6 ^
	--subnet-vnet-name "MesosVN" ^
	--subnet-name "MesosSlaveSubNet"
	
echo "Step #15) Create Static Public IP for MesosMaster-1"
call azure network public-ip create ^
	--resource-group "MesosRG" ^
	--name "MesosMaster-1-PIP" ^
	--location "westus" ^
	--allocation-method "Static"

echo "Step #16) Create Static Public IP for MesosMaster-2"
call azure network public-ip create ^
	--resource-group "MesosRG" ^
	--name "MesosMaster-2-PIP" ^
	--location "westus" ^
	--allocation-method "Static"

echo "Step #17) Create Static Public IP for MesosMaster-3"
call azure network public-ip create ^
	--resource-group "MesosRG" ^
	--name "MesosMaster-3-PIP" ^
	--location "westus" ^
	--allocation-method "Static"

echo "Step #18) Create Static Public IP for MesosSlave-1"
call azure network public-ip create ^
	--resource-group "MesosRG" ^
	--name "MesosSlave-1-PIP" ^
	--location "westus" ^
	--allocation-method "Static"

echo "Step #19) Create Static Public IP for MesosSlave-2"
call azure network public-ip create ^
	--resource-group "MesosRG" ^
	--name "MesosSlave-2-PIP" ^
	--location "westus" ^
	--allocation-method "Static"

echo "Step #20) Create Static Public IP for MesosSlave--1"
call azure network public-ip create ^
	--resource-group "MesosRG" ^
	--name "MesosSlave-3-PIP" ^
	--location "westus" --allocation-method "Static"

echo "Step #21) Create storage account for OS and Data - Please remember that Azure Storage account name are globally scoped (https://blogs.msdn.microsoft.com/jmstall/2014/06/12/call azure-storage-naming-rules/)"
call azure storage account create ^
	--resource-group "MesosRG" ^
	--location "westus" ^
	--type "LRS" "mrtranquimesossa"

echo "Step #22) Create MesosMaster-1 VM"
call azure vm create ^
	--resource-group "MesosRG" ^
	--name "MesosMaster-1" ^
	--location "westus" ^
	--vm-size "Basic_A0" ^
	--vnet-name "MesosVN" ^
	--vnet-subnet-name "MesosMasterSubNet" ^
	--availset-name "MesosMasterAS" ^
	--nic-name "MesosMaster-1-NIC" ^
	--public-ip-name "MesosMaster-1-PIP" ^
	--os-type "linux" ^
	--image-urn "credativ:Debian:8:8.0.201603020" ^
	--storage-account-name "mrtranquimesossa" ^
	--storage-account-container-name "vhds" ^
	--os-disk-vhd "OS-MesosMaster-1.vhd" ^
	--admin-username "MesosMaster1" ^
	--admin-password "@MesosMaster1"

echo "Step #23) Create MesosMaster-2 VM"
call azure vm create ^
	--resource-group "MesosRG" ^
	--name "MesosMaster-2" ^
	--location "westus" ^
	--vm-size "Basic_A0" ^
	--vnet-name "MesosVN" ^
	--vnet-subnet-name "MesosMasterSubNet" ^
	--availset-name "MesosMasterAS" ^
	--nic-name "MesosMaster-2-NIC" ^
	--public-ip-name "MesosMaster-2-PIP" ^
	--os-type "linux" ^
	--image-urn "credativ:Debian:8:8.0.201603020" ^
	--storage-account-name "mrtranquimesossa" ^
	--storage-account-container-name "vhds" ^
	--os-disk-vhd "OS-MesosMaster-2.vhd" ^
	--admin-username "MesosMaster2" ^
	--admin-password "@MesosMaster2"

echo "Step #24) Create MesosMaster-3 VM"
call azure vm create ^
	--resource-group "MesosRG" ^
	--name "MesosMaster-3" ^
	--location "westus" ^
	--vm-size "Basic_A0" ^
	--vnet-name "MesosVN" ^
	--vnet-subnet-name "MesosMasterSubNet" ^
	--availset-name "MesosMasterAS" ^
	--nic-name "MesosMaster-3-NIC" ^
	--public-ip-name "MesosMaster-3-PIP" ^
	--os-type "linux" ^
	--image-urn "credativ:Debian:8:8.0.201603020" ^
	--storage-account-name "mrtranquimesossa" ^
	--storage-account-container-name "vhds" ^
	--os-disk-vhd "OS-MesosMaster-3.vhd" ^
	--admin-username "MesosMaster3" ^
	--admin-password "@MesosMaster3"

echo "Step #25) Create MesosSlave-1 VM"
call azure vm create ^
	--resource-group "MesosRG" ^
	--name "MesosSlave-1" ^
	--location "westus" ^
	--vm-size "Basic_A0" ^
	--vnet-name "MesosVN" ^
	--vnet-subnet-name "MesosSlaveSubNet" ^
	--availset-name "MesosSlaveAS" ^
	--nic-name "MesosSlave-1-NIC" ^
	--public-ip-name "MesosSlave-1-PIP" ^
	--os-type "linux" ^
	--image-urn "credativ:Debian:8:8.0.201603020" ^
	--storage-account-name "mrtranquimesossa" ^
	--storage-account-container-name "vhds" ^
	--os-disk-vhd "OS-MesosSlave-1.vhd" ^
	--admin-username "MesosSlave1" ^
	--admin-password "@MesosSlave1"

echo "Step #26) Create MesosSlave-2 VM"
call azure vm create ^
	--resource-group "MesosRG" ^
	--name "MesosSlave-2" ^
	--location "westus" ^
	--vm-size "Basic_A0" ^
	--vnet-name "MesosVN" ^
	--vnet-subnet-name "MesosSlaveSubNet" ^
	--availset-name "MesosSlaveAS" ^
	--nic-name "MesosSlave-2-NIC" ^
	--public-ip-name "MesosSlave-2-PIP" ^
	--os-type "linux" ^
	--image-urn "credativ:Debian:8:8.0.201603020" ^
	--storage-account-name "mrtranquimesossa" ^
	--storage-account-container-name "vhds" ^
	--os-disk-vhd "OS-MesosSlave-2.vhd" ^
	--admin-username "MesosSlave2" ^
	--admin-password "@MesosSlave2"

echo "Step #27) Create MesosSlave-3 VM"
call azure vm create ^
	--resource-group "MesosRG" ^
	--name "MesosSlave-3" ^
	--location "westus" ^
	--vm-size "Basic_A0" ^
	--vnet-name "MesosVN" ^
	--vnet-subnet-name "MesosSlaveSubNet" ^
	--availset-name "MesosSlaveAS" ^
	--nic-name "MesosSlave-3-NIC" ^
	--public-ip-name "MesosSlave-3-PIP" ^
	--os-type "linux" ^
	--image-urn "credativ:Debian:8:8.0.201603020" ^
	--storage-account-name "mrtranquimesossa" ^
	--storage-account-container-name "vhds" ^
	--os-disk-vhd "OS-MesosSlave-3.vhd" ^
	--admin-username "MesosSlave3" ^
	--admin-password "@MesosSlave3"
	
