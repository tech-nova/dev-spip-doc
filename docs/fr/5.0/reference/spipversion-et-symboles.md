# Versionnement et Symboles

La gestion des versions de SPIP est désormais centralisée dans la classe `Spip\SpipVersion`.

## La classe `SpipVersion`

Cette classe remplace les nombreuses globales et constantes historiques.

| Constante / Méthode | Description | Exemple |
| :--- | :--- | :--- |
| `SpipVersion::VERSION` | Version complète | `5.0.0-dev` |
| `SpipVersion::branch()` | Branche mineure | `5.0` |
| `SpipVersion::BASE` | Version du schéma SQL | `20240508` |
| `SpipVersion::CODE` | Version de compilation | `12345` |
| `SpipVersion::PHP_MIN` | Version PHP minimale requise | `8.4.0` |

## Correspondance des symboles (Migration)

Plusieurs globales et constantes sont supprimées ou dépréciées.

| Ancien symbole | Remplacement recommandé | Statut |
| :--- | :--- | :--- |
| `$GLOBALS['spip_version_branche']` | `SpipVersion::branch()` | Déprécié |
| `$GLOBALS['spip_version_base']` | `SpipVersion::BASE` | Déprécié |
| `_SPIP_VERSION_ID` | `SpipVersion::VERSION` | Déprécié |
| `$GLOBALS['spip_version_code']` | `SpipVersion::CODE` | **Supprimé** |
| `$GLOBALS['spip_version_affichee']` | `SpipVersion::display()` | **Supprimé** |
| `_PHP_MIN` | `SpipVersion::PHP_MIN` | **Supprimé** |

## Autres symboles supprimés

- **`$GLOBALS['auteur_session']` :** Supprimé au profit de `$GLOBALS['visiteur_session']`.
- **`$GLOBALS['formats_logos']` :** Supprimé. Utilisez la fonction `_image_extensions_logos()` pour la lecture et le pipeline `image_extensions_logos` pour l'écriture.
