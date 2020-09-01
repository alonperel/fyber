launch: git consul-network consul-server consul-server-ip consul-client jenkins

git:
	git clone https://github.com/alonperel/fyber.git

consul-network:
	docker network create -d bridge fyber

consul-server:
	docker run -d --network fyber -p 8500:8500 -p 8600:8600/udp --name=server consul agent -server -ui -node=server-1 -bootstrap-expect=1 -client=0.0.0.0

consul-server-ip:
	IP := $(docker exec server consul members | grep server-1 | awk '{print $2}' | cut -f1 -d":")

consul-client:
	docker run -d --network fyber  --name=client consul agent -node=client-1 -join=$IP

jenkins:
	@echo "jenkins""