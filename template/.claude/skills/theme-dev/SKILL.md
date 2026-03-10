# Shopify Liquid Theme Development

## Purpose
Guide Liquid theme development following Shopify best practices, Dawn compatibility, and maintainable architecture.

## When to Use
Invoke when creating or modifying Liquid templates, sections, snippets, or theme assets.

## Naming Conventions
- Sections: `section-*.liquid` (e.g., `section-featured-collection.liquid`)
- Snippets: `snippet-*.liquid` (e.g., `snippet-product-card.liquid`)
- Templates: use JSON templates (`templates/*.json`), not `.liquid` templates
- Assets: prefix with purpose — `component-*.css`, `section-*.css`, `global-*.js`

## Section Schema Standards
- Every section MUST have a `{% schema %}` block with `name`, `settings`, and `presets`
- Use `presets` to make sections available in the theme editor
- Define `blocks` for repeatable content (slides, testimonials, features)
- Settings types to prefer: `image_picker`, `richtext`, `url`, `collection`, `product`
- Always provide sensible `default` values for settings
- Group related settings with `"type": "header"` dividers
- Limit sections to 16 blocks max for editor performance

## Rendering Rules
- ALWAYS use `{% render 'snippet-name' %}` — NEVER use `{% include %}`
- Pass variables explicitly: `{% render 'snippet-card', product: item, show_price: true %}`
- Rendered snippets have isolated scope — they cannot access parent variables
- Use `{% liquid %}` tag for multi-line logic to reduce whitespace

## JSON Template Architecture
- Templates in `templates/*.json` reference ordered section arrays
- Each section entry maps to a file in `sections/`
- Use `"order"` array to control section rendering sequence
- Keep template JSON minimal — push logic into sections and snippets

## Dawn Compatibility
- Extend Dawn patterns, do not override core Dawn sections unless necessary
- Maintain compatibility with `main-*.liquid` section naming for template defaults
- Respect Dawn's CSS custom property system (`--font-body`, `--color-base`, etc.)
- Use Dawn's `media-gallery` and `product-form` patterns as baseline

## Asset Pipeline
- CSS: use separate files per section/component, loaded via `{{ 'file.css' | asset_url | stylesheet_tag }}`
- JS: defer non-critical scripts — `<script src="{{ 'file.js' | asset_url }}" defer></script>`
- Avoid inline `<style>` blocks except for critical above-fold styles
- Use `asset_url` filter for all theme assets, `file_url` for uploaded files

## Responsive Image Handling
- Use `{{ image | image_url: width: 800 }}` with Shopify's CDN sizing
- Prefer `image_tag` filter: `{{ image | image_url: width: 1200 | image_tag: loading: 'lazy', widths: '300,600,900,1200' }}`
- Always set `loading: 'lazy'` for below-fold images, `loading: 'eager'` for hero/LCP
- Provide `sizes` attribute matching your CSS breakpoints
- Use `srcset` with widths at 300, 600, 900, 1200, 1800 for responsive delivery

## Common Pitfalls
- Do not nest `forloop` inside `forloop` — extract inner loops to snippets
- Avoid `{% if %}` chains longer than 3 conditions — use `{% case %}` instead
- Never hardcode URLs — use `{{ routes.root_url }}`, `{{ routes.cart_url }}`, etc.
- Do not access `content_for_header` or `content_for_layout` inside sections
- Test with the theme editor open — ensure sections are configurable without code changes
