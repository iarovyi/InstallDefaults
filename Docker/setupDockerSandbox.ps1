# 1. Setup Codex sandbox secret
sbx secret set -g openai --oauth 

# 2. Setup GitHub copilot sandbox secret
gh auth login
gh auth token | sbx secret set -g github --force