# Deploy a fully scalable backend for HOOPS Commmunicator via an AMI or Docker in less than 20 minutes


## Introduction
We have recently released CaaS, which is a fully scalable conversion, streaming and model management backend for HOOPS Communicator. If you are a node.js user, it is fairly straightforward to get up and running with CaaS. However, there is still a bunch of initial configuration required. In addition, you need to setup your machine to run HOOPS Communicator, which can be a bit of a pain. To make things easier, we have packaged up all of CaaS, including the User Management Component as well as two front-end reference applications and of course HOOPS Communicator itself into a a pre-configured AMI (Amazon Machine Image). In addition, we have also created a Docker Image that can be deployed on any backend that supports Docker.


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
  * If you need to deploy CaaS in a different region and want to use the AMI simply create a new AMI from an EC2 instance in one of the above regions and then copy it to the region of your choice.
* Click on the "Launch Instance" button  
<img src="readmeImages/launchInstance.png" alt="Alt text" width="600"/>
* Under "Applications and OS Images select "Browse More AMI's"
* Click on Community AMI's, search for "caas". The current AMI name is "caas-ubuntu-0.3.0-public"  
<img src="readmeImages/selectAMI.png" alt="Alt text" width="900"/>
* Select the instance type. We recommend at least a t2.medium instance so there is enough memory for the conversion process.
* Create a new keypair or select an existing key-pair for this instance. As this will be a linux instance, the recommend way is to use RSA key-pairs with the .ppk format for use with Putty later.  
<img src="readmeImages/keypair.png" alt="Alt text" width="600"/>
* Click on "Edit Network Settings and ensure that Auto-assign Public IP is set to "Enable"
* Create a new security group or choose an existing one. For initial testing only the SSH Port 22 as well as Port 80 needs to be open. However, to run CaaS as part of a scalable backened you also need to open port 3001.  
<img src="readmeImages/ports.png" alt="Alt text" width="900"/>
* Launch the instance and wait for it to start up. This can take a few minutes.
* As soon as the instance is running CaaS is already active. You can test this by navigating to the status page of the instance. This is the public IP address of the instance followed by "caas_um_api/status". For example: http://3.87.229.101/caas_um_api/status. The screen should look like this:  
<img src="readmeImages/statusPage.png" alt="Alt text" width="600"/>

### Step 2: Setting your HOOPS Communicator License Key
Without the license key, neither the streaming nor the file conversion will work. If you are a partner you will find your license key at our [developer portal](https://developer.techsoft3d.com/). If you are evaluating HOOPS Communicator, you find the evaluation key on your account page in our [manage portal](https://manage.techsoft3d.com/). Its also inside the evaluation package in quick_start/server_config.js (at the bottom of the file).  
  
To set the license you need to login to the instance and update the communicatorLicense.txt file. The best way to do this is either to use Putty or a utility like FileZilla.  You will definitely need to login to the instance for any further configuration so I recommend setting up Putty right now, which should be very straightforward:

* Download Putty from [here](https://www.chiark.greenend.org.uk/~sgtatham/putty/latest.html)
* Start Putty and use the following format to define the username for the instance ( ubuntu@public_IP_address_of_the_instance ). In addition choose SSH as the protocol and Port 22.  
<img src="readmeImages/putty1.png" alt="Alt text" width="600"/>
* Navigate to Connection->SSH->Auth->Credentials and select the .ppk file that you created when you launched the instance.  
<img src="readmeImages/putty2.png" alt="Alt text" width="600"/>
* Save the configuration and click on "Open". This will open a terminal window. You should now be connected to the instance.
* Open the communicatorLicense.txt file in a text editor:  
``nano communicatorLicense.txt``
* Copy your license key (without quotes) into this file and save it.

You can skip the next chapter and go right to testing your new instance if you are not interested in the Docker based deployment.

## Getting Started with Docker

### Step 1: Installing Docker in your environment

#### Windows
* Download and install Docker Desktop from [here](https://www.docker.com/products/docker-desktop)
* Ensure WSL 2 is enabled and all other requirements for docker are met.

#### Linux
* Follow the instructions for your distribution from [here](https://docs.docker.com/engine/install/)
* For Amazon linux specifically the following steps are required:  
```
sudo yum install -y docker
sudo chkconfig docker on
sudo usermod -a -G docker ec2-user
sudo reboot
```
### Step 2: Running the CaaS Docker Image
* Pull the latest preview version of the CaaS docker image from docker hub:  
``docker pull eric5544:caas_complete``
* Create a new file called communicatorLicense.txt in your user directory and copy the HOOPS Communicator license key into it
* Run the docker image:  
``docker run -p 80:80 -v ${PWD}/communicatorLicense.txt:/app/communicatorLicense.txt eric5544/caas_complete``

### Testing your new Instance of CAAS

Caas is now fully running on this instance in its basic configuration (either via the AMI or via Docker), meaning its a single machine performing streaming, CAD conversion as well as running the database backend and file storage. In addition, it runs a webserver serving up the two included reference applications. This is a good starting point for testing/development. We will get into more advanced configurations later. For now, lets test the instance. (If you are running CaaS locally via Docker, you can access it via localhost instead of the public IP address)

* We already mentioned the status page for the instance in Step 1 which can be accessed with the public IP address of the instance followed by "caas_um_api/status". For example: http://3.87.229.101/caas_um_api/status. This page contains the status for all conversion and streaming servers. It also retrieves the version of CaaS as well as the up-time for the instance. It will also show a list of all converted and streamed models.
* Next let's navigate to the demo page by using the public ip of your instance followed by /demo.techsoft3d.com. (Example: http://3.87.229.101/demo.techsoft3d.com/). This page is an exact copy of the demo page on our [website](https://demo.techsoft3d.com/) without the sample files. The only difference is that it is served up by your instance and uses its local backend. This means that you can now test your own models on this page. Simply upload them and they will be converted and streamed by your instance.
* The initial configuration of the AMI/Docker Image also server a more advanced reference application with full account handling and support for Hubs and Projects with fine grain control of access rights for each user. To access this application navigate to the public ip of your instance followed by /um_app (Example: http://3.87.229.101/um_app )



### Next Steps
The real power of CaaS is its ability to scale and run in a multi-region distributed environment, meaning you can run multiple instances of CaaS, each performing conversion or streaming all connected to each-other. In order to facilitate that two requirements will have to be met:
* Each of the CaaS servers need to be connected to a common database instance
* Each of the CaaS Servers need to be connected to a common file storage (e.g. S3 or Azure Blob Storage)

In addition, 








