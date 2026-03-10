# shopify-agency-cli

This repo is a **CLI tool**, not a working Shopify theme. It generates agency config into client repos.

## How It Works

Run `shopify-agency init <domain> <myshopify> <github-url>` from any client repo to generate agency config files.

## Structure

```
bin/shopify-agency  — CLI entry point
template/           — Everything in here gets copied into the target repo
  *.tpl files       — Processed with sed (%%PLACEHOLDER%% substitution), then renamed
  all other files   — Copied as-is
package.json        — npm package config (bin field for global install)
```

## Editing the Template

- Files that need placeholder substitution use `.tpl` extension
- Placeholders use `%%DOUBLE_PERCENT%%` syntax to avoid Liquid `{{ }}` collisions
- Available placeholders: `%%CLIENT_DOMAIN%%`, `%%MYSHOPIFY_URL%%`, `%%GITHUB_REPO_URL%%`, `%%CLIENT_SLUG%%`, `%%GENERATED_DATE%%`
- Skills in `template/.claude/skills/` are copied directly — no placeholders needed

## Rules

- Test after changes: `./bin/shopify-agency init test.com test.myshopify.com https://github.com/test/repo /tmp/test`
- Never use `{{ }}` for generator placeholders — that's Liquid syntax
