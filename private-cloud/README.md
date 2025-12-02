# Supernote Private Cloud Helper Guide

This is a curated list of tips and tricks I have gathered (and tested) after setting up my own instance of Supernote's Private Cloud.

The official documentation can be a little bit of a hit and a miss. This guide adds more detail and clarification to the official documentation.

[Official Private Cloud Docs](https://support.supernote.com/en_US/Whats-New/setting-up-your-own-supernote-private-cloud-beta)

[Script Deployment Manual](https://ib.supernote.com/private-cloud/Supernote-Private-Cloud-Deployment-Manual.pdf)

[Docker Manual](https://ib.supernote.com/private-cloud/Supernote-Private-Cloud-Manual-Deployment-Method-Using-Docker-Containers.pdf)

If you find this guide helpful, consider buying me a coffee.

[![ko-fi](https://ko-fi.com/img/githubbutton_sm.svg)](https://ko-fi.com/J3J6BINRX)

## Background

This guide is intended for users getting into self hosting. I would love to have Supernote Private Cloud running on a Raspberry Pi, but Supernote has not released support for Arm architecture yet. Supernote Private Cloud is not compatible with Windows.

## Install Steps (Full Guide)

### Install docker

Supernote Private Cloud runs on Docker containers. So, the first step is to get Docker installed.

I recommend taking a look at the installation guide below and following all the steps if you don't have Docker installed already.

[Docker Install Guide](https://docs.docker.com/engine/install/debian/#install-using-the-repository)

Here are the steps for a fresh install if you don't want to read the guide.

Docker requires ```root``` privileges for pretty much all its commands. So, this is a good time to login as root. If you are logged in as another user use ```sudo su``` to become root.

```
# Add Docker's official GPG key:
apt update
apt install ca-certificates curl
install -m 0755 -d /etc/apt/keyrings
curl -fsSL https://download.docker.com/linux/debian/gpg -o /etc/apt/keyrings/docker.asc
chmod a+r /etc/apt/keyrings/docker.asc

# Add the repository to Apt sources:
tee /etc/apt/sources.list.d/docker.sources <<EOF
Types: deb
URIs: https://download.docker.com/linux/debian
Suites: $(. /etc/os-release && echo "$VERSION_CODENAME")
Components: stable
Signed-By: /etc/apt/keyrings/docker.asc
EOF

apt update
```

Install the latest version

```
apt install docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin
```

Make sure it is running

```
systemctl status docker
```

Test it with a Hello-World container

```
docker run hello-world
```

### Create Directories

> [!NOTE]
> Supernote recommends at least 50GB of disk space available for the application + data.

Create an installation directory, this will hold our configuration files and notes data once the virtual cloud software is installed.

```
mkdir -pv /data/supernote 
cd /data/supernote
```

Next, download the database initialization file. Note that this url is incorrectly formatted in the original documentation. 

```
curl -O https://supernote-private-cloud.supernote.com/cloud/supernotedb.sql
```

Create the folders where the data will persist even if you destroy the Docker containers.

```
mkdir -pv {sndata/cert,supernote_data}
```

### Create environment variables file

The Docker Compose file uses a series of variables from this environment file. Keep in mind this will save your passwords in plain text and there is risk involved with this. Since this guide is geared towards the self hosting crowd, this might be an acceptable approach to you.

References:

[MariaDB Docker Hub](https://hub.docker.com/_/mariadb)

[MariaDB Docker Variables](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/mariadb-server-docker-official-image-environment-variables)

[Redis Docker Hub](https://hub.docker.com/_/redis/)

Assuming you are still under ```/data/supernote```

```
nano .env
```

Copy and past the content below. Make sure to change the values between ```<>```. For example, ```<mysqlrootpassword>``` becomes ```strongpassword```

```
# Databases settings
DB_HOSTNAME="supernote-mariadb"
MYSQL_ROOT_PASSWORD="<mysqlrootpassword>"
MYSQL_DATABASE="supernotedb"
MYSQL_USER="<supernote>"
MYSQL_PASSWORD="<supernotedbpassword>"

# Redis settings
REDIS_HOST="supernote-redis"
REDIS_PASSWORD="<supernoteredispassword>"
REDIS_PORT="6379"
```

The Supernote documentation has an additional HTTPS/SSL section defining a domain name and cert names. I intentionally left this part out of the ```.env``` file as we will address HTTPS/SSL later in this guide (Nginx Proxy Manager to manage HTTPS certs).


### Docker Compose file

Still in the ```/data/supernote``` directory, download the docker compose file from this repo.

```
curl -o https://raw.githubusercontent.com/camerahacks/super-supernote/refs/heads/main/private-cloud/docker-compose.yml
```

> [!NOTE]
> I chose to expose the mariaDB port ```3306``` outside of the Docker container. This allows for easy database backup and management using a script or a database management too like [MySQL Workbench](https://www.mysql.com/products/workbench/). Exposing port ```3306``` is not strictly needed and you can delete the lines below from ```docker-compose.yml``` if you don't want this port to be exposed.

```yml
ports:
      - "3306:3306"
```

Update the ```notelib``` and ```supernote-service``` image versions, if needed. Supernote doesn't provide a ```latest``` tag, so you have to change the version in the compose file.

```
nano docker-compose.yml
```
Update the versions (in this case ```6.9.3``` and ```25.11.24```) to the newest versions available on Docker Hub.

[supernote/notelib on Docker Hub](https://hub.docker.com/r/supernote/notelib)

[supernote/supernote-service on Docker Hub](https://hub.docker.com/r/supernote/supernote-service)

```yml
notelib:
  image: docker.io/supernote/notelib:6.9.3 <--- version to update if needed
  container_name: notelib

supernote-service:
  image: docker.io/supernote/supernote-service:25.11.24 <--- version to update if needed
```

### Start the containers

Everything is configured and we are ready to start the containers to deploy.

```
docker-compose up -d
```

> [!WARNING]
> You might be tempted to connect your Supernote device to your shiny new private cloud instance at this pont. DON'T!
> Currently, Chauvet versions 3.25.39 (Manta/Nomad) and 2.23.36 (A5X and A6X) require a *factory reset* to switch private cloud providers.
> Make sure your Supernote Private Cloud is working appropriately before connecting a Supernote device. It's better to test with a Supernote Partner app first.

At this point, the Supernote Private Cloud should be accessible through HTTP only (no encryption). You can navigate to ```cloudIP:19072``` and start using your private server. But, if you are planning on opening this application to the broader internet, you should be using HTTPS for a secure connection.

### Get a Domain Name

Using the IP address through HTTP is a completely acceptable solution, but it will give you so many headaches down the line.

Just because you will be using a domain name, it doesn't mean your private cloud needs to be accessible to the internet. Registering a domain name just means you can use it however you want. Even if for the sole purpose of not having to remember which service is hosted at which IP address.

A major benefit of having a domain name is that you can obtain a (free) SSL certificate to use with your Supernote Private Cloud. Yes, I am aware self-signed certificates exist, but most browsers will still give you a warning that your connection is not secure when using self-signed certificates. There is a reason for that.

My preferred domain name registrar is [CloudFlare](https://domains.cloudflare.com/).

### Install Nginx Proxy Manager

> [!NOTE]
> Proxy Manager should be installed using the default ports 80 and 443. If you have a local DNS like pi.hole running on port 80/443, make sure to change it to a different port before installing Proxy Manager.
> Pi.hole is perfectly happy running on ports 8080/8443.

Installing Proxy Manager is not required but it will make your life so much easier. It will allow you to setup a secure connection between the Supernote device and the reverse proxy. Also, you can use Nginx Proxy Manager (NPM) for any other self-hosted service you might already have.

Nginx Proxy Manager is just a graphical configuration tool for Nginx. Nginx is an enterprise grade web server.

Create an installation directory

```
mkdir -pv /data/proxymanager
cd /data/proxymanager
```

Follow the instructions on the official [Nginx Proxy Manager website](https://nginxproxymanager.com/setup/).

Here is a [list of world timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones) to add to your Proxy Manager Docker compose file.

### Configure Proxy Manager

Once Nginx and Proxy Manager are up and running, navigate to ipaddress:81 to access Proxy Manager's dashboard page.

From there, add a Proxy Host.

On the Details tab, choose a subdomain for your cloud network. In my case, I chose ```sn.example.com```.

Leave the scheme as ```http```.

Forward Hostname/IP should be the ip address for the machine that is running Supernote Private Cloud.

Forward Port should be ```19072```.

Move to the Custom locations tab.

Enter ```/``` as the location and enter the same information for Scheme, IP, and Forward Port.

Click on the gear icon next to location and enter the settings below.

```
proxy_set_header X-Forwarded-Host $host;
proxy_set_header X-Forwarded-Port $server_port;
```

Now, go to the Advanced tab and enter the same settings again. I honestly don't think this does anything but it can't hurt.

```
proxy_set_header X-Forwarded-Host $host;
proxy_set_header X-Forwarded-Port $server_port;
```

### Configure SSL/HTTPS

Nginx Proxy Manager can request and maintain an SSL certificate for our domain.

In Proxy Manager, click on SSL Certificates and add a new Let's Encrypt Certificate.

Next, enter the same domain/sub-domain used to configure the Proxy Host. ```sn.example.com``` is the domain name we have been using in this guide.

If the Supernote Private Cloud is not exposed to the internet, you will have to use a DNS Challenge to verify that you control the domain name. Choose your DNS provider and follow the instructions.

## Ready to Roll

At this point, you should have Supernote Private Cloud accessible through a secure connection to your server. You can follow the steps on the official guide on how to configure an email account and register new users.

## Backup Strategy

Although Private Cloud sync offers some data redundancy, it is not considered a backup strategy. You should backup the data stored in ```/data/supernote/supernote_data``` in a safe location. 

I find the easiest way to backup the files from the private cloud is to mount a NAS share and use ```rsync``` with the ```-a``` flag to archive all the files. The ```-a``` flag is important because it doesn't delete any files from the destination folder if it is not present in the source folder. So, if I accidentally delete a file and only notice it after performing sync, the file is preserved in a separate backup location.

In the example below, a NAS shared folder is mounted to ```/mnt/supernote-files/``` on the machine running the private cloud software. You can setup a cron job to run this command on a regular basis.

```sh
rsync -a /data/supernote/supernote_data/ /mnt/supernote-files/
```

In addition to backing up the document and note files, you could backup the MariaDB database. This would theoretically allow you to reinstate the database in case it gets corrupted. I have not tested reinstating the database from a backup file yet, so take this recommendation with a grain of salt.