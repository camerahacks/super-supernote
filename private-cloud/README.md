# Supernote Private Cloud Helper Guide

This is a curated list of tips and tricks I have gathered (and tested) after setting up my own instance of Supernote's Private Cloud.

The official documentation can be a little bit of a hit and a miss. This guide adds more detail and clarification to the official documentation.

[Official Private Cloud Docs](https://support.supernote.com/en_US/Whats-New/setting-up-your-own-supernote-private-cloud-beta)

[Script Deployment Manual](https://ib.supernote.com/private-cloud/Supernote-Private-Cloud-Deployment-Manual.pdf)

[Docker Manual](https://ib.supernote.com/private-cloud/Supernote-Private-Cloud-Manual-Deployment-Method-Using-Docker-Containers.pdf)


## Background

This guide is intented for folks getting into self hosting. I would love to have Supernote Private Cloud running on a Raspberry Pi, but Supernote has not released support for Arm computers yet. Supernote Private Cloud is not compatible with Windows.

## Install Steps (Full Guide)

### Install docker

I recommend taking a look at the installation guide below and following all the steps if you don't have Docker installed alread.

[Docker Install Guide](https://docs.docker.com/engine/install/debian/#install-using-the-repository)

Here are the steps for a fresh install.

Docker requires ```root``` priviledges for pretty much all its commands. So, this is a good time to login as root. If you are logged in as another user use ```sudo su``` to become root.

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

### create directories

Supernote recommends at least 50GB of disk space available for the software + data.

Create an installation directory, this will hold our configuration files and notes data once the virtual cloud software is installed.

```
mkdir -pv /data/supernote 
cd /data/supernote
```

Next, download the db initialization file. Note that this url is incorrectly formatted in the original documenation. 

```
curl -O https://supernote-private-cloud.supernote.com/cloud/supernotedb.sql
```

Create the folders where the data will persist even if you destroy the Docker containers.

```
mkdir -pv {sndata/cert,supernote_data}
```

### Create environment variables file

The Docker Compose file uses a series of variables from this environment file. Keep in mind this will save your passwords in plain text and there is risk involved with this. Since this guide is geared towards the self hosting crowd, this might be an acceptable approach to you.

Reference:
[MariaDB Docker Hub](https://hub.docker.com/_/mariadb)

[MariaDB Docker Variables](https://mariadb.com/docs/server/server-management/automated-mariadb-deployment-and-administration/docker-and-mariadb/mariadb-server-docker-official-image-environment-variables)

[Redis Docker Hub](https://hub.docker.com/_/redis/)

Assuming you are still under ```/data/supernote```

```
nano .env
```

Copy and past the content below. Make sure to change the values between ```<>```. For example, ```<mysqlrootpassword>``` becomes ```strongpassword```

```
# Dtabases settings
DB_HOSTNAME="supernote-mariadb"
MYSQL_ROOT_PASSWORD="<mysqlrootpassword>"
MYSQL_DATABASE="supernotedb"
MYSQL_USER="<supernote>"
MYSQL_PASSWORD="<supernotedbpassword>"

# Redis setings
REDIS_HOST="supernote-redis"
REDIS_PASSWORD="<supernoteredispassword>"
REDIS_PORT="6379"
```

The Supernote documentation has an additional HTTPS/SSL section defining a domain name and cert names. I intentionally left this part out of the ```.env``` file as we will address HTTPS/SSL later in this guide (Nginx Proxy Manager to manage HTTPS certs).


### Docker Compose file

[List of Timezones](https://en.wikipedia.org/wiki/List_of_tz_database_time_zones)

Still in the ```/data/supernote``` directory, download the docker compose file from this repo.

```
curl -o https://raw.githubusercontent.com/camerahacks/super-supernote/refs/heads/main/private-cloud/docker-compose.yml
```

Udate the ```notelib``` and ```supernote-service``` image versions, if needed. Supernote doesn't provide a ```latest``` tag, so you have to change the version in the compose file.

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

### Install Nginx Proxy Manager
This step is not required but it will make your life so much easier. It will allow you to setup a secure connection between the Supernote device and . Also, you can use NPM for any other self-hosted service you might already have.

Create an installation directory

```
mkdir proxymanager
cd proxymanager
```

## Ports


## Folder Structure

## Nginx Reverse Proxy (Proxy Manager)