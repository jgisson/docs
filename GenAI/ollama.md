
# Ollama

Run LLM locally

- start: `ollama serve`
- list models: `ollama list`
- Download lodel: `ollama pull llama3`
- Run model: `ollama run llama3`
- delete models: `ollama rm llama3`


# Open WebUI

Container without Web authentication: 
`docker run -d -p 9000:8080 --add-host=host.docker.internal:host-gateway --name open-webui -e WEBUI_AUTH=false ghcr.io/open-webui/open-webui:main`

Container with authentication and volume: 
`docker run -d -p 9000:8080 --add-host=host.docker.internal:host-gateway -v ~/instances/open-webui/data:/app/backend/data --name open-webui ghcr.io/open-webui/open-webui:main`