SHELL := /bin/bash

VENV_BIN ?= .venv/bin
PIP := $(VENV_BIN)/pip
PYTHON := $(VENV_BIN)/python
MKDOCS := $(VENV_BIN)/mkdocs
MIKE := $(VENV_BIN)/mike
ZENSICAL := $(VENV_BIN)/zensical

FR44 := mkdocs-fr-4.4.yml
FR50 := mkdocs-fr-5.0.yml
EN44 := mkdocs-en-4.4.yml
EN50 := mkdocs-en-5.0.yml

.PHONY: install lint lint-fix build build-zensical deploy-local serve clean \
        deploy-push-all deploy-manual pages-artifact

install:
	$(PYTHON) -m pip install --upgrade pip
	$(PIP) install -r requirements.txt

lint:
	$(VENV_BIN)/pymarkdown --config .pymarkdown.json scan -r docs/fr docs/en

lint-fix:
	$(VENV_BIN)/pymarkdown --config .pymarkdown.json fix -r docs/fr docs/en

build:
	$(MKDOCS) build --strict -f $(FR44)
	$(MKDOCS) build --strict -f $(FR50)
	$(MKDOCS) build --strict -f $(EN44)
	$(MKDOCS) build --strict -f $(EN50)

build-zensical:
	$(ZENSICAL) build --strict -f $(FR44)
	$(ZENSICAL) build --strict -f $(FR50)
	$(ZENSICAL) build --strict -f $(EN44)
	$(ZENSICAL) build --strict -f $(EN50)

deploy-local:
	$(MIKE) deploy -F $(FR44) --deploy-prefix fr 4.4 latest --update-aliases
	$(MIKE) deploy -F $(FR50) --deploy-prefix fr 5.0 dev --update-aliases
	$(MIKE) set-default -F $(FR44) --deploy-prefix fr latest
	$(MIKE) deploy -F $(EN44) --deploy-prefix en 4.4 latest --update-aliases
	$(MIKE) deploy -F $(EN50) --deploy-prefix en 5.0 dev --update-aliases
	$(MIKE) set-default -F $(EN44) --deploy-prefix en latest
	$(MIKE) set-default -F $(FR44) --allow-undefined fr/latest

deploy-push-all:
	$(MIKE) deploy --push -F $(FR44) --deploy-prefix fr 4.4 latest --update-aliases
	$(MIKE) deploy --push -F $(FR50) --deploy-prefix fr 5.0 dev --update-aliases
	$(MIKE) set-default --push -F $(FR44) --deploy-prefix fr latest
	$(MIKE) deploy --push -F $(EN44) --deploy-prefix en 4.4 latest --update-aliases
	$(MIKE) deploy --push -F $(EN50) --deploy-prefix en 5.0 dev --update-aliases
	$(MIKE) set-default --push -F $(EN44) --deploy-prefix en latest
	$(MIKE) set-default --push -F $(FR44) --allow-undefined fr/latest

deploy-manual:
ifndef DEPLOY_LANG
	$(error DEPLOY_LANG is required, e.g. DEPLOY_LANG=fr)
endif
ifndef DEPLOY_VERSION
	$(error DEPLOY_VERSION is required, e.g. DEPLOY_VERSION=5.0)
endif
ifndef DEPLOY_ALIAS
	$(error DEPLOY_ALIAS is required, e.g. DEPLOY_ALIAS=dev)
endif
	$(MIKE) deploy --push -F mkdocs-$(DEPLOY_LANG)-$(DEPLOY_VERSION).yml --deploy-prefix $(DEPLOY_LANG) $(DEPLOY_VERSION) $(DEPLOY_ALIAS) --update-aliases

pages-artifact: deploy-local
	rm -rf public
	mkdir -p public
	git archive gh-pages | tar -x -C public

serve:
	$(MIKE) serve

clean:
	rm -rf site public
