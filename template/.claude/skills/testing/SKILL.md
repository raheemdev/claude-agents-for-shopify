# Shopify Theme Testing & QA

## Purpose
Ensure theme code works correctly across browsers, devices, and the Shopify theme editor before deploying to production.

## When to Use
Invoke when reviewing code before PR/deploy, setting up testing workflows, debugging cross-browser issues, or establishing quality gates.

## Theme Check (Linting)

Shopify's official linter for Liquid and theme files.

### Setup
```bash
# Install
gem install theme-check
# Or via Shopify CLI
shopify theme check
```

### Run
```bash
# Check entire theme
shopify theme check --path .

# Check with auto-fix
shopify theme check --path . --auto-correct
```

### Key Rules It Catches
- `{% include %}` usage (should be `{% render %}`)
- Missing `alt` attributes on images
- Deprecated Liquid tags and filters
- Missing `loading="lazy"` on images
- Unused variables and snippets
- Translation key issues
- Large CSS/JS files that should be split
- Nested `for` loops (performance)

### Configuration
Create `.theme-check.yml` in the theme root to customize:
```yaml
# Disable specific checks
TemplateLength:
  enabled: false

# Adjust thresholds
AssetSizeCSS:
  threshold_in_bytes: 50000
```

## Preview Theme Testing

NEVER test on the live theme. Always use a preview/development theme.

### Workflow
```bash
# Start local development server
shopify theme dev --store your-store.myshopify.com --path .

# Push to a preview (unpublished) theme
shopify theme push --store your-store.myshopify.com --path . --unpublished

# Push to a specific theme by ID
shopify theme push --store your-store.myshopify.com --path . --theme THEME_ID
```

### Preview Links
- After pushing to a preview theme, share the preview URL for review
- Preview URL format: `https://your-store.myshopify.com/?preview_theme_id=THEME_ID`
- Include preview links in every PR description

## Theme Editor Compatibility

Every section and setting must work correctly in the Shopify theme editor.

### Checklist
- [ ] All sections appear in the editor's section picker
- [ ] All settings render correctly (text inputs, image pickers, color selectors, range sliders)
- [ ] Block types can be added, removed, and reordered
- [ ] Default values make the section look good without configuration
- [ ] Live preview updates as settings change (no page reload needed for basic changes)
- [ ] Schema `info` text helps merchants understand what each setting does
- [ ] Section presets have clear, descriptive names

### Common Issues
- Missing `presets` in schema: section won't appear in editor's "Add section"
- Settings that crash the editor: avoid `{% schema %}` syntax errors — the editor won't load
- Dynamic sources not appearing: ensure metafield definitions exist in admin
- Blocks not reorderable: check that `blocks` array is properly defined in schema

## Cross-Browser Testing

### Browser Matrix
| Browser | Priority | Notes |
|---------|----------|-------|
| Chrome (latest) | Must pass | ~65% of Shopify traffic |
| Safari (latest) | Must pass | ~20%, especially mobile |
| Firefox (latest) | Should pass | ~5% |
| Edge (latest) | Should pass | Chromium-based |
| Safari iOS | Must pass | Mobile is 60-70% of store traffic |
| Chrome Android | Must pass | Second mobile browser |

### What to Check Per Browser
- Layout: no broken grids, overlapping elements, or clipped content
- Fonts: loading correctly, fallbacks don't cause major shift
- JavaScript: no console errors, interactive features work
- Forms: input types render correctly, validation works
- Animations: smooth, respect `prefers-reduced-motion`
- Images: responsive images load correct sizes, lazy loading works

### Known Cross-Browser Issues
- `gap` in flexbox: not supported in older Safari (< 14.1) — use margins as fallback
- `aspect-ratio`: not supported in Safari < 15 — use padding-top hack as fallback
- `:has()` selector: not supported in Firefox < 121 — don't rely on it for critical layouts
- `loading="lazy"`: not supported in some older browsers — degrades gracefully (loads eagerly)
- `dialog` element: limited support — use `div[role="dialog"]` with manual focus management instead

## Device Testing

