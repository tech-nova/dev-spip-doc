# API PHP et Fonctions

SPIP 5.0 modernise son API PHP en adoptant des standards PSR et en simplifiant plusieurs fonctions historiques.

## Système de Log (PSR-3)

La fonction `spip_log()` est dépréciée au profit de `spip_logger()`, qui retourne une instance compatible avec `Psr\Log\LoggerInterface`.

Pour plus de détails sur l'utilisation, l'injection de dépendances et la configuration du logger, consultez le guide dédié : **[Système de Log (PSR-3)](../features/logger.md)**.

## Fonctions supprimées ou renommées

Plusieurs fonctions dépréciées ont été supprimées. Voici les principales correspondances :

| Fonction supprimée | Remplacement |
| :--- | :--- |
| `spip_sha256($val)` | `hash('sha256', $val)` |
| `abs_url($url)` | `url_absolue($url)` ou `liens_absolus($texte)` |
| `http_status($code)` | `http_response_code($code)` |
| `json_export($data)` | `json_encode($data)` |
| `var2js($data)` | `json_encode($data)` |
| `compacte($css, 'css')` | `minifier($css, 'css')` |
| `generer_url_entite()` | `generer_objet_url()` |
| `generer_url_ecrire_objet()` | `generer_objet_url_ecrire()` |

### Exemples de migration

**Migration de `abs_url()` :**
```php
// Avant
$url = abs_url($url);
$texte = abs_url($texte);

// Après
$url = url_absolue($url);
$texte = liens_absolus($texte);
```

**Migration de `generer_url_ecrire_objet()` :**
```php
// Avant
$url = generer_url_ecrire_objet(3, 'article');

// Après
$url = generer_objet_url_ecrire(3, 'article');
```

**Migration de `json_export()` :**
```php
// Avant
$json = json_export($data);

// Après
$json = json_encode($data);
```

## Migration des constantes vers le Kernel

De nombreuses constantes de chemin et d'état sont supprimées au profit d'appels au Kernel ou au conteneur de services.

| Ancienne constante | Remplacement PHP recommandé |
| :--- | :--- |
| `_DIR_RESTREINT_ABS` | `app()->getCoreDir()` ou `param('spip.routes.back_office')` |
| `_ROOT_RACINE` | `app()->getRootDir()` |
| `_ROOT_RESTREINT` | `app()->getCoreDir()` |
| `_ROOT_CWD` | `app()->getCwd()` |
| `_DIR_LOG` | `app()->getLogDir()` |
| `_ESPACE_PRIVE` | `app()->isBackOffice()` |
| `_IS_CLI` | `PHP_SAPI === 'cli'` |

*Note : `app()` et `param()` sont dans l'espace de nom `SpipLeague\Component\Kernel`.*

## Fichiers de langue
Les fichiers de langue ne doivent plus peupler la globale `$GLOBALS[$GLOBALS['idx_lang']]`. Ils doivent désormais simplement retourner le tableau PHP.
```php
// config/lang/paquet-monplugin_fr.php
return [
    'monplugin_titre' => 'Mon Plugin',
];
```
