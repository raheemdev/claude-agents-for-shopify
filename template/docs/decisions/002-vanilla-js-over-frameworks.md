# ADR 002: Vanilla JS Over Frontend Frameworks

**Date:** 2026-03-10
**Status:** Accepted

## Context

Shopify theme development requires client-side JavaScript for interactive features (quick-add, filtering, cart drawers, etc.). We need a standard approach for how we write JS across all client projects. The options are:

1. **Vanilla JavaScript** (native APIs, web components)
2. **Lightweight libraries** (Alpine.js, Petite Vue, htmx)
3. **Full frameworks** (React, Vue, Svelte) with a bundler

## Decision

We use **vanilla JavaScript and native web components** as our standard. No frameworks, no build step for JS.

## Reasons

**Performance:** Every framework adds bundle size. React + ReactDOM is ~40KB gzipped minimum. Alpine.js is ~15KB. Vanilla JS is 0KB of framework overhead. On Shopify storefronts where every millisecond of Total Blocking Time affects conversion rate, this matters.

**Shopify compatibility:** Shopify themes use server-rendered Liquid. The page is already HTML when it arrives. We need JS to enhance that HTML, not replace it. This is exactly what web components and progressive enhancement are designed for. Frameworks that want to own the DOM fight against Shopify's rendering model.

**No build step:** Shopify themes have no native bundler. Adding Webpack, Vite, or Rollup to the workflow creates complexity: source maps, dev servers, build artifacts in version control, CI/CD pipeline changes. Vanilla JS works directly in Shopify's theme file structure with zero config.

**Dawn alignment:** Dawn uses native web components (`<product-form>`, `<cart-drawer>`, etc.). Our code follows the same patterns, making it easy to extend or override Dawn's built-in components without conflicts.

**Longevity:** Frameworks change every few years. Code written in vanilla JS against stable web APIs (Custom Elements, Intersection Observer, Fetch) will work in 10 years without migration.

## Consequences

**Positive:**
- Zero JS framework overhead in every page load
- No build tooling to maintain, debug, or onboard new developers onto
- Theme code works directly in Shopify's online code editor for quick fixes
- Consistent patterns across all client projects
- No framework version conflicts with Shopify apps (which often bundle their own React)

**Negative:**
- More verbose code for state management and reactivity (no two-way binding, no reactive stores out of the box)
- Developers accustomed to frameworks need to adjust to imperative DOM manipulation
- Some complex UI patterns (multi-step forms, real-time search) require more manual wiring

**Mitigations:**
- Maintain a shared utility library in `shared/assets/` for common patterns (debounce, fetch helpers, event delegation)
- Document common web component patterns in `docs/SOPs/theme-dev.md`
- For genuinely complex interactive features (e.g., custom product builders), evaluate lightweight libraries on a case-by-case basis — but the default is still vanilla JS
