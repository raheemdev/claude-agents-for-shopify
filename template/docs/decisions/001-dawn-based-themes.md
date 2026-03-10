# ADR 001: Standardize on Dawn-Based Themes

**Date:** 2026-03-10
**Status:** Accepted

## Context

When onboarding new clients or rebuilding existing stores, we need to choose a base theme. The options are:

1. **Dawn** (Shopify's free reference theme) or Dawn-based themes
2. **Third-party premium themes** (Turbo, Impulse, Prestige, etc.)
3. **Fully custom themes** built from scratch

Each approach involves tradeoffs in cost, maintainability, performance, and development speed.

## Decision

We standardize on **Dawn-based themes** as our default starting point for all new client projects.

## Reasons

**Performance:** Dawn is built as a performance reference implementation. It ships with minimal CSS/JS, uses native web components, and consistently scores 90+ on Lighthouse out of the box. Third-party themes typically score 60-75 due to feature bloat.

**Maintainability:** Dawn follows Shopify's latest architecture patterns (JSON templates, sections everywhere, web components). When Shopify releases new features or APIs, Dawn is the first to support them. Third-party themes often lag months behind.

**Predictability:** Every developer on the team knows Dawn's codebase. When we inherit a project or hand one off, there is no learning curve for the base theme. With third-party themes, each has its own patterns, naming conventions, and quirks.

**Cost:** Dawn is free. Premium themes cost $300-$400 and still require heavy customization. The customization cost is roughly the same either way, so the theme license fee is pure overhead.

**Flexibility:** Starting lean and adding only what the client needs produces a cleaner, faster result than starting heavy and trying to remove what they don't need.

## Consequences

**Positive:**
- Consistent developer experience across all client projects
- Better baseline performance scores
- Faster onboarding for new team members
- Easier to keep themes updated with Shopify platform changes

**Negative:**
- More upfront development time for features that come built-in with premium themes (mega menus, advanced filtering, quick-buy drawers)
- Clients may initially perceive a "free theme" as lower quality — requires clear communication about customization
- We maintain our own shared snippet/section library to compensate (see `shared/` directory)

**Exceptions:**
- If a client has an existing premium theme in good condition and the scope is small edits, we work with what they have
- If a client's requirements are exceptionally complex (e.g., multi-storefront with heavy customization), evaluate on a case-by-case basis
