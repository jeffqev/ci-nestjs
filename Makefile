all: bootstrap

bootstrap:
	npm ci

.PHONY: test
test:
	@if [ "$(with)" = "docker" ]; then\
		make devbuild;\
		docker run -it --rm acme-backend-dev npm run test;\
	else \
		npm run test;\
	fi\

lint:
	@if [ "$(with)" = "docker" ]; then\
		make devbuild;\
		docker run -it --rm acme-backend-dev npm run checklint;\
	else \
		npm run checklint;\
	fi\

fixlint:
	@if [ "$(with)" = "docker" ]; then\
		make devbuild;\
		docker run -it --rm acme-backend-dev npm run lint;\
	else \
		npm run lint;\
	fi\

devbuild:
	docker build -t acme-backend-dev --target development .

build:
	docker build -t acme-backend-prod --target production .

run: build
	docker run --rm -p 3000:3000 acme-backend-prod

shell:
	@if [ "$(with)" = "docker" ]; then\
		docker run -it --rm -p 3000:3000 --user 1000:1000 -v "$(shell pwd):/usr/src/app" acme-backend-dev bash;\
	else \
		/bin/bash nvm use v14.15.1;\
	fi\
