.PHONY: confluence
	confluence: ## Update confluence with content in readme
	ifndef TOKEN
		$(error TOKEN is not set)
	else
		$(eval GIT_COMMIT = $(shell git rev-parse HEAD))
		$(eval DOCKERIMAGE=docker.avinor.no/baseimages/md2cf-cli:20)
		$(eval DOCKER_VOLUME_NAME=tempmd2cfvolume)
		$(eval DOCKER_VOLUME_PATH=/shared-volume)
		$(eval CURRENT_DIRECTORY_PATH=$(shell pwd))
		$(eval PAGEID=279887014)
		$(eval REPO_BASEURL_TO_COMMIT = https://www.github.com/bragalund/myrepo)
		$(eval PATH_TO_README_IN_DOCKER = $(DOCKER_VOLUME_PATH)"/README.md")
		$(eval SHORT_LINK_TO_CONFLUENCE_PAGE=https://Your.confluence.com/x/pryuE)

	docker container create --name temp-container -v $(DOCKER_VOLUME_NAME):$(DOCKER_VOLUME_PATH) $(DOCKERIMAGE)
	docker cp $(CURRENT_DIRECTORY_PATH)/. temp-container:$(DOCKER_VOLUME_PATH)
	echo "deleting temp docker container"
	docker rm temp-container

	docker run --rm -v=$(DOCKER_VOLUME_NAME):$(DOCKER_VOLUME_PATH) -e no_proxy=your.confluence.com -e ENV_MESSAGE=$(REPO_BASEURL_TO_COMMIT)$(GIT_COMMIT) -e ENV_TOKEN=$(TOKEN)  -e ENV_PAGEID=$(PAGEID) -e ENV_README_PATH=$(PATH_TO_README_IN_DOCKER)  $(DOCKERIMAGE)
	docker volume rm $(DOCKER_VOLUME_NAME)
		echo "Updated confluence-page: "$(SHORT_LINK_TO_CONFLUENCE_PAGE)
	endif
