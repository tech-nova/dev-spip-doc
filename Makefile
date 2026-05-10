SHELL := /bin/bash

VENV_BIN ?= .venv/bin
# Python système pour créer .venv si absent (CI, clone neuf)
PYTHON_BOOTSTRAP ?= python3
PIP := $(VENV_BIN)/pip
PYTHON := $(VENV_BIN)/python
ZENSICAL := $(VENV_BIN)/zensical

# Outils lancés via PATH (sous-processus) : garder le venv en tête
export PATH := $(CURDIR)/$(VENV_BIN):$(PATH)

# Configurations Zensical (TOML)
FR44 := zensical-fr-4.4.toml
FR50 := zensical-fr-5.0.toml
EN44 := zensical-en-4.4.toml
EN50 := zensical-en-5.0.toml

# Finalisation de l’arborescence public/ (voir DEPLOYMENT.md).
SPIP_COPY := ./scripts/copy-spip-assets.sh
FINALIZE_PUBLIC := ./scripts/finalize-public.py

# Prévisualisation d’une seule doc : make serve-zensical ou make serve-doc DOC=…
ZENSICAL_CFG ?= zensical-fr-5.0.toml

.PHONY: install lint lint-fix build build-zensical deploy-local serve serve-zensical serve-doc clean \
        pages-artifact deploy-push-all deploy-manual

install:
	@if [ ! -x "$(PYTHON)" ]; then $(PYTHON_BOOTSTRAP) -m venv .venv; fi
	$(PYTHON) -m pip install --upgrade pip
	$(PIP) install -r requirements.txt

lint:
	$(VENV_BIN)/pymarkdown --config .pymarkdown.json scan -r docs/fr docs/en

lint-fix:
	$(VENV_BIN)/pymarkdown --config .pymarkdown.json fix -r docs/fr docs/en

build:
	$(ZENSICAL) build --strict -f $(FR44)
	$(ZENSICAL) build --strict -f $(FR50)
	$(ZENSICAL) build --strict -f $(EN44)
	$(ZENSICAL) build --strict -f $(EN50)
	$(SPIP_COPY) public
	$(PYTHON) $(FINALIZE_PUBLIC)

build-zensical: build

pages-artifact:
	rm -rf public
	$(MAKE) build

deploy-local: pages-artifact
	@echo "Site complet dans public/ — lancez « make serve » pour prévisualiser."

serve:
	cd public && exec ../$(PYTHON) -m http.server 8000

serve-zensical:
	$(ZENSICAL) build --strict -f "$(ZENSICAL_CFG)"
	$(SPIP_COPY) public
	$(PYTHON) $(FINALIZE_PUBLIC)
	exec $(ZENSICAL) serve -f "$(ZENSICAL_CFG)"

# Exemple : make serve-doc DOC=zensical-fr-5.0.toml  (nom du fichier à la racine du dépôt docs)
serve-doc:
ifndef DOC
	$(error DOC est requis, ex. DOC=zensical-fr-5.0.toml)
endif
	@test -f "$(DOC)" || { echo >&2 "Fichier introuvable : $(DOC)"; exit 1; }
	$(ZENSICAL) build --strict -f "$(DOC)"
	$(SPIP_COPY) public
	$(PYTHON) $(FINALIZE_PUBLIC)
	exec $(ZENSICAL) serve -f "$(DOC)"

clean:
	rm -rf site public

deploy-push-all deploy-manual:
	@echo >&2 "OBSOLÈTE : publication Mike supprimée. Utilisez « make pages-artifact » et la CI GitLab Pages." >&2
	@exit 1
