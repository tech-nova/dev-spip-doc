# Liste des événements de pipelines

SPIP 5.0 propose des classes d'événements dédiées pour les pipelines les plus courants.
Une partie des classes du core se trouvent dans le répertoire `ecrire/src/Framework/Pipeline/Event/`.

Cette page est une référence : elle liste les events disponibles et leurs méthodes utiles. Pour migrer du code existant, consultez [Migrer les pipelines](../upgrade/pipelines.md). Pour les règles de déclaration des listeners, consultez [Référence `AsPipelineListener`](as-pipeline-listener.md).

## Table de correspondance

| Pipeline historique | Classe d'événement | Description |
| :--- | :--- | :--- |
| `affichage_entetes_final` | `AffichageEntetesFinalEvent` | Entêtes HTTP finales des pages publiques |
| `affichage_entetes_final_prive` | `AffichageEntetesFinalPriveEvent` | Entêtes HTTP finales de l'espace privé |
| `affichage_final` | `AffichageFinalEvent` | HTML final des pages publiques |
| `affichage_final_prive` | `AffichageFinalPriveEvent` | HTML final de l'espace privé |
| `insert_head` | `InsertHeadEvent` | Contenu `<head>` public (JS, meta) |
| `insert_head_css` | `InsertHeadCssEvent` | CSS dans `<head>` public |
| `header_prive` | `HeaderPriveEvent` | Contenu `<head>` privé (JS, meta) |
| `header_prive_css` | `HeaderPriveCssEvent` | CSS dans `<head>` privé |
| `formulaire_charger` | `FormulaireChargerEvent` | Chargement des formulaires CVT |
| `formulaire_verifier` | `FormulaireVerifierEvent` | Vérification des formulaires CVT |
| `formulaire_traiter` | `FormulaireTraiterEvent` | Traitement des formulaires CVT |
| `formulaire_fond` | `FormulaireHtmlEvent` | HTML rendu d'un formulaire CVT |
| `affiche_formulaire_login` | `FormulaireHtmlLoginEvent` | HTML rendu du formulaire de login |
| `editer_contenu_objet` | `FormulaireHtmlEditerObjetEvent` | HTML rendu des formulaires d'édition d'objet |
| `formulaire_admin` | `FormulaireHtmlAdministrationEvent` | HTML rendu du formulaire d'administration |
| `traduire` | `FormulaireHtmlTraduireEvent` | HTML rendu du formulaire de traduction |
| `styliser` | `StyliserEvent` | Sélection du squelette |
| `pre_liens` | `PreLiensEvent` | Texte avant expansion des raccourcis de liens |
| `recuperer_fond` | `RecupererFondEvent` | Interception des inclusions |
| `boite_infos` | `BoiteInfosEvent` | Boîte d'infos objets (privé) |
| `affiche_milieu` | `AfficheMilieuEvent` | Zone centrale des pages objets |
| `taches_generales_cron` | `TachesGeneralesCronEvent` | Déclaration des tâches cron |
| `post_insertion` | `PostInsertionEvent` | Après insertion en base |
| `pre_edition` | `PreEditionEvent` | Avant modification d'un objet |
| `post_edition` | `PostEditionEvent` | Après modification d'un objet |

### Pipelines sans classe d’événements

Ces pipelines n’ont pas encore de classe d’événements associés.

- auth_administrer (ecrire)
- configurer_liste_metas (ecrire)
- trig_purger (ecrire)
- trig_supprimer_objets_tables (ecrire)
- compagnon_messages (compagnon)
- forum_objets_depuis_env (forum)
- mediabox_config (mediabox)
- afficher_metas_document (medias)
- get_spip_doc (medias)
- quete_logo_objet (medias)
- medias_documents_visibles (medias)
- medias_methodes_upload (medias)
- renseigner_document (medias)
- mots_indexation (mots)
- revisions_chercher_label
- pre_syndication (sites)
- post_syndication (sites)
- delete_statistiques (stats)
- svp_afficher_paquet (svp)
- porte_plume_lien_classe_vers_icone (porte plume)
- porte_plume_barre_pre_charger (porte plume)
- porte_plume_barre_charger (porte plume)
- propre_creer_chaine_url (urls)
- arbo_creer_chaine_url (urls)

## Utilisation générique

