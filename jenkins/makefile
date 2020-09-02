build-jenkins-jobs: jenkins-build-jobs register-homework-in-consul

int_admin_pass := $(shell (docker exec jenkins cat /var/jenkins_home/secrets/initialAdminPassword))
crumb := $(shell (curl --cookie-jar /tmp/cookies -u admin:$(int_admin_pass) http://127.0.0.1:8080/crumbIssuer/api/json | jq '.crumb' | sed 's/\"//g'))
token := $(shell (curl -X POST --cookie /tmp/cookies http://127.0.0.1:8080/me/descriptorByName/jenkins.security.ApiTokenProperty/generateNewToken?newTokenName=alon -H "Jenkins-Crumb:$(crumb)" -u admin:$(int_admin_pass) | jq '.data.tokenValue' | sed 's/\"//g' ))

jenkins-build-jobs:
	curl -X POST --USER admin:$(token) http://127.0.0.1:8080/createItem?name=ci-groovy --data-binary @ci_config.xml -H "$(crumb)" -H "Content-Type:text/xml"
	curl -X POST --USER admin:$(token) http://127.0.0.1:8080/createItem?name=cd-groovy --data-binary @cd_config.xml -H "$(crumb)" -H "Content-Type:text/xml"
	curl -X POST --USER admin:$(token) http://127.0.0.1:8080/job/ci-groovy/build
	sleep 40
	curl -X POST --USER admin:$(token) http://127.0.0.1:8080/job/cd-groovy/build

register-homework-in-consul:
	docker exec client /bin/sh -c "echo '{\"service\": {\"name\": \"homework\", \"tags\": [\"homework\"], \"port\": 8000}}' >> /consul/config/homework.json"
	docker exec client consul reload
