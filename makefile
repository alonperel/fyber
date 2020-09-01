DOCKER_PATH := $(shell which docker)
HOME_PATH := $$HOME
VALUE_HOME_PATH := $(value HOME_PATH)
test: build-homwwork-service run-homwwork-service register-homework-in-consul
launch: consul-server consul-client jenkins-build jenkins-run build-homwwork-service run-homwwork-service register-homework-in-consul

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
	
build-homwwork-service:
	docker build -t simple-flask-app:latest $(CURDIR)/homework-service

run-homwwork-service:
	docker run -d --network fyber -p 8000:8000 --name=homework simple-flask-app

register-homework-in-consul:
	docker exec client /bin/sh -c "echo '{\"service\": {\"name\": \"homework\", \"tags\": [\"homework\"], \"port\": 8000}}' >> /consul/config/homework.json"
	docker exec client consul reload

