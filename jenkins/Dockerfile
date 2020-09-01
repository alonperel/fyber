FROM jenkins/jenkins

#install jenkins plugins
COPY plugins.txt /usr/share/jenkins/plugins.txt
RUN /usr/local/bin/plugins.sh /usr/share/jenkins/plugins.txt

#install docker inside jenkins container
ADD https://get.docker.com/builds/Linux/x86_64/docker-17.04.0-ce.tgz /usr/local/bin
USER root
RUN tar xzvf /usr/local/bin/docker-17.04.0-ce.tgz 

#add pipeline scripts to jenkins
RUN mkdir /var/jenkins_home/jobs/cd-groovy/ /
    && mkdir /var/jenkins_home/jobs/ci-groovy/

COPY cd_config.xml /var/jenkins_home/jobs/cd-groovy/config.xml /
     && ci_config.xml /var/jenkins_home/jobs/ci-groovy/config.xml




#jenkin-cli installation
#RUN mkdir /opt/jenkins/
#RUN apt-get -y update
#ADD jenkins-cli.jar /var/jenkins_home/
#COPY jenkins-cli.sh /var/jenkins_home/

#RUN echo “alias jenkins-cli=‘java -jar /var/jenkins_home/jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:admin123’ ” >> ~/.bashrc
#COPY ci.groovy /var/jenkins_home/
#RUN java -jar /var/jenkins_home/jenkins-cli.jar -s http://127.0.0.1:8080/ -auth admin:admin123 create-job ci-groovy

