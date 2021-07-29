override NODE_IMAGE = node:14.15.1 
override APP_FOLDER = app

all: bootstrap

bootstrap:
	@if [ "$(with)" = "docker" ]; then\
		docker run --rm -it --user 1000:1000 -v "$(shell pwd):/$(APP_FOLDER)" -w /$(APP_FOLDER) $(NODE_IMAGE) npm ci;\
	else \
		npm ci;\
	fi\

.PHONY: test
test:
	@if [ "$(with)" = "docker" ]; then\
		docker run --rm -it --user 1000:1000 -v "$(shell pwd):/$(APP_FOLDER)" -w /$(APP_FOLDER) $(NODE_IMAGE) npm testnpm test;\
	else \
		npm run test;\
	fi\

lint:
	@if [ "$(with)" = "docker" ]; then\
		docker run --rm -it --user 1000:1000 -v "$(shell pwd):/$(APP_FOLDER)" -w /$(APP_FOLDER) $(NODE_IMAGE) npm run checklint;\
	else \
		npm run checklint;\
	fi\

fixlint:
	@if [ "$(with)" = "docker" ]; then\
		make devbuild;\
		docker run --rm -it --user 1000:1000 -v "$(shell pwd):/$(APP_FOLDER)" -w /$(APP_FOLDER) $(NODE_IMAGE)npm run lint;\
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
		docker run --rm -it --user 1000:1000 -p 3000:3000  -v "$(shell pwd):/$(APP_FOLDER)" -w /$(APP_FOLDER) $(NODE_IMAGE) bash;\
	else \
		/bin/bash nvm use v14.15.1;\
	fi\
