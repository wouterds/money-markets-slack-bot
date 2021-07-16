PWD = $(shell pwd)

DOCKER_COMPOSE = ./docker-compose.yml
DOCKERFILE = ./Dockerfile

TAG = registry.evix.io/money-markets-slack-bot/node

build: ${DOCKERFILE}
	docker build -f ${DOCKERFILE} -t ${TAG} .

docker-login:
	docker login registry.evix.io -u ${DOCKER_REGISTRY_USER} -p "${DOCKER_REGISTRY_PASS}"

push:
	docker push ${TAG}

deploy:
	ssh ${DEPLOY_USER}@${DEPLOY_HOST} "mkdir -p ${DEPLOY_PATH}"
	scp ${DOCKER_COMPOSE} ${DEPLOY_USER}@${DEPLOY_HOST}:${DEPLOY_PATH}/docker-compose.yml
	ssh ${DEPLOY_USER}@${DEPLOY_HOST} "cd ${DEPLOY_PATH}; docker-compose pull"
	ssh ${DEPLOY_USER}@${DEPLOY_HOST} "cd ${DEPLOY_PATH}; docker-compose up -d"
