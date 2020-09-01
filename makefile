DOCKER_PATH := $(shell which docker)
HOME_PATH := $$HOME
VALUE_HOME_PATH := $(value HOME_PATH)
#test: jenkins-build-jobs
launch: consul-server consul-client jenkins-build jenkins-run jenkins-create-ci-job jenkins-create-cd-job jenkins-build-jobs register-homework-in-consul

git:
	git clone https://github.com/alonperel/fyber.git

consul-network:
	docker network create -d bridge fyber

consul-server:
	docker run -d --network fyber -p 8500:8500 -p 8600:8600/udp --name=server consul agent -server -ui -node=server-1 -bootstrap-expect=1 -client=0.0.0.0

IP := $(shell (docker exec server consul members | grep -v Node | awk '{print $$2}' | cut -f1 -d":"))

consul-client:
	docker run -d --network fyber  --name=client consul agent -node=client-1 -join=$(IP)

jenkins-build:
	docker build -t my_jenkins $(CURDIR)/jenkins/

jenkins-run:
	docker run -d  -p 8080:8080 -p 50000:50000 -v $(DOCKER_PATH):/usr/bin/docker -v /var/run/docker.sock:/var/run/docker.sock -v $($$HOME)/:/var/jenkins_home --tty --name=jenkins my_jenkins
	
jenkins-create-ci-job:
	docker exec jenkins mkdir /var/jenkins_home/jobs/ci-groovy/
	docker exec jenkins mv /usr/share/jenkins/ci_config.xml /var/jenkins_home/jobs/ci-groovy/config.xml

jenkins-create-cd-job:
	docker exec jenkins mkdir /var/jenkins_home/jobs/cd-groovy/
	docker exec jenkins mv /usr/share/jenkins/cd_config.xml /var/jenkins_home/jobs/cd-groovy/config.xml

int_admin_pass := $(shell (docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword))
crumb := $(shell (curl -s --cookie-jar /tmp/cookies -u admin:$(int_admin_pass) http://127.0.0.1:8080/crumbIssuer/api/json | jq '.crumb' | sed 's/\"//g'))
token := $(shell (curl -X POST --cookie /tmp/cookies http://127.0.0.1:8080/me/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken?newTokenName=alon -H "Jenkins-Crumb:$(crumb)" -u admin:$(int_admin_pass) | jq '.data.tokenValue' | sed 's/\"//g' ))


jenkins-build-jobs:
	curl -X POST --USER admin:$(token) http://127.0.0.1:8080/job/ci-groovy/build
	curl -X POST --USER admin:$(token) http://127.0.0.1:8080/job/cd-groovy/build
	
build-homwwork-service:
	docker build -t simple-flask-app:latest $(CURDIR)/homework-service

run-homwwork-service:
	docker run -d --network fyber -p 8000:8000 --name=homework simple-flask-app

register-homework-in-consul:
	docker exec client /bin/sh -c "echo '{\"service\": {\"name\": \"homework\", \"tags\": [\"homework\"], \"port\": 8000}}' >> /consul/config/homework.json"
	docker exec client consul reload