### Breakpoints to Test
| Device | Width | What to check |
|--------|-------|---------------|
| Mobile (small) | 375px | iPhone SE, compact layout |
| Mobile (large) | 428px | iPhone Pro Max, larger phones |
| Tablet (portrait) | 768px | iPad, 2-column layouts |
| Tablet (landscape) | 1024px | iPad landscape, nav breakpoints |
| Desktop | 1280px | Standard laptop |
| Desktop (large) | 1920px | External monitors |

### Mobile-Specific Checks
- Touch targets: minimum 44x44px for buttons and links
- No horizontal scroll on any page
- Text readable without zooming (minimum 16px body text)
- Forms use correct input types (`type="email"`, `type="tel"`) for mobile keyboards
- Fixed/sticky elements don't overlap content or block interaction
- Cart drawer opens and closes smoothly
- Product image gallery is swipeable

## Performance Testing

### Lighthouse
```bash
# Run from CLI
lighthouse https://your-store.com --only-categories=performance,accessibility,seo,best-practices

# Run against preview theme
lighthouse "https://your-store.com/?preview_theme_id=THEME_ID"
```

### What to Measure
| Metric | Target | Tool |
|--------|--------|------|
| Performance Score | > 60 mobile, > 80 desktop | Lighthouse |
| LCP | < 2.5s | Lighthouse, PageSpeed Insights |
| CLS | < 0.1 | Lighthouse, PageSpeed Insights |
| INP | < 200ms | Chrome DevTools, Web Vitals extension |
| Accessibility Score | > 90 | Lighthouse |
| Theme Check | 0 errors | `shopify theme check` |

### Before/After Methodology
1. Run Lighthouse on the page BEFORE your changes (save the report)
2. Make your changes
3. Run Lighthouse again on the same page, same conditions
4. Compare scores — flag any regressions
5. Include before/after scores in PR description

## Functional Testing Checklist

### Every Page Type
- [ ] Page loads without console errors
- [ ] All links work (no 404s)
- [ ] Responsive layout at all breakpoints
- [ ] Text is readable, no overflow or clipping
- [ ] Images load and display correctly

### Product Page
- [ ] All variants selectable
- [ ] Price updates on variant change
- [ ] Compare-at price shows correctly for sale items
- [ ] Add to cart works (correct variant, correct quantity)
- [ ] Out-of-stock variants show as unavailable
- [ ] Image gallery updates on variant change
- [ ] Product description renders HTML correctly

### Collection Page
- [ ] Products display in correct order
- [ ] Pagination or infinite scroll works
- [ ] Filtering works (if applicable)
- [ ] Sorting works (if applicable)
- [ ] Product cards show correct info (title, price, image)

### Cart
- [ ] Items can be added from product page
- [ ] Quantity can be changed
- [ ] Items can be removed
- [ ] Cart total updates correctly
- [ ] Discount codes work (if applicable)
- [ ] Empty cart state displays properly
- [ ] Cart icon/bubble shows correct count

### Checkout
- [ ] Cart to checkout transition works
- [ ] No broken styles or missing elements (Shopify Plus only for checkout customization)

### Search
- [ ] Search returns relevant results
- [ ] Predictive search works (if enabled)
- [ ] No results state displays properly
- [ ] Search works on mobile

### Navigation
- [ ] All menu items link correctly
- [ ] Dropdown/mega menu opens and closes
- [ ] Mobile menu opens and closes
- [ ] Breadcrumbs show correct hierarchy

## PR Review Checklist

Before approving any PR:

### Code Quality
- [ ] No `{% include %}` tags (use `{% render %}`)
- [ ] No inline `<style>` blocks (except critical CSS)
- [ ] No synchronous `<script>` tags in `<head>`
- [ ] No hardcoded URLs (use `{{ routes.* }}`)
- [ ] No nested `forloop` in same file
- [ ] Schema has sensible defaults and clear labels
- [ ] New sections have `presets` for editor access

### Accessibility
- [ ] Images have `alt` attributes
- [ ] Interactive elements are keyboard accessible
- [ ] Focus styles are visible
- [ ] Form inputs have labels
- [ ] Color contrast is sufficient

### Performance
- [ ] Images use `loading="lazy"` below fold
- [ ] New JS is deferred or uses `type="module"`
- [ ] No render-blocking resources added
- [ ] No Lighthouse regression

### Completeness
- [ ] CHANGELOG.md updated
- [ ] Preview theme link included
- [ ] Screenshots for visual changes
- [ ] Tested on mobile and desktop
