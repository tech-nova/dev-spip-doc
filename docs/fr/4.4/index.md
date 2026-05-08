# SPIP 4.4 - Documentation technique

SPIP 4.4 est une version LTS (Long Term Support) bénéficiant d'un support étendu jusqu'en juillet 2028.

## Compatibilité

- **PHP** : 7.4 à 8.5
- **Extensions requises** : sodium, Zlib, Zip, Phar

## Points clés de cette version

Cette version apporte plusieurs améliorations significatives :

- **Sécurité renforcée** : Les mots de passe ne sont plus envoyés en clair dans les emails d'inscription et de rappel
- **Installation Composer** : Les dossiers `ecrire`, `prive`, `squelettes-dist` et l'écran de sécurité s'installent désormais via Composer
- **Nouvelles balises** : `#LAYOUT_PRIVE`, `#URL_DOCUMENT_FICHIER`
- **Optimisations** : Performances améliorées pour les filtres d'images

## Sommaire

### [Guide de migration](upgrade/index.md)

Informations pour mettre à jour depuis une version antérieure.

### [Nouvelles fonctionnalités](features/index.md)

Découvrez les nouveautés de SPIP 4.4.

- Balise `#LAYOUT_PRIVE` pour les dispositions de l'espace privé
- Nouveaux pipelines et filtres d'images

### [Référence technique](reference/index.md)

Détails techniques et listes des changements.

- Ajouts et modifications d'API
- Dépréciations à anticiper pour SPIP 5.0
- Corrections de bugs
