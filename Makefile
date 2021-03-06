STAGING_HOST=staging-docs.lfe.io
STAGING_PATH=/var/www/lfe/staging-docs/lgtk-tutorial

SRC=./
BASE_DIR=$(shell pwd)
PROD_DIR=_book
PROD_PATH=$(BASE_DIR)/$(PROD_DIR)
STAGE_DIR=$(PROD_DIR)
STAGE_PATH=$(BASE_DIR)/$(STAGE_DIR)

setup:
	@npm install -g gitbook-cli
	@npm install -g gitbook-plugin-ga
	@gitbook install

build:
	gitbook build $(SRC) --output=$(PROD_DIR)

run:
	gitbook serve $(SRC)

staging: build
	git pull origin master && \
	rsync -azP ./$(STAGE_DIR)/* $(STAGING_HOST):$(STAGING_PATH)

publish: build
	-git commit -a && git push origin master
	git subtree push --prefix $(PROD_DIR) origin gh-pages

clean:
	rm -rf node_modules node*.log

examples:
	make -C examples

repl:
	make repl -C examples

repl-debug:
	make repl-debug -C examples

.PHONY: examples
