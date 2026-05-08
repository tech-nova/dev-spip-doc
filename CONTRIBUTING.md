# Contribution a la documentation

## Regles editoriales

- Un seul titre H1 (`#`) par page.
- Fichiers en kebab-case.
- Liens relatifs entre pages Markdown.
- Pas d'accents dans les noms de fichiers.

## Checklist de revue

- Navigation mise a jour si une page est ajoutee ou deplacee.
- Liens internes valides.
- Images referencees presentes dans le depot.
- Cohérence FR/EN lorsque la page est traduite.

## Workflow recommande

1. Lancer `pymarkdown scan docs`.
2. Lancer `python scripts/check_markdown_links.py --docs-dir docs`.
3. Lancer `mkdocs build --strict`.
