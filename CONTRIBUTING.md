# Contribution a la documentation

## Regles editoriales

- Un seul titre H1 (`#`) par page.
- Fichiers en kebab-case.
- Liens relatifs entre pages Markdown.
- Pas d'accents dans les noms de fichiers.
- Utiliser `php-inline` pour les extraits de code PHP sans `<?php`.

## Charte visuelle

- Couleur principale: `#69559f` (violet SPIP).
- Logo: `docs/assets/images/spip-mark.svg` (blanc et transparent).
- Navigation externe: Chargee via `docs/assets/javascripts/spip-nav.js`.

## Checklist de revue

- Navigation mise a jour si une page est ajoutee ou deplacee.
- Liens internes valides.
- Images referencees presentes dans le depot.
- Cohérence FR/EN lorsque la page est traduite.

## Workflow recommande

1. `make lint` — analyse Markdown (pymarkdown, récursif sur `docs/fr` et `docs/en`).
2. Si besoin : `make lint-fix` puis relancer `make lint` pour vérifier ce qui reste manuel.
3. `make build` — quatre builds Zensical stricts (validation avant déploiement).

Pour une vérification supplémentaire des liens cassés, vous pouvez ajouter un script dédié dans le dépôt ; il n’est pas imposé par le `Makefile` pour l’instant.
