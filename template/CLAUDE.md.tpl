# CLAUDE.md — %%CLIENT_DOMAIN%%

## Store
- Domain: %%CLIENT_DOMAIN%%
- Shopify Admin: %%MYSHOPIFY_URL%%
- Repo: %%GITHUB_REPO_URL%%

## Stack
- Shopify Online Store 2.0, Dawn-based themes, Liquid, JSON templates
- Tailwind CSS where applicable, vanilla JS, no frameworks

## Repo Structure
```
assets/         — Theme CSS, JS, images
config/         — Theme settings (settings_schema.json, settings_data.json)
layout/         — theme.liquid and other layouts
locales/        — Translation files
sections/       — Theme sections with {% schema %}
snippets/       — Reusable Liquid snippets
templates/      — JSON templates (OS 2.0)
seo/            — SEO audits and schema references
speed/          — Speed reports and image pipeline docs
cro/            — CRO experiments
tools/scripts/  — seo-audit.sh
tools/prompts/  — Reusable analysis prompts
docs/           — SOPs, decisions, guide
```

## Rules (Non-Negotiable)
1. Never push to production without a CHANGELOG.md entry
2. Preserve existing theme customizations — read before editing
3. No direct commits to main — feature branches + PRs
4. Test on preview theme before going live

## Theme Architecture
- Sections with `{% schema %}`, sensible defaults, presets
- Blocks for repeatable content
- Snippets: use `{% render %}`, never `{% include %}`
- JSON templates only (OS 2.0)
- Assets minified, no unminified vendor bundles

## Performance Targets
| Metric | Target |
|--------|--------|
| LCP    | < 2.5s |
| CLS    | < 0.1  |
| INP    | < 200ms |

- Lazy load below fold, eager load hero with `fetchpriority="high"`
- Defer non-critical JS, use `type="module"`
- Limit third-party scripts
- Keep Liquid render time < 200ms

## Accessibility
- Semantic HTML, keyboard accessible, alt on all images
- WCAG 2.1 AA color contrast (4.5:1 text, 3:1 large)
- Labels on form inputs, aria only when native semantics insufficient

## SEO
- Unique title + meta description per page
- JSON-LD structured data (Product, BreadcrumbList, Organization, FAQ)
- Canonical URLs on all pages
- One H1 per page, logical heading hierarchy

## Skills
| Skill         | Use for |
|---------------|---------|
| theme-dev     | Sections, templates, snippets, Liquid patterns |
| shopify-apis  | Cart API, Section Rendering, Predictive Search, Recommendations |
| metafields    | Custom data, metaobjects, dynamic sources, theme editor integration |
| seo           | Structured data, meta tags, crawl optimization |
| speed         | Core Web Vitals, image/font/JS optimization |
| cro           | Conversion experiments, AOV, cart/checkout UX |
| accessibility | WCAG 2.1 AA compliance, keyboard nav, screen readers, ARIA |
| testing       | Cross-browser QA, Theme Check, Lighthouse, PR review checklist |
| qa            | Bug verification, root cause analysis, regression checks |

## Commits
Format: `type: description` (e.g., `feat: add size guide modal`, `fix: resolve CLS on collection page`)
PRs must include: what changed, why, preview theme link, screenshots.

## Client Config
Fill these in after generating:
- Brand voice:
- Primary color:
- Typography:
- Key apps (email, reviews, loyalty):
- Special rules:

## When In Doubt
1. Read the theme's existing patterns before introducing new ones
2. Measure before and after (performance, accessibility, conversion)
3. If a change isn't reversible, get explicit approval
