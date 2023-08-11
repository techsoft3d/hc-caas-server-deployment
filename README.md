# Deploy a fully scalable backend for HOOPS Commmunicator via an AMI or Docker in less than 20 minutes




## Version Update (0.3.0) 
* Initial Release
* Based on HOOPS Communiator 2023 SP2


## Quick Access to latest version:
AMI: 	caas-ubuntu-0.3.0-public (available in us-east-1, us-west-2, eu-west-1, ap-northeast-1)  
Docker Image: eric5544/caas_complete


## Introduction
We have recently released CaaS, which is a fully scalable conversion, streaming and model management backend for HOOPS Communicator. If you are a node.js user, it is fairly straightforward to get up and running with CaaS. However, there is still a bunch of initial configuration required. In addition, you need to setup your machine to run HOOPS Communicator, which can be a bit of a pain. To make things easier, we have packaged up all of CaaS, including the User Management Component as well as two front-end reference applications and of course HOOPS Communicator itself into a a pre-configured Ubuntu Linux AMI (Amazon Machine Image). In addition, we have also created a Docker Image that can be deployed on any backend that supports Docker.

For questions/feedback please send an email to guido@techsoft3d.com or post in our [forum](https://forum.techsoft3d.com/). For a 60 day trial of the HOOPS Web Platform go to [Web Platform](https://www.techsoft3d.com/products/hoops/web-platform).

**The AMI and Docker Image are not an officially supported part of HOOPS Communicator and provided as-is.**


## What are you getting
Using the prebuilt AMI or Docker image you get without any extra work:
* A full scalable conversion and streaming backend for HOOPS Communicator you can access server-side via a node module or REST API. This includes token based access control and account management. It means that with a few lines of code you can convert CAD files and make them accessible for streaming (or SCS) within your web-application.
* A User Management node module with Hub and Project support, including a full front-end reference application which you can use as a starting point for your own development.
* A "personal" version of demo.techsoft3d.com



## How to use this Github Project?
**There is no need to use to use this project directly unless you want to build your own AMI or Docker Image manually. Simply follow the instructions below (starting with [Prerequisites](#prerequisites)) to use the prebuild AMI or Docker Image instead.**  
This GitHub Project serves as the template for the AMI/Docker which contains all the necessary files to build an AWS AMI (or similar on Azure, etc.) with CaaS or an equivalent Docker Image.
* If you are creating an AMI, simply checkout this project into your main user folder. Depending on which version of linux you are using, you might need to make changes to the config file paths. You also of course need to make sure that all necessarily libraries and dependencies for CaaS and HOOPS Communicator itself are installed.

* If you are building the docker image (from the provided Dockerfile), make sure that updateHC.sh points to a valid HOOPS package. If you want to include the HOOPS demo into the docker image, also make sure to run the updateHCDemo.sh script to ensure that the demo project is in the right place.


## Prerequisites

* A valid HOOPS Communicator License

### AMI
* An AWS account with the ability to deploy EC2 instances

### Docker

* A machine that supports Docker


## Getting Started with the AMI

### Step 1: Launch a new EC2 Instance

* Login to your AWS account and navigate to the EC2 Dashboard
* Ensure that you are in a region that has the AMI available. Currently the AMI is available in the following regions:
  * US East (N. Virginia) us-east-1
  * US West (Oregon) us-west-2
  * Europe (Ireland) eu-west-1
  * Asia Pacific (Tokyo) ap-northeast-1  
  * If you need to deploy CaaS in a different region and want to use the AMI simply create a new CaaS AMI from an EC2 instance in one of the above regions and then copy it to the region of your choice.
* Click on the "Launch Instance" button  
<img src="readmeImages/launchInstance.png" alt="Alt text" width="600"/>
* Under "Applications and OS Images select "Browse More AMI's"
* Click on Community AMI's, search for "caas". The current AMI name is "caas-ubuntu-0.3.0-public"  
<img src="readmeImages/selectAMI.png" alt="Alt text" width="900"/>
* Select the instance type. We recommend at least a t2.medium instance so there is enough memory for the conversion process.
* Create a new keypair or select an existing key-pair for this instance. As this will be a linux instance, the recommended way is to use RSA key-pairs with the .ppk format for use with Putty later.  
<img src="readmeImages/keypair.png" alt="Alt text" width="600"/>
* Click on "Edit Network Settings and ensure that Auto-assign Public IP is set to "Enable"
* Create a new security group or choose an existing one. For initial testing only the SSH Port 22 as well as Port 80 needs to be open. However, to run CaaS as part of a scalable backened you also need to open port 3001.  
<img src="readmeImages/ports.png" alt="Alt text" width="900"/>
* Launch the instance and wait for it to start up. This can take a few minutes.
* As soon as the instance is running CaaS is already active. You can test this by navigating to the status page of the instance. This is the public IP address of the instance followed by "caas_um_api/status". For example: http://3.87.229.101/caas_um_api/status. The screen should look like this:  
<img src="readmeImages/statusPage.png" alt="Alt text" width="600"/>

### Step 2: Setting your HOOPS Communicator License Key
Without the license key, neither the streaming nor the file conversion will work. If you are a partner you will find your license key at our [developer portal](https://developer.techsoft3d.com/). If you are evaluating HOOPS Communicator, you find the evaluation key on your account page in our [manage portal](https://manage.techsoft3d.com/). Its also inside the evaluation package in quick_start/server_config.js (at the bottom of the file).  
  
To set the license you need to login to the instance and update the communicatorLicense.txt file. The best way to do this (on windows) is either to use Putty or a utility like FileZilla. You will definitely need to login to the instance for any further configuration so I recommend setting up Putty right now, which should be very straightforward. If you are on linux or mac, feel free to use the ssh client of your choice and skip the Putty setup.

* Download Putty from [here](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
* Start Putty and use the following format to define the username for the instance ( ubuntu@public_IP_address_of_the_instance ). In addition choose SSH as the protocol and Port 22.  
<img src="readmeImages/putty1.png" alt="Alt text" width="600"/>
* Navigate to Connection->SSH->Auth->Credentials and select the .ppk file that you created when you launched the instance.  
<img src="readmeImages/putty2.png" alt="Alt text" width="600"/>
* Save the configuration and click on "Open". This will open a terminal window. You should now be connected to the instance.
* Open the communicatorLicense.txt file in a text editor:  
``nano communicatorLicense.txt``
* Copy your license key (without quotes) into this file and save it. (on windows you can copy and paste by right clicking into the terminal window)

**You can skip the next chapter and go right to [Testing your new Instance of CaaS](#testing-your-new-instance-of-caas) if you are not interested in the Docker based deployment**

## Getting Started with Docker

### Step 1: Installing Docker in your environment

#### Windows
* Download and install Docker Desktop from [here](https://www.docker.com/products/docker-desktop)
* Ensure WSL 2 is enabled and all other requirements for docker are met.

#### Linux
* Follow the instructions for your distribution from [here](https://docs.docker.com/engine/install/)
* For Amazon linux specifically the following steps should be sufficient to get docker installed:  
```
sudo yum install -y docker
sudo chkconfig docker on
sudo usermod -a -G docker ec2-user
sudo reboot
```
### Step 2: Running the CaaS Docker Image
* Pull the latest preview version of the CaaS Docker image from docker hub:  
``docker pull eric5544:caas_complete``
* Create a new file called communicatorLicense.txt in your user directory and copy the HOOPS Communicator license key into it
* Run the docker image (make sure to map port 80 to port 80 on the host machine and mount the license file):  
``docker run -p 80:80 -v ${PWD}/communicatorLicense.txt:/app/communicatorLicense.txt eric5544/caas_complete``
* The docker container will now start up and run CaaS which can be accessed as described in the next chapter. However all the data is ephemeral and will be lost when the docker container is stopped or the host machine is rebooted. To persist the data you need to mount two volumes to the docker container, one for all the upload and converted files and one for the mongoDB database. In order to do this:
* create two directories on your host machine:  
```
mkdir tempData
mkdir mongoData
```
* Shutdown the currently running container ( `docker stop $(docker ps -aq)` )

* In addition to those two directories, we will also mount the configuration file for CaaS so that we can make changes to it later. We start by copying the version contained in the currently running docker container to your local folder. (Alternatively you can also use the file in this github project called "caasComplete/config/docker.json")  
 ``docker cp <containerid>:/app/caasComplete/config/local.json ${PWD}/local.json``

* Run the docker container again, this time also mounting the two directories and the configuration file:  
``docker run -p 80:80 -v ${PWD}/communicatorLicense.txt:/app/communicatorLicense.txt  -v ${PWD}/tempData:/app/tempData  -v ${PWD}/mongoData:/var/lib/mongodb -v ${PWD}/local.json:/app/caasComplete/config/local.json eric5544/caas_complete``  
* After those steps the CaaS docker container will now persist its data and is locally configurable.


### Testing your new Instance of CAAS

Caas should now be fully running in its basic configuration (either via the AMI or via Docker), meaning as a single machine performing streaming, CAD conversion as well as running the database backend and file storage. In addition, the machine runs a webserver serving up the two included reference applications. This is a good starting point for testing/development. We will get into more advanced configurations later. For now, lets test the instance. (If you are using CaaS locally via Docker, you can access the demo apps via localhost instead of the public IP address)

* We already mentioned the status page for the instance in Step 1 which can be accessed with the public IP address of the instance followed by "caas_um_api/status". For example: http://3.87.229.101/caas_um_api/status. This page contains the status for all conversion and streaming servers. It also retrieves the version of CaaS as well as the up-time for the instance. It will also show a list of all converted and streamed models.
* Next let's navigate to the demo page by using the public ip of your instance followed by /demo.techsoft3d.com. (Example: http://3.87.229.101/demo.techsoft3d.com/). This page is an exact copy of the demo page on our [website](https://demo.techsoft3d.com/) without the sample files. The only difference is that it is served up by your instance and uses its own CaaS backend. This means that you can now test your own models on this page with no connection to Tech Soft 3D's servers. Simply upload them and they will be converted and streamed by your instance. Please note that the demo is designed to automatically create a fresh project when it is accessed from different browsers. It will also delete projects after they haven't been accessed for 24 hours. In addition any restart of the server will also reset existing projects. Feel free to modify the source code of the demo to change this behavior or make other changes.
* The initial configuration of the AMI/Docker Image also serves up a more advanced reference application with full account handling and support for Hubs and Projects with fine grain control of access rights for each user. To access this application, navigate to the public ip of your instance followed by /um_app (Example: http://3.87.229.101/um_app). Start by registering a new user to the system. The rest should be self explanatory.

## Administering your Instance of CaaS
The AMI is configured to run with PM2 which automatically restarts the server in case of a crash. It also auto-restarts CaaS on reboot. If you want to stop caas manually you can do so by running the following command:  
``pm2 stop``   
You can then manually start CaaS in the foreground by running the ``./startAll.sh`` script, however you should only do this for debugging purposes as this will not restart CaaS in case of a crash. 

All console messages (error and regular messages) are logged and available in the `.pm2/logs` folder. 

If you make any changes to the configuration, Caas needs to be restarted for those changes to take effect. The easiest way to do this is by simply rebooting the instance with ``sudo reboot``. On every restart the node packages of CaaS will be updated to the latest minor version. If you want to prevent this, you can comment out the releveant lines in ``startAll.sh``

The AMI/Docker Image comes with a current version of HOOPS Communicator (see release notes on top of this page for the version used). If you want to update it to the latest version, you can do so by either manually replacing the content of the HOOPS Communicator linux package in the HOOPS_Communicator folder or by running the ``updateHC.sh`` script. This script will look for a package of HOOPS Communicator at the public URL specified in the first line of the script. You can use a service like dropbox, etc or use a public S3 bucket to host the package in that case for use with the script. Tech Soft 3D currently does not provide public links to HOOPS Communicator packages. Be aware that both HOOPS Communicator reference applications are built with a specific versionof HOOPS Communicator that needs to match the HOOPS Communicator package used, so you should only update if this version matches the package version.

We have also provided a script to update the HOOPS Communicator demo to the latest version called ``updateHCDemo.sh``. This script will download the latest version of the HOOPS Communicator demo from github and replace the existing version. Once again, you should ensure that the updated version will work with the version of HOOPS Communicator that is currently installed. 

Just to be clear again, to ensure that the instance is not receiving any updates and stays in its original state make sure the two lines that update the node projects (``npm update ...``) are commented out and  do not run the ``updateHC.sh`` or the ``updateHCDemo.sh`` script which both are only run manually.


## Setting up a distributed environment
The real power of CaaS is its ability to scale and run in a multi-region distributed environment, meaning you can run multiple instances of CaaS, each performing conversion or streaming all connected to each-other. In order to facilitate that two requirements will have to be met:
* Each of the CaaS servers need to be connected to a common database instance
* Each of the CaaS Servers need to be connected to a common file storage (e.g. S3 or Azure Blob Storage)

In addition, it is obviously desirable to run the front-end via SSL. This is also very easy to do and we will cover it as well.

### Step 1: Connecting to a common database
For convenience purposes, the AMI/Docker Image already comes with a preconfigured local MongoDB instance. However, this is not a good solution for a distributed environment. Instead, you should use a common MongoDB instance that is accessible from all your CaaS instances. The easiest way to do this is to use MongoDB Atlas. You can sign up for a free account [here](https://www.mongodb.com/cloud/atlas).  If you wan to setup your own mongoDB instance instead, that is also very straightforward wit many preconfigured mongoDB AMI's available. Dockerhub also has a mongoDB image available. In any case, once you have a separate mongoDB instance running, you need to configure CaaS to use it. This is done by editing the local.json file of CaaS. If you are using the AMI you will find it in the caasComplete/config/local.json. If you are using the Docker Image, you will find it in the folder you mounted to the docker container as described in the previous chapter. Look for the "mongoDBURI" entry and replace it with the URI of your mongoDB instance.  
```
{
    "hc-caas": {
      "mongodbURI": "mongodb://adminUser:ts3d@127.0.0.1:27017/conversions?authSource=admin",
...

  "hc-caas-um": {
      "mongodbURI": "mongodb://adminUser:ts3d@127.0.0.1:27017/caas_demo_app?authSource=admin",
...
```

If you are using the AMI, you will notice that mongodb is already preconfigured with an administrator user so access to mongoDB is already secure. This means that for testing purposes you can use one of the CaaS instances as your database instance as well. In that case, all you have to do is open the mongoDB port (27017) in the security group of your instance to make the database accessible from the other instances. However, this is not recommended for production environments.

If you are running mongoDB separately, you should not run the built-in mongoDB instance. To disable it, you can set the nomongo environment variable on the instance (in docker: -e nomongo=true when starting the container) or just delete the lines that start mongoDB from the startAll.sh script.

Make sure to restart the instance (sudo reboot) or the container for the changes to take affect.


### Step 2: Connecting to a common file store
The AMI/Docker Image is preconfigured for local file storage. However, this is not a good solution for a distributed environment. Instead, we will be using S3 as our common storage environment. Azure Blob Storage is also supported but we will not discuss it here. In order to use s3 the following steps are required:

* Create an S3 bucket in your AWS account. Access should NOT be public
* Navigate to "Permissions" and set the Cross-origin resource sharing (CORS) policy to the following. This is needed to support token based direct upload/downloads to this bucket:
 
```
[
    {
        "AllowedHeaders": [
            "*"
        ],
        "AllowedMethods": [
            "GET",
            "PUT",
            "POST",
            "DELETE"
        ],
        "AllowedOrigins": [
            "*"
        ],
        "ExposeHeaders": []
    }
]
```
* Open the local.json file and update the "storage" category for s3 as shown below:
```
  "storage": {
      "type": "S3",
      "destination": "mybucketname",
  },
```
* You will also need to set two environment variables to access EC2 resources. You should set those variables in your linux environment. If you are using the AMI, you can set them in the /etc/environment file. If you are using the Docker Image, you can set them in the docker run command via the -e option. The variables are:
```
AWS_ACCESS_KEY_ID  
AWS_SECRET_ACCESS_KEY
```
In the AMI you can also set them inside the startAll.sh script that starts CaaS (in Docker you can mount this file and do the same). Locate the lines below at the top of the file and set the variables there:
```
#export AWS_ACCESS_KEY_ID=DUMMY
#export AWS_SECRET_ACCESS_KEY=DUMMY 
```

Make sure to restart the instance (sudo reboot) or the container for the changes to take effect.

### Step 3: Deplying a separate conversion server
Now that we have a common database and file storage, we can create a separate server that only deals with converting models. It is highly recommended to run CAD conversions separate from the streaming server, the modelManager and the webserver as converting a model can consume a lot of CPU resources and memory and starve other processes. It is also the component most likely to crash and by running it separately, you can ensure that the other components of CaaS are not affected. To deploy a conversion server you need to:

* Follow the above steps to create a new EC2 instance from the AMI or run a new container on a separate machine from the Docker Image
* Make sure that your HOOPS Communicator license is set
* Set the environment variables for accessing S3 storage 
* Open the local.json file (caasComplete/config/local.json) for the **new** instance in your editor of choice.
* Edit the json file so that its content looks like the example below. That means:
  * Setting the mongodbURI correctly so that it points to a common mongoDB instance. If you are using the first instace as your mongoDB instance, you will need to use the ip of that instance (instead of 127.0.0.1) in the connection string and open port 27017 on the first instance.
  * Use S3 storage as described above, pointing to the same bucket you used in the first instance
  * Turn off the streaming server and the model manager on this instance and do not serve up the user management component and the demo websites as this instance should used be used for CAD conversion.
  * In the case of docker make sure to replace the paths (/home/ubuntu/...) with (/app/...)

```
{
    "hc-caas": {
      "mongodbURI": "mongodb://adminUser:ts3d@127.0.0.1:27017/conversions?authSource=admin",
      "workingDirectory": "/home/ubuntu/tempData",
      "runModelManager": false,
      "runStreamingServer": false,
      "runConversionServer": true,
      "fullErrorReporting": true,
      "serviceIP": "",
      "licenseFile": "/home/ubuntu/communicatorLicense.txt",
      "conversionServer": {
        "name": "CaaS Conversion",
        "converterpath": "/home/ubuntu/HOOPS_Communicator/authoring/converter/bin/linux64"
      },
      "localCache": {
        "maxSize": 500
      },
      "storage": {
        "type": "S3",
        "destination": "mycaasfiles"
      }
    },
    "startCaaS" : true,
    "startUM" : false,
    "startProxy" : false,
    "serveHCDemoSite": false
  }      
```
* In the config.json file of your **first** instance set "runConversionServer" to false in the json file and reboot the system (this ensures that conversions will only be performed on the second instance)
* Reboot the second instance.
* Navigate to the caas status page (http://ipofyourfirstinstance/caas_um_api/status) and make sure that the new conversion server is correctly registered. If you had the conversion server running before on the first instance it will still show up in the list but with an "Offline" status. That is expected. It will be removed from the list after 24 hours.


## Using SSL

If you are using a proxy like nginx, you will most likely handle your own SSL certificates. In that case you can skip the first part of this chapter. 

### Setting up the SSL certificates

* Generate/locate your SSL certificates. You will need a certificate file and a key file. 
* Setup your domain name to point to your instance. If you are using AWS, you can use Route 53 to do that. 
* Place your certificate and key file in the `cert` folder of your instance (though any other location is also ok). In case of docker make sure to mount this folder to the container.
* Open the local.json file and point  `keyPath` and `certPath` in the `ssl` category to your certificate and key-file
```
 "ssl": {
    "keyPath":"/home/ubuntu/cert/mykey.key",
    "certPath":"/home/ubuntu/cert/e49c8b6306111d3e.crt"
  },
```

### Setting up the public URL
* Specifiy the public url for the streaming server in the `streamingServer` category. This is needed so that the streaming server can generate the correct websocket url for the client. 
```
  "streamingServer": {
      "name": "CaaS Streaming US",     
      "scserverpath": "/home/ubuntu/HOOPS_Communicator/server/bin/linux64",
      "publicURL": "wss://my.public.url:443",    
    },
```    
* Use your public url for the CaaS-UM in the `hc-caas-um` category. If your CaaS instance is just performing conversions then neither the streamingServer setup nor setting the publicURL is necessary.
```
     "hc-caas-um": {
    "mongodbURI": "mongodb://myUserAdmin:abc123@54.67.101.212:27017/caas_demo_a>
    "demoProject":"648f234d48418720ce36e878",
    "publicURL": "https://caas.techsoft3d.com:443",
    "useStreaming": true,
    "useDirectFetch": true,
    "demoUser": "demo@techsoft3d.com",
    "demoUserPassword": "demo",
    "demoUserHUB": "demo"
  },
```
* Restart the instance or the container for the changes to take effect.

For Docker, make sure to replace the paths (/home/ubuntu/...) with (/app/...) in the above snippets.





