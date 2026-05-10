# Guide de déploiement multi-versions avec Zensical

La documentation est générée comme **quatre sites Zensical** distincts : une langue et une version par build. Les sorties sont placées sous `public/<langue>/<version>/`, puis des **répertoires copiés** servent d’alias (`latest`, `dev`) pour GitLab Pages (pas de symlinks).

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

Configurations actives (TOML) :

```text
zensical-fr-4.4.toml
zensical-fr-5.0.toml
zensical-en-4.4.toml
zensical-en-5.0.toml
```

Note: pour le moment il n’est pas possible de mutualiser des configurations 
communes entre les différents fichiers. https://github.com/zensical/backlog/issues/126

## Couche d'abstraction Make

```bash
make install
make lint
make build
make pages-artifact
make serve
```

- **`make build`** : quatre `zensical build --strict` vers `public/fr/4.4`, etc., puis **`scripts/copy-spip-assets.sh public`** une fois et **`scripts/finalize-public.py`**. Les CSS / JS SPIP ne sont plus déclarés en `extra_css` (relatif à chaque `docs_dir`, donc copie dupliquée) : **`overrides/main.html`** injecte `<link>` et `<script>` vers **`/assets/...`** (racine du site), et le script recopie `spip-theme.css`, `spip-nav.js` et les polices Montserrat sous **`public/assets/`** uniquement.
- **`make build`** crée aussi les alias (`latest` / `dev`), écrit `fr/versions.json` et `en/versions.json`, et ajoute les index de redirection (`/`, `/fr/`, `/en/`). Le site est donc directement servable par **`make serve`** après un `make clean && make build`.
- **`make pages-artifact`** : efface `public/`, puis relance simplement `make build`.

## Structure publiée (artefact `public/`)

```text
public/
├── index.html          # redirection vers /fr/latest/
├── assets/             # SPIP partagé : stylesheets/, javascripts/, webfonts/
├── fr/
│   ├── 4.4/
│   ├── 5.0/
│   ├── latest/         # copie de 4.4
│   ├── dev/            # copie de 5.0
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
source .venv/bin/activate   # optionnel ; make utilise .venv/bin automatiquement

make deploy-local   # équivalent : make pages-artifact
make serve          # http.server sur public/ (port 8000)
```

Preview d’une seule doc sans tout reconstruire :

```bash
make serve-doc DOC=zensical-fr-5.0.toml
make serve-zensical ZENSICAL_CFG=zensical-fr-5.0.toml
```

## Déploiement production (GitLab Pages)

La CI appelle `make pages-artifact` ; le job **`pages`** publie le dossier **`public/`**.

Il n’y a pas de push vers une branche `gh-pages` : le site est entièrement contenu dans l’artefact Pages.

## Ajouter une version

1. Créer les répertoires `docs/fr/X.Y/`, `docs/en/X.Y/` et les liens symboliques `assets` comme pour les versions existantes.
2. Dupliquer `zensical-fr-5.0.toml` / `zensical-en-5.0.toml` vers `zensical-fr-X.Y.toml` / `zensical-en-X.Y.toml` et adapter `site_name`, `docs_dir`, `site_url`, `site_dir`, `edit_uri`, `nav`, `extra.alternate`.
3. Mettre à jour le `Makefile` : nouvelles variables, ajout aux cibles `build` et `pages-artifact` (copies d’alias et éventuellement `versions.json` si les numéros de version changent).

## Thème et personnalisation

- Variante **classic** dans les TOML pour se rapprocher du rendu Material for MkDocs.
- SPIP : `assets/stylesheets/spip-theme.css`, polices Montserrat locales, `theme.font = false` pour éviter Google Fonts.
- Boussole : `assets/javascripts/spip-nav.js` (chargement + ré-exécution avec `document$` pour la navigation instantanée Zensical).
- **Clair / sombre / système** : les configs utilisent trois entrées `[[project.theme.palette]]` avec `media = "(prefers-color-scheme)"` et les variantes `light` / `dark`, comme décrit dans la [documentation Zensical sur les couleurs](https://zensical.org/docs/setup/colors/) (mode automatique synchronisé sur l’OS).

## CI GitLab

- `make lint` — lint Markdown
- `make build` — quatre builds stricts
- `make pages-artifact` — artefact `public/` pour le job `pages`

## Dépannage

### Le sélecteur de version ne liste pas les versions

Vérifier que `public/fr/versions.json` et `public/en/versions.json` sont bien générés par `make pages-artifact` et que `[project.extra.version]` avec `provider = "mike"` est présent dans les TOML (compatibilité sélecteur Material).

### La racine ne redirige pas vers le français

Vérifier que `public/index.html` est bien créé par `make pages-artifact`.

### Prévisualiser sans reconstruire les quatre sites

Utiliser `make serve-doc DOC=zensical-fr-5.0.toml`, ou `make serve-zensical` avec `ZENSICAL_CFG`.