Pour les pipelines ne disposant pas encore d'une classe dédiée, vous pouvez utiliser la classe générique **`SpipLeague\Bridge\Pipeline\PipelineEvent`**.

Dans ce cas, déclarez le listener avec un pipeline explicite :

```php-inline
use SpipLeague\Bridge\Pipeline\PipelineEvent;
use SpipLeague\Component\Kernel\Attribute\AsPipelineListener;

final class LegacyPipelineListener
{
    #[AsPipelineListener('mon_pipeline_legacy')]
    public function onMonPipelineLegacy(PipelineEvent $event): void
    {
        $data = $event->getSubject();
        $args = $event->getArguments();
        // ...
        $event->setSubject($data);
    }
}
```

`PipelineEvent` ne permet pas la déduction automatique du pipeline avec `#[AsPipelineListener]` sans argument.

Elle propose les méthodes suivantes :

- `getSubject()` / `setSubject()` : pour manipuler les données principales (anciennement `$flux['data']` ou `$flux`).
- `getArguments()` / `getArgument($key)` : pour accéder au contexte (anciennement `$flux['args']`).

## Détails de certains événements

### Interface de base

```php-inline
interface PipelineEventInterface extends StoppableEventInterface
{
    public function getPipelineName(): string;
    public function getEventName(): string;
    public function getSubject(): mixed;
    public function setSubject(mixed $subject): void;
    public function getArguments(): array;
    public function getArgument(string $key, mixed $default = null): mixed;
    public function hasArgument(string $key): bool;
    public function isStructured(): bool;
    public function toPayload(): mixed;
}
```

## Events disponibles

### Affichage

#### `AffichageFinalEvent`

Pipeline `affichage_final` - Modification du HTML final avant envoi.

```php-inline
final class MyListener
{
    #[AsPipelineListener]
    public function onAffichageFinal(AffichageFinalEvent $event): void
    {
        // Méthodes typées et documentées
        $html = $event->getHtml();
        
        // Helpers pratiques
        $event->appendToBody('<script>...</script>');
        $event->appendToHead('<meta ...>');
        $event->replace('foo', 'bar');
        
        // Vérification du type de page
        if ($event->isHtmlPage()) {
            // ...
        }
    }
}
```

### Header / CSS

#### `InsertHeadEvent`

Pipeline `insert_head` - Injection dans le `<head>` public.

```php-inline
final class AnalyticsListener
{
    #[AsPipelineListener]
    public function onInsertHead(InsertHeadEvent $event): void
    {
        $event->addScript('/plugins/analytics/tracker.js');
        $event->addModuleScript('/js/module.js');
        $event->addMeta('robots', 'index, follow');
        $event->addMetaProperty('og:title', 'Mon titre');
        $event->addLink('canonical', 'https://...');
        $event->addPreload('/fonts/main.woff2', 'font');
    }
}
```

#### `InsertHeadCssEvent`

Pipeline `insert_head_css` - Injection de CSS.

```php-inline
final class ThemeListener
{
    #[AsPipelineListener]
    public function onInsertHeadCss(InsertHeadCssEvent $event): void
    {
        $event->addStylesheet('/plugins/theme/dark-mode.css', 'screen');
        $event->addInlineStyle(':root { --primary: #007bff; }');
        $event->addPrintStylesheet('/print.css');
    }
}
```

#### `HeaderPriveEvent`

Pipeline `header_prive` - Injection dans le `<head>` de l'espace privé.

### Formulaires CVT

#### `FormulaireChargerEvent`

Pipeline `formulaire_charger` - Valeurs par défaut.

```php-inline
final class DefaultsListener
{
    #[AsPipelineListener]
    public function onFormulaireCharger(FormulaireChargerEvent $event): void
    {
        if ($event->getFormName() !== 'inscription') {
            return;
        }
        
        $event->setValue('newsletter', true);
        $event->setValue('pays', 'FR');
        $event->mergeValues(['source' => 'web']);
    }
}
```

#### `FormulaireVerifierEvent`

Pipeline `formulaire_verifier` - Validation.

```php-inline
final class ValidationListener
{
    #[AsPipelineListener]
    public function onFormulaireVerifier(FormulaireVerifierEvent $event): void
    {
        if ($event->getFormName() !== 'inscription') {
            return;
        }
        
        $email = _request('email');
        if (!filter_var($email, FILTER_VALIDATE_EMAIL)) {
            $event->addError('email', _T('erreur_email_invalide'));
        }
        
        if ($event->hasErrors()) {
            $event->addGlobalError('Veuillez corriger les erreurs.');
        }
    }
}
```

