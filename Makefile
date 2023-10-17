include .env
COMPOSE_ALL_FILES := -f docker-compose.archive.yml -f docker-compose.node-exporter.yml
COMPOSE_ARCHIVE := -f docker-compose.archive.yml
COMPOSE_NODE_EXPORTER := -f docker-compose.node-exporter.yml
SERVICES := mina archive postgres node-exporter

compose_v2_not_supported = $(shell command docker compose 2> /dev/null)
ifeq (,$(compose_v2_not_supported))
  DOCKER_COMPOSE_COMMAND = docker-compose
else
  DOCKER_COMPOSE_COMMAND = docker compose
endif

# --------------------------
.PHONY: keystore-libp2p keystore-uptime rule setup ar nodex ar-down nodex-down logs status

keystore-libp2p:
	sudo docker run -ti --rm --entrypoint=mina --volume ${HOME}/keys:/root/keys ${MINA} libp2p generate-keypair --privkey-path /root/keys/libp2p-keys

keystore-uptime:
	sudo docker run -ti --rm --entrypoint=mina-generate-keypair --volume ${HOME}/keys:/root/keys ${MINA} --privkey-path /root/keys/my-wallet

rule:
	sudo chmod 700 ${KEYS_PATH}
	sudo chmod 600 ${LIBP2P_KEYPATH}
	sudo chmod 600 ${KEYPATH}

setup:		    ## Generate LIB_P2P and UPTIME Keystores.
	@make keystore-libp2p
	@make keystore-uptime
	@make rule

ar:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_ARCHIVE} up -d

nodex:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_NODE_EXPORTER} up -d

ar-down:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_ARCHIVE} down

nodex-down:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_NODE_EXPORTER} down

logs:
	$(DOCKER_COMPOSE_COMMAND) ${COMPOSE_ARCHIVE} logs -f

status:
	sudo docker exec -it mina mina client status
