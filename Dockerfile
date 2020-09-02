FROM jenkins/jenkins

#install jenkins plugins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt
COPY cd_config.xml /usr/share/jenkins/cd_config.xml
COPY ci_config.xml /usr/share/jenkins/ci_config.xml

#install docker inside jenkins container
ADD https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz /usr/local/bin
USER root
RUN tar xzvf /usr/local/bin/docker-17.04.0-ce.tgz 

