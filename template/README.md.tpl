# %%CLIENT_DOMAIN%% — Shopify Theme Repo

Store: https://%%CLIENT_DOMAIN%%
Admin: https://%%MYSHOPIFY_URL%%/admin
Source: %%GITHUB_REPO_URL%%

## Quick Start

```bash
./setup.sh
```

This will ask you to either:
1. **Pull an existing theme** — lists all themes on the store, you pick by ID
2. **Start fresh with Dawn** — downloads the latest Dawn theme

Theme files are placed at the repo root where Shopify CLI expects them.

After setup:
1. Fill in the Client Config section in `CLAUDE.md`
2. Open Claude Code: `claude`
3. Start working — Claude reads CLAUDE.md automatically

## Run Audits

```bash
# SEO audit (saves to seo/audits/)
./tools/scripts/seo-audit.sh

# Speed — use Lighthouse or PageSpeed Insights, save to speed/reports/
```

## Structure

```
assets/         — Theme CSS, JS, images
sections/       — Theme sections
snippets/       — Reusable Liquid snippets
templates/      — JSON templates
seo/            — SEO audits and JSON-LD schema references
speed/          — Speed reports and optimization docs
cro/            — CRO experiments
tools/          — Scripts and reusable prompts
docs/           — SOPs, architecture decisions, full guide
CLAUDE.md       — Agency standards + client config (Claude reads this)
CHANGELOG.md    — Log of all changes
```

## Skills

Ask Claude to use a specific skill for domain expertise:
- **theme-dev** — Liquid development patterns
- **shopify-apis** — Cart API, Section Rendering, Predictive Search
- **metafields** — Custom data, metaobjects, dynamic sources
- **seo** — Meta tags, structured data, crawlability
- **speed** — Core Web Vitals optimization
- **cro** — Conversion rate, A/B testing, cart UX
- **accessibility** — WCAG 2.1 AA, keyboard nav, screen readers
- **testing** — Cross-browser QA, Theme Check, Lighthouse
- **qa** — Bug verification, root cause analysis, regression checks

See `docs/GUIDE.md` for the full guide.
