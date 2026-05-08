# Dépréciations et Suppressions

Ce document récapitule les éléments supprimés ou dépréciés dans SPIP 5.0 qui n'ont pas été traités dans les sections thématiques.

## Sécurité et Données

### Unserialization automatique
Le filtre `|table_valeur` et la boucle `(DATA)` avec `{source tableau}` ne tentent plus d'appliquer `unserialize()` automatiquement sur les chaînes de caractères.
- **Action :** Passez directement un tableau ou gérez la désérialisation explicitement si la source est sûre.
- **Rappel :** Ne jamais désérialiser des données provenant de l'utilisateur (`#ENV`, `_request()`).

### Champ PGP
Le champ `pgp` de la table `spip_auteurs` est supprimé.
- Si vous utilisiez ce champ, vous pouvez le recréer via le plugin **Champs Extras**.

### Sanitization des requêtes
Le second argument de `spip_sanitize_from_request()` ne supporte plus les tableaux ou l'astérisque `*`.
- Pour sanitizer tout l'environnement ou un tableau de valeurs, utilisez la nouvelle fonction **`spip_sanitize_env_from_request()`**.

#### Avant
```php-inline
$env = spip_sanitize_from_request($env, ['key1', 'key2']); // Sanitization partielle
$env = spip_sanitize_from_request($env, '*');             // Sanitization de tout l'environnement
```

#### Après
```php-inline
$env = spip_sanitize_env_from_request($env, ['key1', 'key2']); // Sanitization partielle
$env = spip_sanitize_env_from_request($env);                  // Sanitization complète
```

## Divers

### NETPBM
Le support de NETPBM pour la génération de vignettes est supprimé. Utilisez GD2 ou Imagick.

### Surlignage
Le surlignage des mots de recherche est déplacé dans un plugin externe nommé **Surligne**.

### Support `<math>`
Le support natif de la balise `<math>` est supprimé. Utilisez le plugin **MathJax**.

### Variables globales supprimées
- `$GLOBALS['auteur_session']` : utilisez `$GLOBALS['visiteur_session']`.
- `$GLOBALS['formats_logos']` : utilisez la fonction `_image_extensions_logos()` et le pipeline `image_extensions_logos`.

### Gestion des verrous (Locks)
La constante `_SPIP_LOCK_MODE = 2` (pour NFS) n'est plus supportée nativement. Utilisez le plugin **nfslock**.
