# Guide de migration vers SPIP 4.4

Ce guide vous accompagne dans la mise à jour vers SPIP 4.4.

## Prérequis

- **PHP** : Version 7.4 minimum, compatible jusqu'à PHP 8.5
- **Extensions PHP requises** : sodium, Zlib, Zip, Phar

## Changements majeurs

### Installation via Composer

Les dossiers suivants s'installent désormais avec Composer :

- `ecrire/`
- `prive/`
- `squelettes-dist/`
- Écran de sécurité

!!! note "Impact utilisateurs"
    Ce changement est transparent pour les utilisateurs de spip_loader.

### Sécurité des mots de passe

SPIP n'envoie plus de mot de passe en clair dans les emails. Les utilisateurs reçoivent désormais des liens pour définir leur mot de passe.

## Dépréciations à anticiper

Ces éléments sont dépréciés et seront supprimés dans une future version :

### Squelettes

- Inclusion de fichier PHP via `<INCLURE(fichier.php)>` ou `<INCLURE{fond=fichier.php}>`
- Balise fermante `</INCLURE>`
- Balise `#LARGEUR_ECRAN` → utiliser `#LAYOUT_PRIVE`

!!! warning "Sensibilité à la casse"
    À partir de SPIP 5, l'appel des chaînes de langues en squelette sera sensible à la casse de la déclaration.

### PHP

- Fichiers de langue peuplant `$GLOBALS` → renvoyer directement un tableau
- Constante `_DIR_IMG_PACK` (obsolète)
- Constante `_DIR_RESTREINT_ABS`
- Globale `$formats_logos` → utiliser `_images_extensions_logos()` ou le pipeline `image_extensions_logos`

### Fonctions supprimées

- `verif_butineur()`
- `editer_texte_recolle()`
- Environnement `_texte_trop_long` des formulaires

## Plugins compatibles

La plupart des plugins sont déjà compatibles avec SPIP 4.4. Consultez le référentiel des plugins pour vérifier la compatibilité.
