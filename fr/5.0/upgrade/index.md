# Guide de migration vers SPIP 5.0

Ce guide vous accompagne dans la mise à jour de vos sites et plugins de SPIP 4.x vers SPIP 5.0.

## Sommaire de migration

1.  **[Préliminaires et Prérequis](prerequis.md)**
    *   PHP 8.2+
    *   Migration de la base de données
    *   Nouveau layout des `plugins-dist/`
2.  **[Environnement et Kernel](environnement-kernel.md)**
    *   Variables d'environnement `.env`
    *   Configuration du Kernel
3.  **[Squelettes et Syntaxe](squelettes.md)**
    *   Parties optionnelles des balises
    *   Casse des items de langue
    *   Inclusions PHP supprimées
4.  **[API PHP et Fonctions](php-api.md)**
    *   Système de Log (PSR-3)
    *   Fonctions supprimées ou renommées
    *   Constantes migrées vers le Kernel
5.  **[Javascript et Assets](javascript.md)**
    *   Modules ESM
    *   Émancipation de jQuery
    *   Migration des balises `<script>` et `<style>`
6.  **[Espace privé et Menus](espace-prive-et-menus.md)**
    *   Renommage des pages et menus
    *   Modifications de l'UI
7.  **[Dépréciations et Suppressions](deprecations-et-suppressions.md)**
    *   Récapitulatif des éléments retirés
    *   Conseils de remplacement
