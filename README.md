# shopify-agency-cli

[![license MIT](https://img.shields.io/npm/l/shopify-agency-cli)](https://github.com/raheemdev/claude-agents-for-shopify/blob/main/LICENSE) [![npm](https://img.shields.io/npm/v/shopify-agency-cli)](https://www.npmjs.com/package/shopify-agency-cli)

CLI tool to generate agency config for Shopify client repos. Scaffolds project standards, skills, hooks, documentation, and tooling into any Shopify theme repository.

## Install

```bash
npm i -g shopify-agency-cli
```

Or install from source:

```bash
git clone https://github.com/raheemdev/shopify-agency-cli.git
cd shopify-agency-cli
npm link
```

## Usage

```bash
shopify-agency init <domain> <myshopify-url> <github-repo-url> [target-dir] [--force]
```

If `target-dir` is omitted, defaults to the current directory.

## Examples

```bash
# cd into a client repo and init
cd ~/repos/acme-theme
shopify-agency init acme.com acme.myshopify.com https://github.com/acme/theme

# Or specify the target directory
shopify-agency init acme.com acme.myshopify.com https://github.com/acme/theme ~/repos/acme-theme

# Overwrite existing files
shopify-agency init acme.com acme.myshopify.com https://github.com/acme/theme --force
```

## What Gets Generated

Agency config files added alongside your Shopify theme files:

```
├── assets/            ← Shopify theme (from setup.sh)
├── sections/          ← Shopify theme
├── snippets/          ← Shopify theme
├── templates/         ← Shopify theme
├── ...
├── setup.sh           ← Pull theme or start fresh with Dawn
├── docs/              ← Guide, SOPs, architecture decisions
├── tools/             ← seo-audit.sh, reusable prompts
├── seo/               ← SEO audit reports
├── speed/             ← Speed reports
├── cro/               ← CRO experiments
├── CHANGELOG.md
└── .gitignore
```

Shopify CLI ignores the agency files. Existing files are **not overwritten** unless you pass `--force`.

## Full Workflow

```bash
# 1. Clone the client's repo
git clone https://github.com/acme/shopify-theme ~/repos/acme-theme
cd ~/repos/acme-theme

# 2. Generate agency config
shopify-agency init acme.com acme.myshopify.com https://github.com/acme/theme

# 3. Pull existing theme or start fresh with Dawn
./setup.sh

# 4. Fill in client config

# 5. Commit and push
git add -A && git commit -m "feat: add agency config" && git push
```

## Commands

| Command | Description |
|---------|-------------|
| `shopify-agency init` | Generate agency config into a repo |
| `shopify-agency help` | Show help |
| `shopify-agency --version` | Show version |

## Updating the Template

Edit files in `template/`. Files with `.tpl` extension get placeholder substitution:

- `%%CLIENT_DOMAIN%%` — the domain (e.g., `acme-store.com`)
- `%%MYSHOPIFY_URL%%` — the myshopify URL (e.g., `acme-store.myshopify.com`)
- `%%GITHUB_REPO_URL%%` — the GitHub repo URL
- `%%CLIENT_SLUG%%` — derived from domain (e.g., `acme-store`)
- `%%GENERATED_DATE%%` — generation date (YYYY-MM-DD)

Files without `.tpl` are copied as-is.

## License

MIT
