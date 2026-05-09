# Guide de déploiement multi-versions avec Mike

La documentation est générée comme quatre sites MkDocs distincts : une langue et une version par build. Mike déploie ensuite chaque langue dans son propre préfixe.

## Structure source

```text
docs/
├── assets/
├── fr/
│   ├── 4.4/
│   └── 5.0/
└── en/
    ├── 4.4/
    └── 5.0/
```

Configurations :

```text
mkdocs-common.yml
mkdocs-common-fr.yml
mkdocs-common-en.yml
mkdocs-fr-4.4.yml
mkdocs-fr-5.0.yml
mkdocs-en-4.4.yml
mkdocs-en-5.0.yml
```

Les fichiers `mkdocs-fr-*` et `mkdocs-en-*` héritent des fichiers communs via `INHERIT`, afin de ne garder localement que `site_name`, `docs_dir`, le sélecteur de langue et la navigation.

## Couche d'abstraction Make

Le projet expose des commandes stables via `Makefile` :

```bash
make install
make lint
make build
make deploy-local
make serve
```

Ces commandes restent inchangées même si le moteur interne évolue (MkDocs -> Zensical).

## Structure publiée

```text
gh-pages/
├── index.html          # redirection vers /fr/latest/
├── fr/
│   ├── 4.4/
│   ├── 5.0/
│   ├── latest/         # alias vers 4.4
│   ├── dev/            # alias vers 5.0
│   └── versions.json
└── en/
    ├── 4.4/
    ├── 5.0/
    ├── latest/
    ├── dev/
    └── versions.json
```

URLs principales :

- `/fr/latest/` : documentation française stable
- `/fr/dev/` : documentation française de développement
- `/en/latest/` : documentation anglaise stable
- `/en/dev/` : documentation anglaise de développement
- `/` : redirection vers `/fr/latest/`

## Déploiement local

```bash
source .venv/bin/activate

make deploy-local
make serve
```

## Déploiement production

Ajouter `--push` aux commandes :

```bash
mike deploy --push -F mkdocs-fr-4.4.yml --deploy-prefix fr 4.4 latest --update-aliases
mike deploy --push -F mkdocs-fr-5.0.yml --deploy-prefix fr 5.0 dev --update-aliases
mike set-default --push -F mkdocs-fr-4.4.yml --deploy-prefix fr latest

mike deploy --push -F mkdocs-en-4.4.yml --deploy-prefix en 4.4 latest --update-aliases
mike deploy --push -F mkdocs-en-5.0.yml --deploy-prefix en 5.0 dev --update-aliases
mike set-default --push -F mkdocs-en-4.4.yml --deploy-prefix en latest

mike set-default --push -F mkdocs-fr-4.4.yml --allow-undefined fr/latest
```

## Ajouter une version

Pour ajouter SPIP 5.1 :

```bash
mkdir -p docs/fr/5.1 docs/en/5.1
ln -s ../../assets docs/fr/5.1/assets
ln -s ../../assets docs/en/5.1/assets

cp mkdocs-fr-5.0.yml mkdocs-fr-5.1.yml
cp mkdocs-en-5.0.yml mkdocs-en-5.1.yml
```

Adapter dans les deux fichiers :

- `site_name`
- `edit_uri`
- `docs_dir`
- `extra.alternate.link`
- `nav`

Puis déployer :

```bash
mike deploy -F mkdocs-fr-5.1.yml --deploy-prefix fr 5.1 dev --update-aliases
mike deploy -F mkdocs-en-5.1.yml --deploy-prefix en 5.1 dev --update-aliases
```

## Zensical (migration progressive)

Zensical est installé pour des essais de migration sans impact sur la prod :

```bash
make build-zensical
```

Le flux de publication reste basé sur MkDocs + Mike tant que le versioning natif Zensical n'est pas retenu.

## CI GitLab

La CI s'appuie sur `make` :

- `make lint` pour le lint Markdown
- `make build` pour les 4 builds stricts
- `make deploy-push-all` pour publier toutes les langues/versions
- `make pages-artifact` pour produire `public/` dans le job `pages` (test GitLab.com)

## Dépannage

### Le sélecteur de version ne s'affiche pas

Utiliser `mike serve`, pas `mkdocs serve`.

### La racine ne redirige pas vers le français

Relancer :

```bash
mike set-default -F mkdocs-fr-4.4.yml --allow-undefined fr/latest
```

### Lister les versions

```bash
mike list --deploy-prefix fr
mike list --deploy-prefix en
```
