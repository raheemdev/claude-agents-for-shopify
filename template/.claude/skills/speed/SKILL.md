# Shopify Performance Optimization

## Purpose
Maximize store speed by targeting Core Web Vitals and Shopify-specific performance patterns.

## When to Use
Invoke when building new features, auditing page speed, optimizing assets, or troubleshooting slow pages.

## Core Web Vitals Targets
- **LCP (Largest Contentful Paint):** < 2.5 seconds
- **CLS (Cumulative Layout Shift):** < 0.1
- **INP (Interaction to Next Paint):** < 200 milliseconds
- Measure with Lighthouse, PageSpeed Insights, and Chrome UX Report (CrUX) field data
- Prioritize field data (real users) over lab data (simulated)

## Image Optimization
- Serve WebP format — Shopify CDN converts automatically when using `image_url` filter
- Always specify dimensions: `{{ image | image_url: width: 800 | image_tag: width: 800, height: 600 }}`
- Set explicit `width` and `height` attributes on all `<img>` tags to prevent CLS
- Lazy load below-fold images: `loading: 'lazy'`
- Eager load the LCP image (hero/banner): `loading: 'eager'`, `fetchpriority: 'high'`
- Use responsive `srcset` with widths: `300, 600, 900, 1200, 1800`
- Set `sizes` attribute to match CSS layout breakpoints
- Avoid oversized images — never serve a 2000px image in a 400px container

## Font Loading Strategy
- Use `font-display: swap` on all `@font-face` declarations to prevent FOIT
- Preload critical fonts: `<link rel="preload" href="{{ font | font_url }}" as="font" type="font/woff2" crossorigin>`
- Limit to 2-3 font files maximum (1 body, 1 heading, optional accent)
- Use `font_url` filter with `woff2` format for smallest file size
- Consider system font stacks for body text to eliminate font loading entirely

## Critical CSS
- Inline above-fold critical CSS in `<style>` tags within `<head>`
- Load remaining CSS asynchronously: `<link rel="preload" href="..." as="style" onload="this.rel='stylesheet'">`
- Keep inlined CSS under 14KB (fits in first TCP roundtrip)
- Avoid render-blocking `<link rel="stylesheet">` tags for non-critical CSS

## JavaScript Optimization
- Defer all non-critical JS: `<script src="..." defer></script>`
- Never use `document.write()` — it blocks the parser
- Use `type="module"` for modern JS with automatic defer behavior
- Split large bundles — load section-specific JS only on pages that need it
- Move analytics and tracking scripts to `requestIdleCallback` or after `load` event
- Avoid synchronous `<script>` tags in `<head>` — they block rendering

## Third-Party Script Management
- Audit all third-party scripts quarterly — remove unused apps and their residual code
- Load non-essential third-party scripts after page load: `window.addEventListener('load', ...)`
- Use `async` for analytics scripts that do not depend on DOM
- Set `dns-prefetch` and `preconnect` for known third-party origins
- Watch for apps injecting synchronous scripts via ScriptTag API — these kill performance

## Shopify-Specific Liquid Performance
- NEVER nest `forloop` inside `forloop` — extract inner loop to a rendered snippet
- Limit collection loops: `{% for product in collection.products limit: 12 %}` — never load all products
- Cache repeated Liquid lookups in variables: `{% assign featured = collections['featured'] %}`
- Avoid `| json` filter on large objects — serialize only needed fields
- Minimize use of `content_for_header` manipulations — it adds render overhead
- Use `{% render %}` over `{% include %}` — render has better caching

## Resource Hints
- `<link rel="preconnect" href="https://cdn.shopify.com">` — always include
- `<link rel="preconnect" href="https://fonts.shopifycdn.com" crossorigin>` — if using Shopify fonts
- `<link rel="dns-prefetch" href="https://productreviews.shopifycdn.com">` — for review apps
- Prefetch next likely page: `<link rel="prefetch" href="{{ routes.cart_url }}">` on product pages
- Do not over-prefetch — limit to 2-3 high-probability navigation targets

## CLS Prevention Checklist
- Set explicit `width` and `height` on all images and videos
- Reserve space for dynamic content (reviews, app blocks) with `min-height`
- Avoid injecting content above existing content after page load
- Use `transform` animations instead of layout-triggering properties (`top`, `height`, `margin`)
- Ensure web fonts have fallback metrics matching the custom font dimensions
