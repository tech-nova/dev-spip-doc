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

Chaque couple langue/version a sa propre configuration **Zensical** en TOML :

- `zensical-fr-4.4.toml`
- `zensical-fr-5.0.toml`
- `zensical-en-4.4.toml`
- `zensical-en-5.0.toml`

## Installation locale

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

Ou : `make install` (crée `.venv` si besoin).

## Commandes standard (Make)

```bash
make install       # installe/maj les dépendances Python (Zensical, pymarkdown)
make lint          # lint Markdown
make lint-fix      # corrections auto (pymarkdown fix), puis relancer make lint
make build         # build strict des 4 documentations vers public/<lang>/<version>/
make deploy-local  # alias de pages-artifact : site complet + aliases + versions.json
make serve         # sert le dossier public/ (http.server sur le port 8000)
make clean         # supprime site/ et public/
```

## Preview d'une seule documentation

```bash
make serve-doc DOC=zensical-fr-5.0.toml

make serve-zensical
make serve-zensical ZENSICAL_CFG=zensical-en-4.4.toml
```

Équivalent direct :

```bash
.venv/bin/zensical serve -f zensical-fr-5.0.toml
```

## Preview multi-langues et multi-versions

Construire l’arbre complet (comme en CI GitLab Pages), puis servir :

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

cp zensical-fr-5.0.toml zensical-fr-5.1.toml
cp zensical-en-5.0.toml zensical-en-5.1.toml
# Éditer docs_dir, edit_uri, site_url, site_name, nav, extra.alternate, site_dir (public/...)
```

Puis ajouter les builds et alias dans le `Makefile` (`FR51`, `EN51`, cibles `build` et `pages-artifact`).

## Contrôles qualité

```bash
make lint
make build
```

Pour un guide de déploiement complet, voir [DEPLOYMENT.md](DEPLOYMENT.md).
