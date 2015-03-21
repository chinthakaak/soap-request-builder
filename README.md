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
    5. junit - tested version is 4.9b2
    6. soapui - tested version 5.0.0

2. Pull the master branch of the soap-ui-builder software from github to a local folder

   `cd /home/srbuser/soap-request-builder/`
   
   `git pull https://github.com/chinthakaak/soap-request-builder.git`
3. Copy all the soapui lib jar files from soapui installation location to lib folder

   `cp /data/SmartBear/SoapUI-5.0.0/lib/*.jar /home/srbuser/soap-request-builder/lib`
4. Copy soapui executable jar file to lib folder
 
    `cp /data/SmartBear/SoapUI-5.0.0/bin/soapui-5.0.0.jar /home/srbuser/soap-request-builder/lib`
5. Copy junit jar to lib folder

    `cp junit-4.9b2.jar /home/srbuser/soap-request-builder/lib`
6. Execute local installation shell script from soap-request-builder local location.

    `./local-clean-install.sh`

#Your First SOAP Request
After the successful installation of soap-request-builder command line interface(CLI) application, you are ready to execute your first soap request using the terminal.

There are two free web service endpoints have been pre-configured for testing and getting started with this CLI.

1. http://www.predic8.com:8080/crm/CustomerService
2. http://www.webservicex.net/globalweather.asmx

## Testing CustomerService web service endpoint