#### `FormulaireTraiterEvent`

Pipeline `formulaire_traiter` - Post-traitement.

```php-inline
final class NotificationListener
{
    #[AsPipelineListener]
    public function onFormulaireTraiter(FormulaireTraiterEvent $event): void
    {
        if ($event->getFormName() !== 'contact') {
            return;
        }
        
        $this->sendNotification(_request('email'));
        
        $event->setSuccessMessage('Message envoyé !');
        $event->setRedirect(generer_url_ecrire('confirmation'));
    }
}
```

### Édition d'objets

#### `PreInsertionEvent`

Pipeline `pre_insertion` - Avant insertion en base.

```php-inline
final class ArticleDefaultsListener
{
    #[AsPipelineListener]
    public function onPreInsertion(PreInsertionEvent $event): void
    {
        if ($event->getTable() !== 'spip_articles') {
            return;
        }
        
        if (!$event->hasField('lang')) {
            $event->setField('lang', $GLOBALS['meta']['langue_site']);
        }
    }
}
```

#### `PostInsertionEvent`

Pipeline `post_insertion` - Après insertion.

```php-inline
final class ArticleCreatedListener
{
    #[AsPipelineListener]
    public function onPostInsertion(PostInsertionEvent $event): void
    {
        if ($event->getTable() !== 'spip_articles') {
            return;
        }
        
        $id = $event->getInsertedId();
        $titre = $event->getField('titre');
        
        $this->notifyEditors($id, $titre);
    }
}
```

### Squelettes

#### `StyliserEvent`

Pipeline `styliser` - Résolution des squelettes.

```php-inline
final class MobileTemplateListener
{
    #[AsPipelineListener]
    public function onStyliser(StyliserEvent $event): void
    {
        if (!$this->isMobile()) {
            return;
        }
        
        if ($event->getFond() === 'article' && !$event->hasSquelette()) {
            $event->setSquelette('squelettes/mobile/article.html');
        }
    }
}
```

### Tables SQL

Ces événements sont définis dans `ecrire/src/Framework/Pipeline/Event/` :

- **`DeclarerTablesInterfacesEvent`** (`declarer_tables_interfaces`) — `getInterfaces()` / `setInterfaces()`
- **`DeclarerTablesPrincipalesEvent`** (`declarer_tables_principales`) — `getTables()` / `setTables()` (préfixes sans préfixe `spip_`)
- **`DeclarerTablesAuxiliairesEvent`** (`declarer_tables_auxiliaires`) — `getTables()` / `setTables()`

#### `DeclarerTablesObjetsSqlEvent`

Pipeline `declarer_tables_objets_sql` - Déclaration de tables.

```php-inline
final class ProductTableListener
{
    #[AsPipelineListener]
    public function onDeclarerTablesObjetsSql(DeclarerTablesObjetsSqlEvent $event): void
    {
        $event->declareTable('spip_products', [
            'type' => 'product',
            'principale' => 'oui',
            'field' => [
                'id_product' => 'bigint(21) NOT NULL',
                'titre' => 'text NOT NULL DEFAULT ""',
                'prix' => 'decimal(10,2) NOT NULL DEFAULT 0',
            ],
            'key' => ['PRIMARY KEY' => 'id_product'],
        ]);
        
        // Ou modifier une table existante
        $event->addField('spip_articles', 'featured', 'tinyint(1) DEFAULT 0');
        // Fusion de clés complémentaires (jointures editables, etc.)
        $event->modifyTable('spip_articles', ['tables_jointures' => ['documents']]);
        // Jointure héritée par toutes les tables d’objets (cf. compilateur `$infos_tables`)
        $event->addJoinForAllObjects('versions');
    }
}
```

### Layout espace privé

#### `AfficheGaucheEvent`, `AfficheMilieuEvent`, `AfficheDroiteEvent`

```php-inline
final class StatsWidgetListener
{
    #[AsPipelineListener]
    public function onAfficheGauche(AfficheGaucheEvent $event): void
    {
        if ($event->getExec() !== 'accueil') {
            return;
        }
        
        $event->addBox('Statistiques', $this->renderStats(), 'stats-box');
        $event->appendHtml('<div>Custom content</div>');
    }
}
```
