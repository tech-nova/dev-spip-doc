# Environnement et Kernel

SPIP 5.0 introduit une gestion de l'environnement basée sur les standards Symfony.

## Variables d'environnement

Le bootstrap du kernel charge automatiquement les fichiers `.env` situés à la racine du projet via le composant `symfony/dotenv`. Les variantes suivantes sont reconnues
(par ordre de priorité) :

1. `.env.<APP_ENV>.local`
2. `.env.<APP_ENV>`
3. `.env.local`
4. `.env`

### Variables reconnues par le Kernel

| Variable | Description | Défaut |
| :--- | :--- | :--- |
| `APP_ENV` | Environnement d'exécution (`prod`, `dev`, `test`) | `prod` |
| `SPIP_CACHE_DIR` | Surcharge du répertoire de cache structurel | `tmp/cache/` |
| `SPIP_ETC_DIR` | Surcharge du répertoire de configuration | `config/` |

### Exemple de fichier `.env`

```env
APP_ENV=dev
# SPIP_CACHE_DIR=/var/spip/cache
# SPIP_ETC_DIR=/etc/spip
```

## Localisation des fichiers de configuration

La recherche d'un fichier `mes_options.php` dans le répertoire `ecrire/` n'est plus supportée.
Tous les fichiers de configuration personnalisés doivent impérativement se trouver dans le répertoire `config/` (ou le répertoire défini par `SPIP_ETC_DIR`).

- `config/mes_options.php` : pour les options historiques.
- `config/custom.php` : pour la nouvelle configuration via le conteneur de services Symfony.
