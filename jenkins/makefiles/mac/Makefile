UNSECURE_URL=http://$(IP_ADDRESS):$(HTTP_PORT)
SERVER_URL=https://$(IP_ADDRESS):$(HTTPS_PORT)

run-agent: local-build-agent network
	docker run --rm --name 'jenkins-agent' --init              \
	    --network '$(DOCKER_NETWORK)'                          \
	    -p $(DEBUGGER_PORT):$(AGENT_DEBUGGER_PORT)             \
	    --env "AGENT_NAME=$(AGENT_NAME)"                       \
	    --env "EXECUTORS=4"                                    \
	    --env "SERVER_URL=$(SERVER_URL)"                       \
	    --env "JENKINS_INSTANCE=$(JENKINS_INSTANCE)"           \
	    --env "AGENT_SECRET_ARN=$(AGENT_SECRET_ARN)"           \
	    --env "EXTRA_CLIENT_OPTS=$(EXTRA_CLIENT_OPTS)"         \
	    --env "EXTRA_AGENT_OPTS=$(EXTRA_AGENT_OPTS)"           \
	    -v jenkins-agent-workspace:/var/lib/jenkins/workspace  \
	    -v jenkins-agent-cache:/var/lib/jenkins/cache          \
	    -v $(GITHUB_SSHKEY):/tmp/.ssh/id_rsa:ro                \
	    -v $(AWS_CONFIG_OPTIONS)/agent:/var/lib/jenkins/.aws   \
	    -v $(TLS_CONFIG)/truststore.jks:$(TRUST_STORE)         \
	    -v /var/run/docker.sock:/var/run/docker.sock           \
	    -h 'jenkins-agent'                                     \
	    "$(AGENT_IMAGE_NAME)-local"

run-server: network
	docker run --rm --name 'jenkins-server'                     \
	    --network '$(DOCKER_NETWORK)'                           \
	    -p $(HTTP_PORT):$(HTTP_PORT)                            \
	    -p $(HTTPS_PORT):$(HTTPS_PORT)                          \
	    -p $(HTTP2_PORT):$(HTTP2_PORT)                          \
	    -p $(DEBUGGER_PORT):$(SERVER_DEBUGGER_PORT)             \
	    --env "SERVER_URL=$(SERVER_URL)"                        \
	    --env "RESOURCE_URL=$(RESOURCE_URL)"                    \
	    --env "JENKINS_INSTANCE=$(JENKINS_INSTANCE)"            \
	    --env "GITHUB_SECRET_ARN=$(GITHUB_SECRET_ARN)"          \
	    --env "GITHUB_AGENT_USER=$(GITHUB_AGENT_USER)"          \
	    --env "AWS_ACCOUNT_NAME=$(AWS_ACCOUNT_NAME)"            \
	    --env "AWS_MAIN_ACCOUNT_ID=$(AWS_MAIN_ACCOUNT_ID)"      \
	    --env "AWS_DEFAULT_REGION=$(AWS_REGION)"                \
	    -v jenkins-server-home:/var/jenkins_home                \
	    -v $(HOOK_SCRIPTS):/var/jenkins_home/init.groovy.d      \
	    -v $(CASC_CONFIG):/var/jenkins_home/jenkins.yaml        \
	    -v $(GITHUB_SSHKEY):/var/lib/jenkins/.ssh/id_rsa:ro     \
	    -v $(AWS_CONFIG_OPTIONS)/server:/var/jenkins_home/.aws  \
	    -v $(TLS_CONFIG):/var/jenkins_home/tls                  \
	    -h 'jenkins-server'                                     \
	    "$(SERVER_IMAGE_NAME)"

network:
	if ! docker network inspect '$(DOCKER_NETWORK)' &>/dev/null; then  \
	    docker network create '$(DOCKER_NETWORK)';                     \
	fi

include $(CURDIR)/makefiles/mac/certs.make
include $(CURDIR)/makefiles/mac/disks.make
include $(CURDIR)/makefiles/mac/maint.make
include $(CURDIR)/makefiles/mac/xhyve.make
include $(CURDIR)/makefiles/mac/ip.make
include $(CURDIR)/makefiles/mac/ui.make
