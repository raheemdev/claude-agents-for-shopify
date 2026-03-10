# Shopify Store — Complete Guide

This is a detailed guide for using this Shopify store repo with Claude Code. It covers setup, daily workflows, skills, reusable assets, and best practices.

---

## Table of Contents

1. [What This Repo Is](#1-what-this-repo-is)
2. [Prerequisites](#2-prerequisites)
3. [Repo Structure Explained](#3-repo-structure-explained)
4. [Initial Setup](#4-initial-setup)
5. [Working with Skills](#5-working-with-skills)
6. [Daily Workflow](#6-daily-workflow)
7. [Using Reusable Assets](#7-using-reusable-assets)
8. [Running Audits](#8-running-audits)
9. [Safety Hooks](#9-safety-hooks)
10. [Reusable Prompt Templates](#10-reusable-prompt-templates)
11. [SOPs and Decision Records](#11-sops-and-decision-records)
12. [Tips and Best Practices](#12-tips-and-best-practices)

---

## 1. What This Repo Is

This is a **single-store Shopify repo** that manages one client's store. It provides:

- A standardized structure for the store (theme, SEO, speed, CRO)
- Claude Code skills that encode domain expertise (Liquid development, SEO, performance, conversion optimization, product drops)
- Reusable components, snippets, and schemas ready to use in the theme
- Automation scripts for running audits
- Safety hooks that prevent common mistakes (missing changelogs, missing config)
- SOPs and architectural decision records for consistency

**The core idea:** When you open Claude Code in this repo, it automatically reads `CLAUDE.md` and understands this store's brand, stack, and conventions. The skills give Claude deep domain knowledge for each service area.

---

## 2. Prerequisites

Before using this repo, ensure you have:

- **Git** — version control
- **Shopify CLI** — `npm install -g @shopify/cli` (for theme development)
- **Claude Code** — Anthropic's CLI tool
- **Node.js** (18+) — for running Lighthouse and other tools
- **Lighthouse CLI** (optional) — `npm install -g lighthouse` (for SEO/speed audits)
- **jq** (optional) — for parsing JSON audit results (`brew install jq` on macOS)

---

## 3. Repo Structure Explained

```
%%CLIENT_SLUG%%/
│
├── CLAUDE.md                        # Store config + standards (Claude reads this first)
├── CHANGELOG.md                     # All changes logged here
│
├── .claude/
│   ├── settings.json                # Auto-approved safe operations
│   ├── hooks/                       # Safety guardrails
│   │   └── audit-guard.sh            # Checks CLAUDE.md exists and is configured
│   └── skills/                      # Domain expertise for Claude
│       ├── theme-dev/SKILL.md       # Liquid, sections, schema, Dawn patterns
│       ├── shopify-apis/SKILL.md    # Cart API, Section Rendering, Search
│       ├── metafields/SKILL.md      # Custom data, metaobjects, dynamic sources
│       ├── seo/SKILL.md             # Meta tags, JSON-LD, crawlability
│       ├── speed/SKILL.md           # Core Web Vitals, image/font/JS optimization
│       ├── cro/SKILL.md             # Conversion, AOV, A/B testing, cart UX
│       ├── accessibility/SKILL.md   # WCAG 2.1 AA, keyboard nav, ARIA
│       ├── testing/SKILL.md         # Cross-browser QA, Lighthouse, Theme Check
│       └── qa/SKILL.md             # Bug verification, root cause, regression
│
├── assets/                          # Theme CSS, JS, images, fonts
├── config/                          # Theme settings
├── layout/                          # Theme layouts
├── locales/                         # Translation files
├── sections/                        # Theme sections
├── snippets/                        # Reusable Liquid snippets
├── templates/                       # Page templates (JSON)
│
├── seo/                             # SEO audits, reports, notes
├── speed/                           # Speed reports, optimization notes
├── cro/                             # CRO experiments, results
│
├── tools/
│   ├── scripts/                     # Automation scripts
│   │   └── seo-audit.sh             # Run Lighthouse SEO audit
│   └── prompts/                     # Reusable prompt templates
│       ├── cro-review.md            # CRO audit prompt
│       └── speed-analysis.md        # Lighthouse analysis prompt
│
└── docs/
    ├── GUIDE.md                     # This file
    ├── SOPs/                        # Standard operating procedures
    │   ├── theme-dev.md
    │   ├── seo.md
    │   ├── speed.md
    │   └── cro.md
    └── decisions/                   # Architecture decision records
        ├── 001-dawn-based-themes.md
        └── 002-vanilla-js-over-frameworks.md
```

### How CLAUDE.md Works

Claude Code reads `CLAUDE.md` files hierarchically:

1. **Root `CLAUDE.md`** — always loaded. Contains store info, brand guidelines, technical stack, and standards that apply to all work.
2. **Subdirectory CLAUDE.md files** (e.g., `seo/CLAUDE.md`) — loaded when you're working in a specific area. Use these for deeper context about specific work areas.

Subdirectory-level rules **override** root-level rules when they conflict.

---

## 4. Initial Setup

### Clone and configure

```bash
# Clone the repo
git clone <your-repo-url> %%CLIENT_SLUG%%
cd %%CLIENT_SLUG%%

# Make scripts executable
chmod +x tools/scripts/*.sh
chmod +x .claude/hooks/*.sh
```

### Configure store URL

Create a `.env` file at the repo root with the store's Shopify URL:

```bash
# .env
SHOPIFY_STORE=%%MYSHOPIFY_URL%%
```

**Important:** The `.env` file is in `.gitignore` to avoid committing credentials.

### Verify setup

```bash
# Open Claude Code in the repo
claude

# Claude will automatically read CLAUDE.md and understand:
# - Your store (%%CLIENT_DOMAIN%%, brand, plan)
# - Your stack (Shopify, Dawn, Liquid, Tailwind, vanilla JS)
# - Your standards (accessibility, performance targets, commit format)
# - Available skills and tools
```

---

## 5. Working with Skills

Skills are domain expertise files that Claude loads when you invoke them. They live in `.claude/skills/` and contain best practices, patterns, and rules.

### Available Skills

#### theme-dev
**Use for:** Building or modifying Liquid sections, templates, snippets, assets.

Key rules it enforces:
- Naming: `section-*.liquid`, `snippet-*.liquid`
- Always `{% render %}`, never `{% include %}`
- JSON templates only (Online Store 2.0)
- Schema must include `name`, `settings`, `presets` with sensible defaults
- Dawn compatibility patterns
- Responsive images via `image_tag` with `srcset`

**Example prompts:**
```
"Build a testimonials section with a slider, following the theme-dev skill"
"Create a reusable product card snippet"
"Add a new collection template with filtering"
```

#### shopify-apis
**Use for:** Dynamic, client-side features — cart operations, live search, section updates without page reloads.

Key rules it enforces:
- Cart API: `/cart/add.js`, `/cart/change.js`, `/cart.js` with proper error handling
- Section Rendering API for updating cart drawers and product info on variant change
- Predictive Search with debounce and AbortController
- Product Recommendations API for upsells/cross-sells
- Custom events (`cart:updated`, `variant:changed`) for component communication
- Loading states and error handling on all async operations

**Example prompts:**
```
"Build an AJAX add-to-cart that updates the cart drawer using the shopify-apis skill"
"Add predictive search to the header"
"Update the product price and image when a variant is selected without page reload"
```

#### metafields
**Use for:** Custom data, metaobjects, and connecting dynamic content to the theme editor.

Key rules it enforces:
- Correct Liquid access: `resource.metafields.namespace.key.value`
- Type-appropriate rendering (rich text via `metafield_tag`, files via `image_url`)
- Dynamic sources in section schemas for theme editor integration
- Metaobjects for reusable content types (FAQs, team members, store locations)
- Namespace conventions (`custom`, `product`, `seo`, `sizing`, `shipping`, `brand`)
- List types iterated with `{% for %}`, never output directly

**Example prompts:**
```
"Add a product subtitle metafield and display it on the product page"
"Create a FAQ section powered by metaobjects"
"Connect a custom badge metafield to the product card as a dynamic source"
```

#### seo
**Use for:** Meta tags, structured data, crawlability, search visibility.

Key rules it enforces:
- Unique `<title>` and `<meta description>` per page type
- JSON-LD structured data (Product, BreadcrumbList, Organization, FAQ, Article)
- Canonical URL on every page
- Image alt text on every `<img>`
- `rel="next"/"prev"` for paginated pages
- Never block CSS/JS in robots.txt

**Example prompts:**
```
"Add Product JSON-LD to the product template following the seo skill"
"Audit the collection page meta tags"
"Fix the breadcrumb structured data"
```

#### speed
**Use for:** Performance optimization, Core Web Vitals fixes.

Key rules it enforces:
- LCP < 2.5s, CLS < 0.1, INP < 200ms
- Lazy load below-fold, eager load hero/LCP image with `fetchpriority: 'high'`
- `font-display: swap`, max 2-3 font files
- Defer non-critical JS, use `type="module"`
- No nested `forloop` in Liquid
- Resource hints (`preconnect`, `dns-prefetch`)
- Critical CSS under 14KB inlined

**Example prompts:**
```
"Optimize the homepage LCP using the speed skill"
"Audit third-party scripts for performance impact"
"Fix CLS on the collection page — images are shifting"
```

#### cro
**Use for:** Conversion rate optimization, A/B testing, cart/checkout UX.

Key rules it enforces:
- A/B test framework: hypothesis, metric, sample size, 95% significance
- AOV tactics: bundles, tiered discounts, free shipping progress bar
- Trust signals near the Add to Cart button
- Mobile-first: sticky ATC, 44x44px tap targets, bottom-sheet cart
- Ethical urgency only (real stock levels, genuine deadlines)
- Product page must-haves (images, reviews, size guide, recommendations)

**Example prompts:**
```
"Review the product page for CRO improvements using the cro skill"
"Build a free shipping progress bar for the cart drawer"
"Design an A/B test for the Add to Cart button color"
```

#### accessibility
**Use for:** WCAG 2.1 AA compliance, keyboard navigation, screen reader support, ARIA patterns.

Key rules it enforces:
- Semantic HTML (`<button>` not `<div onclick>`, `<nav>`, `<main>`)
- Keyboard navigation: visible focus, tab order, focus trapping in modals/drawers
- Images: descriptive `alt` text, `alt=""` for decorative
- Forms: `<label>` on every input, `aria-describedby` for errors
- Color contrast: 4.5:1 text, 3:1 large text and UI components
- ARIA: only when native HTML can't achieve the semantics
- Shopify-specific: product swatches, cart drawer, mega menu, announcement bar

**Example prompts:**
```
"Audit the product page for accessibility issues using the accessibility skill"
"Make the cart drawer keyboard accessible with focus trapping"
"Fix the variant selector to work with screen readers"
```

#### testing
**Use for:** QA, cross-browser testing, Theme Check linting, Lighthouse, and PR review.

Key rules it enforces:
- Theme Check linting before every PR (zero errors)
- Cross-browser testing matrix (Chrome, Safari, Firefox, mobile Safari, mobile Chrome)
- Device testing at key breakpoints (375px, 428px, 768px, 1024px, 1280px, 1920px)
- Lighthouse performance/accessibility scores with before/after methodology
- Functional testing checklists per page type (PDP, collection, cart, search, nav)
- PR review checklist: code quality, accessibility, performance, completeness

**Example prompts:**
```
"Review this PR using the testing skill checklist"
"Run through the product page functional testing checklist"
"What cross-browser issues should I check for with this CSS?"
```

#### qa
**Use for:** Bug fixing, root cause analysis, and verifying that issues are properly resolved.

Key rules it enforces:
- Always reproduce before fixing — never guess
- Identify root cause, don't just fix symptoms
- Smallest possible change in the fix — no refactoring alongside bug fixes
- Verify on same conditions as the report (device, browser, viewport, data)
- Regression check: related features still work, no new console errors
- Cross-device verification after every fix
- Edge case testing: empty states, max states, rapid interaction, slow connection
- Bug fix PR template with reproduction steps and verification checklist

**Example prompts:**
```
"Fix this cart bug using the qa skill — items show wrong quantity after rapid clicking"
"Verify this fix doesn't break anything else on the product page"
"Help me find the root cause of this layout shift on mobile Safari"
```

### Combining Skills

You can reference multiple skills in a single prompt:

```
"Build a new product section using theme-dev patterns, with JSON-LD from the seo
skill, optimized images per the speed skill, and trust signals from the cro skill"
```

---

## 6. Daily Workflow

### Starting work

```bash
cd %%CLIENT_SLUG%%

# Create a feature branch
git checkout -b feat/add-size-guide

# Open Claude Code
claude
```

Claude will read the root `CLAUDE.md` which contains all store info, brand guidelines, and standards.

### Typical task flow

1. **Tell Claude what you need:**
   ```
   "Build a size guide modal that appears when clicking
   'Size Guide' on the product page. Use the theme-dev skill."
   ```

2. **Claude will:**
   - Read CLAUDE.md for brand/theme context
   - Follow the theme-dev skill's Liquid patterns
   - Create properly named files (`section-size-guide.liquid`, `snippet-size-guide-modal.liquid`)
   - Use the store's color scheme and typography
   - Follow accessibility standards from CLAUDE.md

3. **Review the changes, then log them:**
   ```
   "Add a changelog entry for this size guide feature"
   ```

4. **Commit and push:**
   ```
   "Commit these changes following the commit format"
   ```
   Claude will use: `feat: add size guide modal to product page`

5. **Create a PR:**
   ```
   "Create a PR for this feature"
   ```

### Branch naming convention

```
feat/description     — new features
fix/description      — bug fixes
perf/description     — performance improvements
seo/description      — SEO work
cro/description      — CRO experiments
```

### Commit message format

```
type: description

feat: add size guide modal to product page
fix: resolve CLS on collection page hero image
perf: lazy load below-fold product images
seo: add Product JSON-LD to product template
cro: implement free shipping progress bar in cart
```

---

## 7. Using Reusable Assets

The `snippets/` and `assets/` directories at the repo root contain reusable Liquid and asset code.

### Liquid Snippets

#### Responsive Image (`snippets/snippet-image-responsive.liquid`)

Renders an `<img>` with automatic srcset at 200/400/600/800/1000 widths, lazy loading by default, and explicit width/height for CLS prevention.

**Usage:**
```liquid
{% render 'snippet-image-responsive',
  image: product.featured_image,
  sizes: '(min-width: 768px) 50vw, 100vw',
  class: 'product-image'
%}

{%- comment -%} Eager load for hero/LCP images {%- endcomment -%}
{% render 'snippet-image-responsive',
  image: section.settings.hero_image,
  lazy: false,
  sizes: '100vw'
%}
```

#### Product JSON-LD (`snippets/snippet-json-ld-product.liquid`)

Outputs complete Product schema.org markup including offers, brand, SKU, images, compare-at pricing, and aggregateRating.

**Add to product template:**
```liquid
{% render 'snippet-json-ld-product', product: product %}
```

#### Breadcrumb JSON-LD (`snippets/snippet-json-ld-breadcrumb.liquid`)

Dynamic BreadcrumbList schema that adapts to the current page type.

**Add to theme.liquid or a layout snippet:**
```liquid
{% render 'snippet-json-ld-breadcrumb' %}
```

### JavaScript Components

#### Sticky Add-to-Cart (`assets/sticky-cart.js` + `sticky-cart.css`)

A custom element that shows a fixed bar at the bottom of the screen when the user scrolls past the main Add to Cart button. Uses IntersectionObserver (no scroll listeners).

**Add to product template:**
```html
<!-- Mark the main ATC button -->
<div id="main-atc-button">
  <button type="submit" form="product-form">Add to Cart</button>
</div>

<!-- Add the sticky bar -->
<sticky-cart
  product-title="{{ product.title }}"
  product-price="{{ product.price | money }}"
  product-image="{{ product.featured_image | image_url: width: 96 }}"
  form-id="product-form">
</sticky-cart>

<!-- Load the assets -->
{{ 'sticky-cart.css' | asset_url | stylesheet_tag }}
<script src="{{ 'sticky-cart.js' | asset_url }}" type="module"></script>
```

#### Upsell Widget (`assets/upsell-widget.js`)

Fetches product recommendations from Shopify's Recommendations API and renders product cards with quick-add. Designed for cart drawers.

**Add to cart drawer:**
```html
<upsell-widget
  product-id="{{ cart.items.first.product_id }}"
  limit="4"
  heading="Complete your order">
</upsell-widget>

<script src="{{ 'upsell-widget.js' | asset_url }}" type="module"></script>
```

**Listen for events:**
```javascript
document.addEventListener('upsell-widget:added', (e) => {
  // Refresh cart drawer after upsell add
  refreshCart();
});
```

### SEO Schema Templates

JSON-LD templates in `seo/schemas/` provide reference structures for:
- `product.json` — Product with offers, reviews, shipping
- `faq.json` — FAQPage with question/answer pairs
- `breadcrumb.json` — BreadcrumbList hierarchy

Use these as reference when building Liquid snippets or for validation.

---

## 8. Running Audits

### SEO Audit

```bash
./tools/scripts/seo-audit.sh
```

This runs Lighthouse with the SEO category against %%CLIENT_DOMAIN%% and saves JSON + HTML reports to `seo/audits/` with a timestamp. It also displays the SEO score and any failed checks.

**Requirements:** `lighthouse` CLI and Google Chrome installed.

### Speed Audit

There's no automated speed script (speed audits benefit from manual analysis), but you can:

1. Run Lighthouse manually:
   ```bash
   lighthouse https://%%CLIENT_DOMAIN%% --only-categories=performance --output=json --output-path=speed/reports/speed-$(date +%Y%m%d).json
   ```

2. Use the speed analysis prompt template:
   ```
   "Read tools/prompts/speed-analysis.md and use it to analyze
   speed/reports/speed-20260310.json"
   ```

3. Update the speed notes with new baseline scores.

### CRO Audit

Use the CRO review prompt template:
```
"Read tools/prompts/cro-review.md and use it to review the
product page at https://%%CLIENT_DOMAIN%%/products/example-product"
```

This walks through a structured review: homepage, collections, PDP, cart/checkout, mobile, trust signals, and urgency elements.

---

## 9. Safety Hooks

The hooks in `.claude/hooks/` act as guardrails to prevent common mistakes.

---

## 10. Reusable Prompt Templates

The `tools/prompts/` directory contains structured prompts you can feed to Claude for consistent, thorough analyses.

### CRO Review (`tools/prompts/cro-review.md`)

A structured audit covering 7 areas:
1. Homepage — hero, navigation, featured products
2. Collection pages — filtering, sorting, product cards
3. Product pages — images, ATC, trust signals, descriptions
4. Cart & checkout — friction points, upsells, payment options
5. Mobile experience — tap targets, scroll depth, speed
6. Trust signals — reviews, guarantees, security badges
7. Urgency elements — stock levels, shipping deadlines

**Usage:**
```
"Read tools/prompts/cro-review.md and apply it to the store"
```

### Speed Analysis (`tools/prompts/speed-analysis.md`)

A structured analysis of Lighthouse JSON covering:
- Summary scores for all Core Web Vitals
- LCP breakdown (what's the largest element, what's slow)
- CLS sources (which elements shift)
- INP contributors (which interactions are slow)
- Render-blocking resources
- Image optimization opportunities
- Third-party script impact
- Prioritized recommendations

**Usage:**
```
"Read tools/prompts/speed-analysis.md and analyze this Lighthouse report:
speed/reports/speed-20260310.json"
```

---

## 11. SOPs and Decision Records

### Standard Operating Procedures (`docs/SOPs/`)

| SOP | Covers |
|---|---|
| `theme-dev.md` | Git flow, naming conventions, testing checklist, rollback procedure |
| `seo.md` | On-page checklist, audit cadence, keyword tracking, technical SEO checks |
| `speed.md` | Core Web Vitals targets, measurement process, optimization priority, before/after methodology |
| `cro.md` | Experiment framework, sample size requirements, 95% significance threshold, sign-off process |

Reference these when you need the full process for a work type. Claude can also read them:
```
"Read docs/SOPs/theme-dev.md and follow the deployment process"
```

### Architecture Decision Records (`docs/decisions/`)

| ADR | Decision |
|---|---|
| `001-dawn-based-themes.md` | Why we standardize on Dawn — performance, maintainability, Shopify alignment |
| `002-vanilla-js-over-frameworks.md` | Why vanilla JS over React/Vue — zero overhead, no build step, longevity |

Add new ADRs when making significant architectural choices:
```
docs/decisions/003-why-we-chose-x.md
```

---

## 12. Tips and Best Practices

### Working with Claude Code effectively

1. **Reference skills by name.** Say "using the speed skill" or "following the cro skill" to activate domain expertise.

2. **Let Claude read files first.** If you ask Claude to modify something, it will read the existing code to understand patterns before changing anything.

3. **Use the commit format.** Claude knows the convention: `type: description`.

4. **Ask for audits before changes.** "Audit the product page speed before I optimize it" gives you a baseline.

### Keeping things clean

- Update CLAUDE.md when things change (new apps, new theme version, new rules)
- Archive old audit reports rather than deleting them
- Log every change in the changelog — your future self will thank you
- Add ADRs for decisions so the team doesn't re-debate them

### When something goes wrong

1. **Theme looks broken after push?** Roll back to the previous theme version in Shopify admin
3. **Claude not following store rules?** Make sure the CLAUDE.md is up to date with the latest store info and conventions
4. **Reusable component not working?** Check that the snippet or asset is in the correct `snippets/` or `assets/` directory and loaded with the correct tags

### Adding new skills

To create a new skill (e.g., `email-marketing`):

1. Create the directory: `mkdir -p .claude/skills/email-marketing`
2. Write the SKILL.md with: Purpose, When to Use, Rules, Patterns
3. Add it to the Skills Reference table in the root CLAUDE.md
4. Commit and share with the team

### Adding new reusable components

1. Build and test the component in the theme first
2. Once proven, extract to `snippets/` or `assets/`
3. Make it generic — use parameters, not hardcoded values
4. Document usage in a comment block at the top of the file
5. Keep a clean separation between store-specific and reusable code
