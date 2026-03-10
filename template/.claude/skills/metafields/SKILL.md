# Shopify Metafields & Metaobjects

## Purpose
Guide the use of metafields and metaobjects for extending Shopify's data model with custom structured data.

## When to Use
Invoke when adding custom product data, building dynamic content blocks, creating reusable data structures, or connecting custom data to the theme editor.

## Metafield Basics

Metafields attach custom data to Shopify resources (products, collections, customers, orders, shop, pages, articles).

### Structure
- **Namespace:** grouping key (e.g., `custom`, `brand`, `sizing`)
- **Key:** the field name (e.g., `subtitle`, `wash_instructions`, `size_chart`)
- **Type:** the data type (see types below)
- **Value:** the actual data

Full reference: `resource.metafields.namespace.key`

### Accessing in Liquid
```liquid
{{ product.metafields.custom.subtitle.value }}
{{ product.metafields.sizing.size_chart.value }}
{{ shop.metafields.brand.announcement_text.value }}
```
- Always access `.value` — the metafield object itself contains metadata you don't need in output
- Check existence before rendering:
  ```liquid
  {% if product.metafields.custom.subtitle %}
    <p class="product-subtitle">{{ product.metafields.custom.subtitle.value }}</p>
  {% endif %}
  ```

## Common Types

| Type | Use for | Liquid output |
|------|---------|---------------|
| `single_line_text_field` | Short text (subtitle, badge label) | String |
| `multi_line_text_field` | Long text (care instructions, ingredients) | String with newlines |
| `rich_text_field` | Formatted content (descriptions with bold/lists) | HTML via `| metafield_tag` |
| `number_integer` | Whole numbers (stock threshold, rating count) | Number |
| `number_decimal` | Decimal numbers (weight, dimensions) | Number |
| `boolean` | True/false flags (is_new, show_badge, hide_reviews) | `true` or `false` |
| `date` | Dates (launch_date, expiry) | Date string |
| `url` | Links (size guide PDF, external spec sheet) | URL string |
| `color` | Color values (accent color per product) | Hex string |
| `file_reference` | Images, PDFs, videos from Files | File object |
| `product_reference` | Link to another product (paired item, upgrade) | Product object |
| `collection_reference` | Link to a collection | Collection object |
| `metaobject_reference` | Link to a metaobject entry | Metaobject object |
| `list.single_line_text_field` | Array of strings (features, tags, bullets) | Array |
| `list.file_reference` | Multiple files (additional images, documents) | Array |
| `list.product_reference` | Multiple products (bundle items, alternatives) | Array |
| `json` | Arbitrary JSON (complex structured data) | JSON string — parse with `| parse_json` |

### Rich Text
```liquid
{% if product.metafields.custom.detailed_description %}
  <div class="rte">
    {{ product.metafields.custom.detailed_description | metafield_tag }}
  </div>
{% endif %}
```
- `metafield_tag` converts rich text to HTML
- Wrap in `.rte` class for consistent styling with theme's rich text styles

### File References
```liquid
{% assign hero = product.metafields.custom.hero_image.value %}
{% if hero %}
  {{ hero | image_url: width: 1200 | image_tag: loading: 'lazy' }}
{% endif %}
```

### List Types
```liquid
{% assign features = product.metafields.custom.features.value %}
{% if features.size > 0 %}
  <ul>
    {% for feature in features %}
      <li>{{ feature }}</li>
    {% endfor %}
  </ul>
{% endif %}
```

### Product References
```liquid
{% assign paired = product.metafields.custom.paired_product.value %}
{% if paired %}
  <a href="{{ paired.url }}">Goes great with {{ paired.title }}</a>
{% endif %}
```

## Connecting Metafields to Theme Editor

Define metafields as dynamic sources in section schemas so merchants can map them in the theme editor without code changes.

### In Section Schema
```json
{
  "type": "text",
  "id": "subtitle",
  "label": "Subtitle",
  "info": "Connect to a product metafield for dynamic content"
}
```

Merchants can then click the "Connect dynamic source" icon in the editor and select any matching metafield.

### Typed Settings That Accept Dynamic Sources
These setting types can connect to metafield dynamic sources:
- `text` — single_line_text, multi_line_text
- `richtext` — rich_text_field
- `image_picker` — file_reference (image)
- `url` — url
- `number` — number_integer, number_decimal
- `checkbox` — boolean
- `color` — color
- `product` — product_reference
- `collection` — collection_reference

## Metaobjects

Metaobjects are custom content types — reusable structured entries like FAQs, team members, store locations, size charts, or promotional banners.

### Structure
- **Definition:** the schema (type name, fields, display name field)
- **Entries:** individual records that follow the definition

### Example: FAQ Entries
Definition: `faq_item` with fields:
- `question` (single_line_text_field)
- `answer` (rich_text_field)
- `category` (single_line_text_field)

### Accessing in Liquid
When connected via a metaobject_reference metafield:
```liquid
{% assign faq = product.metafields.custom.faq_items.value %}
{% for item in faq %}
  <details>
    <summary>{{ item.question.value }}</summary>
    <div>{{ item.answer | metafield_tag }}</div>
  </details>
{% endfor %}
```

When using metaobject as a dynamic source in sections:
- Metaobjects can be selected directly in the theme editor
- Merchants manage entries in Settings > Custom data > Metaobjects

### When to Use Metaobjects vs Metafields
- **Metafields:** data attached TO a resource (product subtitle, collection badge)
- **Metaobjects:** standalone reusable entries (FAQ items, team members, testimonials, store locations)
- Rule of thumb: if the data belongs to one product, use metafields. If it's shared or independent, use metaobjects.

## Namespace Conventions

Keep namespaces consistent across the store:

| Namespace | Use for |
|-----------|---------|
| `custom` | Shopify's default namespace — fine for simple stores |
| `product` | Product-specific extended data (subtitle, badge, care instructions) |
| `seo` | SEO overrides (custom meta title, meta description, schema data) |
| `sizing` | Size-related data (size chart, fit guide, measurement images) |
| `shipping` | Shipping info (handling time, weight override, shipping class) |
| `brand` | Store-level brand data (announcement, social links, contact info) |

- Use lowercase, snake_case for both namespaces and keys
- Avoid the `global` namespace — it's deprecated
- Document all metafield definitions in the client's CLAUDE.md under Special Rules

## Common Patterns

### Badges from Metafields
```liquid
{% if product.metafields.custom.badge %}
  <span class="product-badge product-badge--{{ product.metafields.custom.badge.value | handleize }}">
    {{ product.metafields.custom.badge.value }}
  </span>
{% endif %}
```

### Conditional Sections
```liquid
{% if product.metafields.custom.show_size_chart %}
  {% render 'snippet-size-chart', product: product %}
{% endif %}
```

### SEO Overrides
```liquid
{% assign seo_title = product.metafields.seo.custom_title.value | default: product.title %}
{% assign seo_desc = product.metafields.seo.custom_description.value | default: product.description | strip_html | truncate: 155 %}
<title>{{ seo_title }} | {{ shop.name }}</title>
<meta name="description" content="{{ seo_desc }}">
```

## Pitfalls
- Never hardcode metafield values — always use Liquid to read them dynamically
- Metafield definitions must be created in Shopify admin before they appear as dynamic sources
- `json` type metafields require `| parse_json` filter before use — otherwise you get a raw string
- List types return an array from `.value` — iterate with `{% for %}`, don't output directly
- File reference metafields return a file object — use `| image_url` or `| file_url` to get the URL
- Metaobject entries are not products — they don't have `.url` by default unless you enable web pages for the metaobject definition
