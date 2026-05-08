# Référence technique SPIP 4.4

Cette section regroupe les détails techniques et les changements de SPIP 4.4.

## Résumé des changements

### Ajouts

| Élément | Description |
|---------|-------------|
| `#LAYOUT_PRIVE` | Nouvelles dispositions pour l'espace privé |
| `#TRAD` | Syntaxe simplifiée pour les chaînes de langue |
| `#URL_DOCUMENT_FICHIER` | URL vers le fichier d'un document |
| `#MIME_TYPE` | Type MIME calculé |
| `#PARAM` | Accès aux paramètres du container de services |
| `image_oriente_selon_exif()` | Réorientation automatique des images |
| Pipeline `ajouter_menus_args` | Arguments de `definir_barre_boutons()` |
| Pipeline `image_extensions_logos` | Personnalisation des extensions logos |

### Modifications comportementales

- Les filtres d'images comme `image_recadre` réorientent l'image selon l'EXIF
- Le filtre `|affdate` accepte un timestamp en entrée
- Les valeurs vidées en AJAX passent par `var_nullify`
- Utilisation de variables CSS et propriétés logiques dans l'espace privé

### Corrections notables

- Rotation des images avec ImageMagick (convert)
- Utilisation de `fpassthru()` au lieu de `readfile()` pour éviter les memory limit
- Requêtes distantes avec `STREAM_CRYPTO_METHOD_TLS_CLIENT`
- Masquage des emails des auteurs par défaut

## Dépréciations

!!! warning "Éléments dépréciés"
    Ces éléments génèrent des avertissements et seront supprimés dans SPIP 5.0.

### Balises et inclusions

- `<INCLURE(fichier.php)>`
- `<INCLURE{fond=fichier.php}>`
- `</INCLURE>` (balise fermante)
- `#LARGEUR_ECRAN`

### Constantes et globales

- `_DIR_IMG_PACK`
- `_DIR_RESTREINT_ABS`
- `$formats_logos`
- `$traiter_math`, `$tex_server`

### Fonctions

- `produire_image_math()`, `traiter_math()`, `replace_math()` → utiliser le plugin `mathjax`
- `phraser_boucle_placeholder()` → `phraser_placeholder_memoriser()` ou `phraser_placeholder_reinjecter()`
- `public_generer_boucle_placeholder()` → `public_placeholder_generer()`
- `|image_typo` et fonctions associées → plugin "Images typographiques"

## Retraits

Ces éléments ont été supprimés de SPIP 4.4 :

- `verif_butineur()`
- `editer_texte_recolle()`
- Environnement `_texte_trop_long` (servait pour Internet Explorer)
