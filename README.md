# Documentation SPIP

Ce répertoire contient la documentation technique de SPIP, organisée par version et par langue.

## Structure

- `docs/fr/` : Documentation en français
- `docs/en/` : Documentation en anglais (en cours de rédaction)

Chaque langue est ensuite divisée par version majeure de SPIP (ex: `5.0/`).

## Contenu par version

Pour SPIP 5.0 :
- [Guide de migration (Upgrade)](docs/fr/5.0/upgrade/index.md)
- [Nouvelles fonctionnalités (Features)](docs/fr/5.0/features/index.md)
- [Référence technique](docs/fr/5.0/reference/index.md)

## Outillage MkDocs Material

Configuration standard :

- `mkdocs.yml` : configuration du site
- `docs/` : contenu Markdown
- `requirements.txt` : dépendances Python de la toolchain docs

### Installation locale

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
```

### Preview local

```bash
source .venv/bin/activate
mkdocs serve
```

### Build statique

```bash
source .venv/bin/activate
mkdocs build --strict
```

## Controles qualite

Lint Markdown :

```bash
source .venv/bin/activate
pymarkdown scan docs
```

Verification des liens internes et des assets images :

```bash
source .venv/bin/activate
python scripts/check_markdown_links.py --docs-dir docs
```

Verification optionnelle des liens externes :

```bash
source .venv/bin/activate
python scripts/check_markdown_links.py --docs-dir docs --check-external
```

## Convention blocs PHP

Pour garantir la coloration syntaxique des extraits PHP qui ne contiennent pas `<?php`, la documentation utilise `php-inline` :

````md
```php-inline
namespace SpipContrib\Plugin\MonPlugin\Cron\Task;
```
````

Utilisez `php` pour les fichiers PHP complets avec balise d'ouverture présente `<?php`.
