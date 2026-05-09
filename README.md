# Évolutions techniques de SPIP

Documentation technique des évolutions de SPIP, organisée par langue puis par version.

## Structure

```text
docs/
├── assets/             # Assets partagés (CSS, JS, images)
├── fr/
│   ├── 4.4/
│   │   ├── assets -> ../../assets
│   │   ├── upgrade/
│   │   ├── features/
│   │   └── reference/
│   └── 5.0/
└── en/
    ├── 4.4/
    └── 5.0/
```

Chaque couple langue/version a sa propre configuration :

- `mkdocs-fr-4.4.yml`
- `mkdocs-fr-5.0.yml`
- `mkdocs-en-4.4.yml`
- `mkdocs-en-5.0.yml`

La configuration partagée est factorisée dans :

- `mkdocs-common.yml` : options communes à toutes les langues et versions
- `mkdocs-common-fr.yml` : thème et libellés français
- `mkdocs-common-en.yml` : thème et libellés anglais

`mkdocs.yml` est un lien symbolique vers `mkdocs-fr-4.4.yml`, ce qui permet de lancer `mike serve` directement.

## Installation locale

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

## Commandes standard (Make)

Les commandes de travail quotidiennes passent par `make`, pour rester agnostiques du moteur utilisé en interne.

```bash
make install       # installe/maj les dépendances Python
make lint          # lint Markdown
make lint-fix      # corrections auto (pymarkdown fix), puis relancer make lint
make build         # build strict des 4 documentations
make deploy-local  # met à jour gh-pages localement (sans push)
make serve         # sert les versions via mike serve
make clean         # nettoie site/ et public/
```

## Preview d'une seule documentation

```bash
mkdocs serve -f mkdocs-fr-4.4.yml
mkdocs serve -f mkdocs-en-4.4.yml
```

## Preview multi-langues et multi-versions

```bash
make deploy-local
make serve
```

URLs résultantes :

- `/fr/latest/upgrade/` → SPIP 4.4 français
- `/fr/dev/upgrade/` → SPIP 5.0 français
- `/en/latest/upgrade/` → SPIP 4.4 anglais
- `/en/dev/upgrade/` → SPIP 5.0 anglais

## Ajouter une version

Pour ajouter SPIP 5.1 :

```bash
mkdir -p docs/fr/5.1 docs/en/5.1
ln -s ../../assets docs/fr/5.1/assets
ln -s ../../assets docs/en/5.1/assets

cp mkdocs-fr-5.0.yml mkdocs-fr-5.1.yml
cp mkdocs-en-5.0.yml mkdocs-en-5.1.yml
# Éditer docs_dir, edit_uri, site_name et les liens alternate.
```

## Test Zensical (expérimental)

Zensical est ajouté en dépendance pour des tests de migration progressive.

```bash
make build-zensical
```

Cette commande ne remplace pas encore le pipeline principal MkDocs/Mike.

## Contrôles qualité

```bash
make lint
make build
```

Pour un guide de déploiement complet, voir [DEPLOYMENT.md](DEPLOYMENT.md).
