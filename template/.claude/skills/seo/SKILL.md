# Shopify SEO Optimization

## Purpose
Ensure every page follows SEO best practices for discoverability, structured data, and crawlability.

## When to Use
Invoke when building or modifying templates, adjusting meta tags, adding structured data, or troubleshooting search visibility.

## Meta Title and Description Templates
- **Homepage:** `{{ shop.name }} — {{ shop.description | truncate: 120 }}`
- **Product:** `{{ product.title }} | {{ shop.name }}` — description from `product.metafields.global.description_tag` or first 155 chars of `product.description`
- **Collection:** `{{ collection.title }} | {{ shop.name }}` — description from `collection.metafields.global.description_tag`
- **Blog post:** `{{ article.title }} | {{ blog.title }}` — description from `article.metafields.global.description_tag` or `article.excerpt`
- **Page:** `{{ page.title }} | {{ shop.name }}`
- Keep titles under 60 characters, descriptions under 155 characters
- Every page MUST have a unique `<title>` and `<meta name="description">`

## JSON-LD Structured Data
Embed in `<script type="application/ld+json">` — never use microdata attributes.

### Required schemas by page type:
- **Product pages:** `Product` schema with `name`, `image`, `description`, `sku`, `offers` (price, availability, currency), `brand`, `aggregateRating` if reviews exist
- **Collection pages:** `CollectionPage` with `name` and `description`
- **All pages:** `BreadcrumbList` with proper hierarchy (Home > Collection > Product)
- **Homepage:** `Organization` with `name`, `url`, `logo`, `sameAs` (social links)
- **FAQ pages:** `FAQPage` with `mainEntity` array of `Question`/`Answer` pairs
- **Blog posts:** `Article` with `headline`, `author`, `datePublished`, `image`

### Validation rules:
- Always use `@context: "https://schema.org"`
- Prices must include `priceCurrency` in ISO 4217 format
- Test output at https://search.google.com/test/rich-results

## Canonical URL Handling
- Every page MUST include `<link rel="canonical" href="{{ canonical_url }}">`
- Place in `<head>` via `theme.liquid` or a dedicated snippet
- Paginated pages: canonical should point to the first page of the set
- Variant URLs: canonical should point to the base product URL without variant params

## Robots.txt and Sitemap
- Shopify auto-generates `/robots.txt` and `/sitemap.xml` — do not try to create static files
- Use the `robots.txt.liquid` template to customize rules
- Never block CSS or JS resources in robots.txt — search engines need them for rendering
- Ensure all important collections and products are crawlable
- Add `noindex` meta tag (not robots.txt) for pages you want excluded from search

## Internal Linking
- Every product should link back to its primary collection via breadcrumbs
- Collection pages should link to subcollections where applicable
- Use descriptive anchor text — never "click here"
- Footer and header navigation should cover all top-level collections
- Blog posts should link to relevant products and collections

## Image SEO
- Every `<img>` MUST have a descriptive `alt` attribute
- Use product/collection title as fallback: `alt="{{ image.alt | escape | default: product.title }}"`
- File names should be descriptive before upload (Shopify preserves them in CDN URLs)
- Do not stuff keywords into alt text — describe the image accurately

## Pagination
- Use `rel="next"` and `rel="prev"` on paginated collection and blog pages
- Pattern: `{% if paginate.previous %}<link rel="prev" href="{{ paginate.previous.url }}">{% endif %}`
- Ensure paginated pages have unique titles (e.g., append "Page 2")
- Do not noindex paginated pages — let search engines discover all products

## Crawlability Rules
- Do not block Shopify CDN resources in robots.txt
- Minimize redirect chains — one hop maximum
- Fix broken links promptly — use `{{ url | within: collection }}` for collection-scoped product URLs
- Avoid JavaScript-only navigation — all key links must be `<a href>` tags
- Keep DOM depth reasonable — deeply nested elements hurt parse efficiency
