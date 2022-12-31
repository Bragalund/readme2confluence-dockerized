APPLICATION_NAME = md2cf:1.0.0
IMAGE_NAME := bragalund/$(APPLICATION_NAME)

.PHONY: release confluence


.PHONY: release
release: ## How to release a new version of this image: TAG=21 make release. Image is used in command in 'make confluence'
ifndef TAG
	$(error TAG is not set)
else
	docker build --tag $(IMAGE_NAME):$(TAG) -f Dockerfile .
	docker push $(IMAGE_NAME):$(TAG)
	docker rmi $(IMAGE_NAME):$(TAG)
endif


.PHONY: confluence
confluence: ## Update confluence with content in readme
ifndef TOKEN
	$(error TOKEN is not set)
else

	## Statiske variabler
	$(eval GIT_COMMIT = $(shell git rev-parse HEAD))
	$(eval DOCKERIMAGE=bragalund/md2cf:1.0.0)
	$(eval DOCKER_VOLUME_NAME=tempmd2cfvolume)
	$(eval DOCKER_VOLUME_PATH=/shared-volume)
	$(eval CURRENT_DIRECTORY_PATH=$(shell pwd))

	## Ting som må endres per prosjekt
	$(eval PAGEID=265977942)																		 # PAGEID er unik for hvert side i confluence. Se README.md i dette prosjektet for å finne beskrivelse av hvordan finne den.
	$(eval REPO_BASEURL_TO_COMMIT = https://URL-TO.REMOTE-REPO.com/you/reponame) 				     # Denne url'en må endre til riktig repository for kodebasen
	$(eval PATH_TO_README_IN_DOCKER = $(DOCKER_VOLUME_PATH)"/README.md")  							 # Hvis filen ligger et annet sted enn på rotnivå og heter noe annet enn README.md, så må denne pathen endres
	$(eval SHORT_LINK_TO_CONFLUENCE_PAGE=https://YOUR.CONFLUENCE.com/x/jklaishli)

	# Lager et docker volume med alle filer fra lokalt repo tilgjengelig, deriblant README.md
	# Det er nødvendig for at README.md-fila skal være tilgjengelig for scriptet inne i docker-containeren
	
	docker container create --name temp-container -v $(DOCKER_VOLUME_NAME):$(DOCKER_VOLUME_PATH) $(DOCKERIMAGE)
	docker cp $(CURRENT_DIRECTORY_PATH)/. temp-container:$(DOCKER_VOLUME_PATH)
	echo "deleting temp docker container"
	docker rm temp-container

	# Henter inn dockerimage med alle dependencies
	# og mounter det allerede eksisterende filsystemet, så readme er tilgjengelig for containeren
	# Det gjør det mulig for scriptet inne i dockercontaineren å parse og oppdatere confluence-siden

	docker run --rm -v=$(DOCKER_VOLUME_NAME):$(DOCKER_VOLUME_PATH) -e no_proxy=your.confluence.com -e ENV_MESSAGE=$(REPO_BASEURL_TO_COMMIT)$(GIT_COMMIT) -e ENV_TOKEN=$(TOKEN)  -e ENV_PAGEID=$(PAGEID) -e ENV_README_PATH=$(PATH_TO_README_IN_DOCKER)  $(DOCKERIMAGE)
	docker volume rm $(DOCKER_VOLUME_NAME)
	@echo "Updated confluence-page: "$(SHORT_LINK_TO_CONFLUENCE_PAGE)
endif

.PHONY: docs_with_cli
docs_with_cli: ## Update documentation on confluence based on readme-file in this repository with python and md2cf installed
ifndef TOKEN
	$(error TOKEN is not set)
else
	md2cf --host "https://YOUR.CONFLUENCE.com/rest/api" --insecure --token $(TOKEN) --space TTF --page-id "265977942" README.md
endif

.PHONY: help
help: Makefile  ## Print this help screen.
	@awk 'BEGIN {FS = ":.*?## "} /^[a-zA-Z_-]+:.*?## / {printf "\033[36m%-20s\033[0m %s\n", $$1, $$2}' $(MAKEFILE_LIST)
