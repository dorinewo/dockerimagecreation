#!/bin/bash

#Author: Apoti Eri (Lionel)

echo "Are you working on centos or ubuntu?"
read plat

if [ ${plat} = centos ]
then
yum install docker -y
fi

if [ ${plat} = ubuntu ]
then
apt-get install docker -y
fi

echo -e "What is your name please?\n"
read name

echo -e "What base image do you prefer? (centos, ubuntu, alpine)\n"
read base

echo -e "What version do you want please? (latest)?\n"
read ver

echo -e "What applications do you want installed in the docker image? (vim, httpd, curl, wget, docker, finger? (If there are multiple, please separate them with spaces)\n"
read app

echo -e "Do you want to have a port exposed? Which one please?(numbers only please)\n"
read port

echo -e "What is the name of the file or directory you want to copy into the image? NB: Please make sure that the script is in the same directory as the directory where that file or folder is found\n"
read file

echo -e "What name do you want to give to the folder which is going to be copy of this container on your system?\n"
read vol

echo -e "What port do you want to expose for the docker container that will be created?"
read port2

echo -e "Do you want the container to run in a detached mode once it has been created? Or do you prefer for it to be attached? (please select *d* for detached and *t* for attached\n"
read mode

if [ ${base} = centos ] -a [ ${mode} = d ]
then
sleep 3
echo -e "Building a ${base} image, version ${ver} with port ${port} opened and installing ${app}.\n"
sleep 3
echo -e "FROM ${base}:${ver}\nMAINTAINER ${name}\nRUN yum update -y\nRUN yum install ${app} -y\nRUN systemctl enable httpd\nRUN systemctl start httpd\nCOPY ./${file} /var/www/html\nEXPOSE ${port}\nCMD apachectl -D FOREGROUND" > dockerfile
docker build -t ${name}/${base}-httpd:${ver} .
docker push ${name}/${base}-httpd
echo -e "Running container in a detached mode"
docker run -idv ${v}:/var/www/html -p ${port2} ${name}/${base}-httpd bash
fi

if [ ${base} = centos ] -a [ ${mode} = t ]
then
sleep 3
echo -e "Building a ${base} image, version ${ver} with port ${port} opened and installing ${app}.\n"
sleep 3
echo -e "FROM ${base}:${ver}\nMAINTAINER ${name}\nRUN yum update -y\nRUN yum install ${app} -y\nRUN systemctl enable httpd\nRUN systemctl start httpd\nCOPY ./${file} /var/www/html\nEXPOSE ${port}\nCMD apachectl -D FOREGROUND" > dockerfile
docker build -t ${name}/${base}-httpd:${ver} .
docker push ${name}/${base}-httpd
echo -e "Running container in a detached mode"
docker run -itv ${v}:/var/www/html -p ${port2} ${name}/${base}-httpd bash
fi

if [ ${base} = alpine ] -a [ ${mode} = d ]
then
sleep 3
echo -e "Building a ${base} image, version ${ver} with port ${port} opened and installing ${app}.\n"
sleep 3
echo -e "FROM ${base}:${ver}\nMAINTAINER ${name}\nRUN apk update\nRUN apk add ${app}\nRUN systemctl enable httpd\nRUN systemctl start httpd\nCOPY ./${file} /usr/local/apache2/htdocs\nEXPOSE ${port}\nCMD apachectl -D FOREGROUND" > dockerfile
docker build -t ${name}/${base}-httpd:${ver} .
docker push ${name}/${base}-httpd
docker run -idv ${v}:/usr/local/apache2/htdocs -p ${port2} ${name}/${base}-httpd bash
fi

if [ ${base} = alpine ] -a [ ${mode} = t ]
then
sleep 3
echo -e "Building a ${base} image, version ${ver} with port ${port} opened and installing ${app}.\n"
sleep 3
echo -e "FROM ${base}:${ver}\nMAINTAINER ${name}\nRUN apk update\nRUN apk add ${app}\nRUN systemctl enable httpd\nRUN systemctl start httpd\nCOPY ./${file} /usr/local/apache2/htdocs\nEXPOSE ${port}\nCMD apachectl -D FOREGROUND" > dockerfile
docker build -t ${name}/${base}-httpd:${ver} .
docker push ${name}/${base}-httpd
docker run -itv ${v}:/usr/local/apache2/htdocs -p ${port2} ${name}/${base}-httpd bash
fi

if [ ${base} = ubuntu ] -a [ ${mode} = d ]
then
sleep 3
echo -e "Building a ${base} image, version ${ver} with port ${port} opened and installing ${app}.\n"
sleep 3
echo -e "FROM ${base}:${ver}\nMAINTAINER ${name}\nRUN apt-get update -y\nRUN apt-get install ${app} -y\nRUN systemctl enable httpd\nRUN systemctl start httpd\nCOPY ./${file} /usr/local/apache2/htdocs\nEXPOSE ${port}\nCMD apachectl -D FOREGROUND" > dockerfile
docker build -t ${name}/${base}-httpd:${ver} .
docker push ${name}/${base}-httpd
docker run -idv ${vol}:/usr/local/apache2/htdocs -p ${port2} ${name}/${base}-httpd bash
fi

if [ ${base} = ubuntu ] -a [ ${mode} = t ]
then
sleep 3
echo -e "Building a ${base} image, version ${ver} with port ${port} opened and installing ${app}.\n"
sleep 3
echo -e "FROM ${base}:${ver}\nMAINTAINER ${name}\nRUN apt-get update -y\nRUN apt-get install ${app} -y\nRUN systemctl enable httpd\nRUN systemctl start httpd\nCOPY ./${file} /usr/local/apache2/htdocs\nEXPOSE ${port}\nCMD apachectl -D FOREGROUND" > dockerfile
docker build -t ${name}/${base}-httpd:${ver} .
docker push ${name}/${base}-httpd
docker run -itv ${vol}:/usr/local/apache2/htdocs -p ${port2} ${name}/${base}-httpd bash
fi

#systemctl enable httpd
#systemctl start httpd


if [ $? = 0 ]
then
echo "Successfully created"
rm -rf dockerfile
else
echo "Docker image creation failed"
fi
