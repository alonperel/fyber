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

#add pipeline scripts to jenkins
#WORKDIR /var/jenkins_home/jobs/
#RUN mkdir -p /var/jenkins_home/jobs/cd-groovy 
#RUN mkdir -p /var/jenkins_home/jobs/ci-groovy
#ADD cd_config.xml /var/jenkins_home/jobs/cd-groovy/config.xml  
#ADD ci_config.xml /var/jenkins_home/jobs/ci-groovy/config.xml

