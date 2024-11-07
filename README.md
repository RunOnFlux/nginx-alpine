# Nginx Alpine Web Server with custom configurations.

## Current ENV variables

```HTML_DIR=${HTML_DIR:-/home/nginx/uploads}```

```CONF_FILE=${CONF_FILE:-/etc/nginx/conf.d/default.conf}```


## Build from source:

```git clone https://github.com/RunOnFlux/nginx-alpine.git```

```cd nginx-alpine```

```docker build -t yourusername/nginx:alpine-dev .```


## Getting Your Deployment Started On Flux ##

I will show you an example that you can use to deploy SFTP + Nginx containers on Flux to create a dynamic web server enviornment. 

The SFTP repo that is used in this example: ```https://hub.docker.com/r/atmoz/sftp/```

Please keep in mind, your user, uid, gid, and all directory paths specified in the Flux data field should be in harmony with directories set and used by the containers. The atmoz sftp server uses the username you specified to create the directory. ex ```/home/nginx``` 

In this example you will see that I chose to add an uploads directory as the directory for uploads to go and for nginx to use.

1: Login to FluxOS at https://home.runonflux.io or alternatively visit a node directly by its IP like this; https://a-nodes-ip-address-16126.node.home.runonflux.io 

(You can even use your own nodes - just input your IP in the placeholders)

2: Navigate to https://home.runonflux.io/apps/registerapp or https://a-nodes-ip-address-16126.node.home.runonflux.io/apps/registerapp

3: Click the "Import button" and paste the below message into the text box. You need to change the apps name, on the first line that has a value of "changeme"


```{"name":"changeme","compose":[{"name":"nginx","description":"","repotag":"wirewrex/nginx:alpine","ports":[39080,39443],"domains":["",""],"environmentParameters":[],"commands":[],"containerPorts":[80,443],"containerData":"g:/home/nginx/uploads/","cpu":0.3,"ram":300,"hdd":1,"tiered":false,"secrets":"","repoauth":""},{"name":"sftp","description":"","repotag":"atmoz/sftp:alpine","ports":[32222],"domains":[""],"environmentParameters":[],"commands":[],"containerPorts":[22],"containerData":"g:/etc/sftp|0:/home/nginx/uploads/","cpu":0.3,"ram":300,"hdd":2,"tiered":false,"secrets":"","repoauth":""}],"contacts":[],"description":"SFTP + NGINX Server","expire":21525,"geolocation":["acNA","a!cNA_US_Hawaii"],"hash":"7c31a3dc417d051542e53db452f83b0e5d77c492b220faf85263950c30423a72","height":1768904,"instances":3,"nodes":[],"owner":"14QJfVTFQdb34kw9MiAfW4apXgrcyULoEB","staticip":false,"version":7}```


4: Edit the "ports" if you want to use different port numbers for the public endpoints.

5: Edit the geographic locations that you want your nodes in if not sufficient.

6: Edit the amount of hardware resources you want your containers to have.

7: Sign the Message + Click Register App

8: Submit payment and wait a few minutes for the deployment to occur.



## Managing Your Deployment ##

After deployment, you will need to access the management section of Flux in order to securely configure your SFTP server.

1. You should still be logged in to FluxOS, you can navigate to https://home.runonflux.io/apps/myapps or https://a-nodes-ip-address-16126.node.home.runonflux.io/apps/myapps to get to the management section for your paid deployments. 

2. Click the "Manage" button off the right of your deployments name.

3. You will see a secondary sidebar. You can manage your instance from here.


### Public Endpoint For The Web Server ###

The public endpoints for your webserver will be as follows;

https://yourappname.app.runonflux.io

https://yourappname.app2.runonflux.io


ex. https://sftpnginx.app.runonflux.io/ & https://sftpnginx.app2.runonflux.io/


## Securing The SFTP Server ##


### Create + Upload Custom Users File ###

1. Create a file named users.conf and make note or remember where you saved it. 
   (You will need to upload it after it is edited.)

2. Edit the newly created users.conf file to include this line:

```nginx:FluxTestPass:101:101:uploads```

*Refer to the SFTP docker repo for a full explanation of how to specify users.

3. Change FluxTestPass to a secure password. Then save the file.

4. Upload the users.conf file to the sftp container using the "Interactive Terminal" tab found in the management secondary sidebar under "Component Control"  (Cloud with Up Arrow)

5. Click the "Control" tab found in the management secondary sidebar under "Local App Management"

6. Click "Restart App" from the Control section 

7. Click the "Logs" tab found in the management secondary sidebar under "Local App Management"

8. Select "sftp" from the Component dropdown & confirm that the logs say the server is listening on port 22


### Using Public/Private Key Only To Login The SFTP Server ###

1. You need to update the users.conf file; ```nginx::101:uploads```

2. You will need to copy your public key into the proper directory for your user and persist it.

```/home/nginx/.ssh/keys/```

You have a few options to do that. 

a. Build a new Docker image that copies in the pub key file

```FROM atmoz/sftp:latest COPY id_rsa.pub /home/nginx/.ssh/keys/id_rsa.pub:ro```

b. Rebuild the image so that it creates the public key file from reading the value of an ENV variable.

c. Store it in the already persisted ```/etc/sftp``` directory and copy it to ```/home/nginx/.ssh/keys/``` each time the container starts. (Might be able to run it as a secondary command directly from the command field in Flux, otherwise you would need to rebuild the image with custom entrypoints)


## Uploading Files To The Nginx Web Server ##


### Uploading Files via SFTP Server ###
Once you've confirmed that your SFTP is up and running from checking the logs, you can then go ahead and connect to it using the examples that are found below.

1. Make note of the "port" that you set that corresponds to port 22 in the sftp container. In the original example that port is 32222.

2. Make note of your app name.

3. Lets build your endpoint so that you can always access the live the sftp server that is running on Flux;
   
    *yourappname.app.runonflux.io:32222*

    *yourappname.app2.runonflux.io:32222*
 
    *IP:32222* will also work - you can get the master IP from "Running Instances" tab in the secondary sidebar.

4. Use the endpoint above along with the authentication method you chose to connect using a SFTP client.

5. Upload your files into the ```uploads``` folder



### Manually Uploading Files To The Web Server From FluxOS ###


You can also manually upload your files to the webserver without the need to use the sftp container. 


1. Upload the files to the **nginx** container using the "Interactive Terminal" tab found in the management secondary sidebar under "Component Control"  (Cloud with Up Arrow)


Just be sure to switch the dropdown menu to the correct component; **nginx**

