# Prérequis et Préliminaires

La mise à jour vers SPIP 5.0 nécessite quelques vérifications préalables sur votre environnement serveur et votre installation actuelle.

## Environnement technique

### PHP 8.2 minimum

SPIP 5.0 nécessite **PHP 8.2** au minimum. Assurez-vous que votre serveur dispose d'une version compatible avant de lancer la mise à jour.

### Migration de la base de données

SPIP 5.0 ne contient plus les scripts de migration de base de données antérieurs à SPIP 4.0.

- Il est impératif de partir d'une version de SPIP **3.2 ou supérieure**.
- Il est fortement conseillé de mettre à jour votre site vers **SPIP 4.1 minimum, idéalement 4.4** avant de passer à la version 5.0 pour garantir une transition
  fluide.

## Structure des fichiers

### Déplacement des `plugins-dist/`

Les plugins fournis avec la distribution SPIP (plugins-dist) sont désormais installés via Composer ou présents dans un sous-répertoire dédié.

- Ils sont situés dans `plugins-dist/spip/` (ex: `plugins-dist/spip/tw` pour Textwheel).
- Auparavant, ils étaient directement à la racine de `plugins-dist/`.
- Lors de la migration, veillez à supprimer les anciens répertoires à la racine de `plugins-dist/` s'ils persistent.

## Webmestres

La constante `_ID_WEBMESTRES` (dépréciée depuis SPIP 2.1) est supprimée.

- Si vous l'utilisiez dans `config/mes_options.php`, vous devez la retirer.
- La gestion des webmestres se fait désormais via l'interface privée (fiche auteur) ou directement via le champ `webmestre` (0 ou 1) dans la table `spip_auteurs`.
