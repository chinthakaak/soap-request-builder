#SOAP Request Builder
A command line interface for soap request sending.

#Installation
##Prerequisites
soap-request-builder software requires Linux OS and this has been tested in CentOS 6.6 only.

##Installation Steps
1. Download and install following software from the web.
    1. xmlstarlet - tested version is 1.5.0
    2. curl - tested version is 7.19.7 (x86_64-redhat-linux-gnu)
    3. ant - tested version is 1.8.2
    4. java - tested version is 1.7
    5. soapui - tested version 5.0.0

3. Pull the master branch of the soap-ui-builder software from github to a local folder.

git init
git pull 
e.g. /home/srbuser/soap-request-builder/
4. Copy all the soapui lib jar files from soapui installation location.

e.g. cp /data/SmartBear/SoapUI-5.0.0/lib/*.jar /home/srbuser/soap-request-builder/lib
5. Copy soapui executable jar file to 
e.g. cp /data/SmartBear/SoapUI-5.0.0/bin/soapui-5.0.0.jar /home/srbuser/soap-request-builder/lib
6. Execute local installation shell script from /home/srbuser/soap-ui-builder/ location.

   e.g. ./local-clean-install.sh

#Your First SOAP Request

#Testing

#Features

#Limitations
