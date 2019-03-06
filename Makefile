REGISTRY_HOST=registry.sibext.com
USERNAME=sibext
NAME=nessosphere-unit
IMAGE=$(REGISTRY_HOST)/$(USERNAME)/$(NAME)
VERSION=$(shell cat .version)
META=$(meta)
IMAGE-NAME=$(IMAGE):$(VERSION)$(META)
REV=$(shell git rev-parse --short HEAD)
BRANCH=$(shell if [[ -z "${CI_COMMIT_REF_NAME}" ]]; then git rev-parse --abbrev-ref HEAD; else echo $(CI_COMMIT_REF_NAME); fi )

all: compile

compile: ./apps/xlib/src/*.erl ./apps/ness_cloud_unit/src/*.erl ./apps/ness_cloud_proxy/src/*.erl
	erlc -o ./apps/xlib/ebin +debug_info ./apps/xlib/src/xlib_make.erl
	erl -pa ./deps/lager/ebin ./apps/xlib/ebin ./apps/ness_cloud_unit/ebin ./apps/ness_cloud_common/ebin ./apps/ness_cloud_proxy/ebin -eval "xlib_make:make_and_test( development, [ xlib, ness_cloud_common, ness_cloud_unit, ness_cloud_proxy ] )" -s init stop -noshell
	
clean:
	rm -rf ./apps/xlib/ebin/*.beam
	rm -rf ./apps/ness_cloud_common/ebin/*.beam
	rm -rf ./apps/ness_cloud_unit/ebin/*.beam
	rm -rf ./apps/ness_cloud_proxy/ebin/*.beam
	rm -rf ./log/*
	rm erl_crash.dump

version:
	@echo $(VERSION)

image-name:
	@echo $(IMAGE-NAME)

docker-build:
	docker build -t $(IMAGE-NAME) --build-arg RAILS_MASTER_KEY=$(RAILS_MASTER_KEY) .

docker-push:
	docker push $(IMAGE-NAME)

release: docker-build docker-push

stg-release:
	make release IMAGE-NAME=$(IMAGE-NAME)-$(BRANCH).$(REV)