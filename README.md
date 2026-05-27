# AWS GenAI Pro

Notes and reference for AWS generative AI professional certification, built with [MkDocs Material](https://squidfunk.github.io/mkdocs-material/).

**Live site:** https://qgjones9.github.io/aws-genai-pro/

## Local development

```bash
source setup.sh
```

Or manually:

```bash
python3 -m venv .venv
source .venv/bin/activate
pip install -r requirements.txt
mkdocs serve
```

## Publishing

Pushes to `main` deploy automatically via [`.github/workflows/deploy-docs.yml`](.github/workflows/deploy-docs.yml). In the repo **Settings → Pages**, set the source to **GitHub Actions**.
