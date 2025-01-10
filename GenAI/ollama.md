
# Ollama

Run LLM locally

- start: `ollama serve`
- list models: `ollama list`
- Download lodel: `ollama pull llama3.1`
- Run model: `ollama run llama3.1`
- delete models: `ollama rm llama3.1`

- tests : 
```sh
curl http://localhost:11434/api/generate -d '{
  "model": "llama3.1:8b",
  "prompt": "Hello"
}'
```


# Open WebUI

Container without Web authentication: 
`docker run -d -p 9000:8080 --add-host=host.docker.internal:host-gateway --name open-webui -e WEBUI_AUTH=false ghcr.io/open-webui/open-webui:main`

Container with authentication and volume: 
`docker run -d -p 9000:8080 --add-host=host.docker.internal:host-gateway -v ~/instances/open-webui/data:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:main`


# Formats Modèles LLM
Les 3 principaux formats de modèles : 

* pytorch : C'était la norme de facto, du fait d'être le premier, mais il est de plus en plus remplacé par Huggingface safetensors comme format de publication par défaut. C'est toujours le meilleur format pour utiliser les principaux frameworks de pré-entraînement/d'ajustement fin (comme Metatron et Axolotl), mais il n'est pas aussi performant pour l'inférence ou le développement de nouvelles technologies. Il est également sujet à "l'enfer des bibliothèques", car vous devez utiliser Python et des bibliothèques compatibles avec celles utilisées par les auteurs (et ils ne publient pas toujours ces informations).
* safetensors : De plus en plus populaire, il évite "l'enfer des bibliothèques" de pytorch. Compatible avec le framework Huggingface Transformers, qui est très riche en fonctionnalités et facilite le développement de nouveaux systèmes avec des fonctionnalités avancées.
* GGUF : Le format de modèle standard pour llama.cpp et les systèmes construits sur celui-ci (y compris de nombreuses piles d'inférence open source populaires). Idéal pour l'inférence, mais le développement de nouvelles technologies pour celui-ci peut être un peu pénible. llama.cpp possède certaines fonctionnalités d'entraînement et d'ajustement fin, mais elles sont encore vestigiales et ont beaucoup de chemin à parcourir avant de rattraper les frameworks basés sur pytorch.


Note: 
* il est possible de convertir ces différents format entre eux, comme par exemple convertir un modèle au format Safetensors vers le format GGUF avec le script Python **convert_hf_to_gguf.py** de Llama.cpp
* Il existe plein d'autre format comme ....

## Récupérer des modèle des Huggingface
git clone git@hf.co:<MODEL ID>

## create le fichier modele Ollama


## Create
Une fois le fichier modèle Ollama créer, exexuter la commande `ollama create -f [Model-filename] [Tag] ` pour charger le modèle. Exemple:
`ollama create -f ollama-pixtral.modelfile Pixtral-12B`

## Quantizing a Model
Ollama peut effectuer une quantification d'un modèle au moment de l'import avec le paramètre **-q/--quantize**
exemple: `ollama create --quantize q4_K_M mymodel`
Voir à la [documentation Ollama](https://github.com/ollama/ollama/blob/main/docs/import.md) pour voir les quantifications supportées. 
