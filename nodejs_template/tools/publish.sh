#!/bin/bash

# Mutli-platform Publisher. Used to publish FaaS Inspector Node.js functions onto AWS Lambda, Google Cloud Functions, IBM
# Cloud Functions, and Azure Functions.
#
# Each platform's default function is defined in the platforms folder. These are copied into the source folder as index.js
# and deployed onto each platform accordingly. Developers should write their function in the function.js file. 
# All source files should be in the src folder and dependencies defined in package.json.
#
# This script requires each platform's CLI to be installed and properly configured to update functions.
# AWS CLI: apt install awscli 
# Google Cloud CLI: https://cloud.google.com/sdk/docs/quickstarts
# IBM Cloud CLI: https://www.ibm.com/cloud/cli
# Azure CLI: https://docs.microsoft.com/en-us/cli/azure/install-azure-cli?view=azure-cli-latest
#
# To use this script, create files to provide your function name. Function must have the same name on ALL platforms.
# file: parfunction   The name of the function.
#
# Choose which platforms to deploy to using command line arguments:
# ./publish.sh AWS GCF IBM AZURE MEMORY
# Example to deploy to AWS and Azure: ./publish.sh 1 0 0 1 1024
#
# WARNING for Azure: Azure Functions DOES NOT automatically download dependencies in the package.json file like IBM or Google. 
# You must manually install them to the ./tools directory and this script will automatically copy the node_modules folder and deploy it with your Azure function.


# Get the function name from the config.json file.
function=`cat ./config.json | jq '.functionName' | tr -d '"'`
functionApp=`cat ./config.json | jq '.azureFunctionApp' | tr -d '"'`

echo
echo Deploying $function....
echo

#Define the memory value.
memory=`cat ./config.json | jq '.memorySetting' | tr -d '"'`
if [[ ! -z $5 ]]
then
	memory=$5
fi

# Deploy onto AWS Lambda.
if [[ ! -z $1 && $1 -eq 1 ]]
then
	echo
	echo "----- Deploying onto AWS Lambda -----"
	echo
	
	# Destroy and prepare build folder.
	rm -rf build
	mkdir build
	mkdir build/node_modules
	
	# Copy files to build folder and create zip.
	cp -R ../src/* ./build
	cp -R ../platforms/aws/* ./build
	cp -R ../tools/node_modules/* ./build/node_modules
	zip -X -r ./build/index.zip ./build/*
	
	# Submit to AWS Lambda
	cd ./build
	aws lambda update-function-code --function-name $function --zip-file fileb://index.zip
	aws lambda update-function-configuration --function-name $function --memory-size $memory --runtime nodejs8.10
	cd ..
fi

# Deploy onto IBM Cloud Functions
if [[ ! -z $3 && $3 -eq 1 ]]
then
	echo
	echo "----- Deploying onto IBM Cloud Functions -----"
	echo
	
	# Destroy and prepare build folder.
	rm -rf build
	mkdir build
	mkdir build/node_modules
	
	# Copy files to build folder and create zip.
	cp -R ../src/* ./build
	cp -R ../platforms/ibm/* ./build
	cp -R ../tools/node_modules/* ./build/node_modules
	zip -X -r ./build/index.zip ./build/*
	
	# Submit to IBM Cloud Functions
	cd ./build
	ibmcloud fn action update $function --kind nodejs:8 --memory $memory index.zip
	cd ..
fi

# Deploy onto Azure Functions
if [[ ! -z $4 && $4 -eq 1 ]]
then
	echo
	echo "----- Deploying onto Azure Functions -----"
	echo
	
	# Destroy and prepare build folder.
	rm -rf build
	mkdir build
	mkdir build/node_modules
	mkdir build/$function
	
	# Copy and position files in the build folder.
	cp -R ../src/* ./build/$function
	mv ./build/$function/package.json ./build/package.json
	cp -R ../platforms/azure/* ./build
	mv ./build/index.js ./build/$function/index.js
	mv ./build/function.json ./build/$function/function.json
	cp -R ../tools/node_modules/* ./build/node_modules
	
	# Submit to Azure Functions
	cd ./build
	func azure functionapp publish $functionApp --force
	cd ..
fi

# Deploy onto Google Cloud Functions
if [[ ! -z $2 && $2 -eq 1 ]]
then
	echo
	echo "----- Deploying onto Google Cloud Functions -----"
	echo
	
	# Destroy and prepare build folder.
	rm -rf build
	mkdir build
	mkdir build/node_modules
	
	# Copy files to build folder.
	cp -R ../src/* ./build
	cp -R ../platforms/google/* ./build
	cp -R ../tools/node_modules/* ./build/node_modules
	
	# Submit to Google Cloud Functions
	cd ./build
	gcloud functions deploy $function --source=. --runtime nodejs8 --trigger-http --memory $memory
	cd ..
fi