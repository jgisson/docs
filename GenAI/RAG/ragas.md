Dans le framework **RAGAS** (Retrieval-Augmented Generation Assessment), la classe `SingleTurnSample` est l'unité de base utilisée pour évaluer une seule interaction (un "tour") entre un utilisateur et un système RAG.

Contrairement aux versions précédentes de RAGAS qui utilisaient des dictionnaires simples, cette classe permet de structurer les données pour garantir que les métriques d'évaluation reçoivent les bons types d'informations.

Voici les principales propriétés de cette classe :

### 1. Propriétés Fondamentales (Input/Output)

Ces propriétés représentent ce qui s'est réellement passé lors de l'interaction :

* **`user_input`** : La question ou la requête formulée par l'utilisateur (le "Prompt").
* **`response`** : La réponse générée par le modèle LLM.
* **`retrieved_contexts`** (Optionnel) : Une liste de chaînes de caractères (strings) représentant les documents ou morceaux de texte récupérés par le système de recherche pour répondre à la question.

### 2. Propriétés de Référence (Ground Truth)

Ces propriétés sont utilisées comme "vérité terrain" pour comparer les performances du système :

* **`reference`** (Optionnel) : La réponse idéale ou correcte attendue. Elle est indispensable pour calculer des métriques comme la **Faithfulness** (fidélité) ou la **Answer Correctness**.
* **`reference_contexts`** (Optionnel) : Les contextes qui auraient *dû* être récupérés. Utile pour évaluer la précision du moteur de recherche (Context Recall).

### 3. Autres Attributs

* **`rubric`** (Optionnel) : Un dictionnaire ou une description de critères spécifiques à utiliser si vous faites une évaluation basée sur des rubriques personnalisées.

---

### Pourquoi utiliser `SingleTurnSample` ?

L'utilisation de cette classe au lieu d'un simple JSON permet à RAGAS d'effectuer des validations automatiques. Par exemple, si vous essayez de calculer le **Context Precision** mais que vous avez oublié de remplir la propriété `retrieved_contexts`, RAGAS pourra vous avertir immédiatement.

Voici un exemple rapide de création d'un échantillon :

```python
from ragas import SingleTurnSample

sample = SingleTurnSample(
    user_input="Quelle est la capitale de la France ?",
    retrieved_contexts=["Paris est la capitale et la plus grande ville de France."],
    response="La capitale de la France est Paris.",
    reference="Paris"
)

```

### Résumé exhaustif des propriétés et objectifs par métrique

| Métrique | Propriétés requises / utilisées | Rôle de `reference_contexts` | Objectif / Rôle de la métrique |
| --- | --- | --- | --- |
| **Context Recall** | `reference`, `retrieved_contexts`, **`reference_contexts`** | **Crucial** : Sert de base de comparaison pour vérifier l'exhaustivité de la recherche. | Mesurer si le moteur de recherche (Retriever) a trouvé toutes les informations nécessaires pour répondre à la question. |
| **Context Precision** | `user_input`, `retrieved_contexts`, `reference` | Optionnel : Peut aider à valider la pertinence des extraits. | Évaluer si les documents pertinents sont classés en haut de la liste des résultats récupérés. |
| **Context Semantic Similarity** | `retrieved_contexts`, **`reference_contexts`** | **Direct** : Utilisé pour calculer la proximité vectorielle. | Vérifier la similarité sémantique globale entre les documents trouvés et les documents idéaux. |
| **Faithfulness** (Fidélité) | `response`, `retrieved_contexts` | Aucun. | S'assurer que la réponse ne contient pas d'hallucinations et provient uniquement des documents récupérés. |
| **Answer Relevance** | `user_input`, `response` | Aucun. | Évaluer si la réponse est concise et répond directement à la question posée (sans hors-sujet). |
| **Answer Correctness** | `response`, `reference` | Aucun. | Mesurer la justesse de la réponse finale par rapport à la réponse de référence (vérité terrain). |
| **Harmfulness** | `user_input`, `response` | Aucun. | **Sécurité** : Détecter si la réponse contient du contenu offensant, dangereux ou inapproprié. |

---

### Analyse de l'architecture des métriques

Le framework RAGAS divise généralement ces métriques en trois composants de confiance, souvent visualisés sous forme de triangle :

1. **Génération** (`Faithfulness`, `Answer Relevance`) : Évalue la qualité du LLM à partir du contexte.
2. **Récupération** (`Context Precision`, `Context Recall`) : Évalue la performance du moteur de recherche.
3. **Qualité Finale** (`Answer Correctness`, `Harmfulness`) : Évalue l'expérience utilisateur et la sécurité.

### Note sur `Harmfulness` et les métriques de critique

La métrique **Harmfulness** fait partie des *Aspect Critics*. Ces métriques ne produisent pas un score continu de 0 à 1 par défaut, mais souvent un résultat binaire (Vrai/Faux) pour indiquer si le critère est respecté. Elles sont très utiles pour les tests de conformité avant une mise en production.



### Focus sur `reference_contexts`

Dans `SingleTurnSample`, cette propriété attend une liste de chaînes de caractères (`list[str]`).

On l'utilise principalement pour :

1. **L'évaluation isolée du Retriever** : Pour savoir si votre moteur de recherche a extrait les bons documents, indépendamment de la réponse du LLM.
2. **Le calcul du "Recall"** : Si vous avez 5 paragraphes qui contiennent la réponse dans votre base de données (`reference_contexts`) et que votre système n'en trouve que 2 (`retrieved_contexts`), votre score de rappel sera impacté.

**Exemple de code :**

```python
sample = SingleTurnSample(
    user_input="Quelle est la capitale de la France ?",
    retrieved_contexts=["Lyon est une ville française."], # Mauvais contexte récupéré
    reference_contexts=["Paris est la capitale de la France."], # Contexte attendu
    response="La capitale est Lyon.",
    reference="Paris"
)

```