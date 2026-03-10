# Shopify Accessibility (A11y)

## Purpose
Ensure the store meets WCAG 2.1 AA compliance, works for all users regardless of ability, and avoids legal risk.

## When to Use
Invoke when building UI components, auditing existing pages, fixing accessibility issues, or reviewing theme code.

## Target Standard
WCAG 2.1 Level AA — this is the legal baseline in most jurisdictions (ADA, EAA, AODA).

## Semantic HTML
- Use `<nav>`, `<main>`, `<header>`, `<footer>`, `<aside>`, `<article>`, `<section>` — not generic `<div>` wrappers
- One `<main>` per page
- Use `<button>` for actions, `<a>` for navigation — never a `<div>` with a click handler
- Use `<ul>`/`<ol>` for lists (product grids, navigation menus, breadcrumbs)
- Use `<table>` for tabular data (size charts, comparison tables) — never for layout
- Headings (`<h1>`–`<h6>`) must follow logical hierarchy — never skip levels

## Keyboard Navigation
- Every interactive element must be reachable and operable via keyboard
- Tab order must follow visual layout — use natural DOM order, avoid `tabindex` > 0
- Focus must be visible — never `outline: none` without a replacement style
- Custom focus styles: minimum 2px solid outline with sufficient contrast
- Dropdown menus, modals, and drawers must trap focus while open
- Escape key must close modals, drawers, and popups
- Skip-to-content link as the first focusable element on every page:
  ```liquid
  <a href="#MainContent" class="skip-to-content">Skip to content</a>
  ```
- After cart add or drawer open, move focus to the new content

## Images and Media
- Every `<img>` MUST have an `alt` attribute
- Descriptive alt text: describe what the image shows, not "image of..."
- Decorative images: `alt=""` (empty, not omitted)
- Product images: use product title + variant as alt text
  ```liquid
  alt="{{ image.alt | escape | default: product.title }}"
  ```
- Icons: if the icon conveys meaning, add `aria-label` or visually hidden text. If decorative, use `aria-hidden="true"`
- Videos must have captions or transcripts
- Avoid auto-playing video with sound — if auto-play, must be muted with visible controls

## Forms
- Every input MUST have an associated `<label>` element (use `for` + `id`)
- Placeholder text is NOT a substitute for labels
- Group related fields with `<fieldset>` and `<legend>` (e.g., shipping address, payment)
- Required fields: use `aria-required="true"` and visual indicator
- Error messages: use `aria-describedby` to link error text to the input
  ```html
  <input id="email" aria-describedby="email-error" aria-invalid="true">
  <p id="email-error" role="alert">Please enter a valid email address.</p>
  ```
- Error summary: list all errors at the top of the form with links to each field
- Don't rely on color alone to indicate errors — use icons or text

## Color and Contrast
- Text: minimum 4.5:1 contrast ratio against background
- Large text (18px+ or 14px+ bold): minimum 3:1 contrast ratio
- UI components and icons: minimum 3:1 contrast ratio
- Never rely on color alone to convey information (errors, status, required fields)
- Sale prices: don't just use red — also use strikethrough or a "Sale" label
- Links within text: must be distinguishable by more than color (underline or bold)
- Test with browser's forced-colors mode (Windows High Contrast)

## ARIA
- Prefer native HTML semantics over ARIA — `<button>` over `<div role="button">`
- Use ARIA only when native elements can't achieve the semantics
- Common patterns:
  - Modal/drawer: `role="dialog"`, `aria-modal="true"`, `aria-label="Cart drawer"`
  - Accordion: `aria-expanded="true/false"` on trigger, `aria-controls` pointing to panel
  - Tabs: `role="tablist"`, `role="tab"`, `role="tabpanel"`, `aria-selected`
  - Loading states: `aria-busy="true"` on the container, `aria-live="polite"` for updates
  - Cart count: `aria-live="polite"` so screen readers announce changes
  - Quantity selector: `aria-label="Quantity for {product name}"`
- Never use `aria-label` on non-interactive elements (except landmarks and `role="img"`)
- Test with a screen reader — ARIA that sounds wrong is worse than no ARIA

## Shopify-Specific Patterns

### Product Page
- Image gallery: arrow keys to navigate, alt text on every image
- Variant selector: use native `<select>` or `<input type="radio">` with labels — not clickable `<div>` swatches without roles
- If using custom swatches: `role="radiogroup"` on container, `role="radio"` + `aria-checked` on each swatch
- Add to Cart button: clear label, announce result ("Added to cart" via `aria-live`)
- Price: use `<ins>` for sale price and `<del>` for compare-at price, or visually hidden text like "Regular price" / "Sale price"

### Navigation
- Mega menu: `aria-expanded` on trigger, trap focus within when open
- Mobile hamburger menu: `aria-label="Open menu"` / `"Close menu"`, toggle `aria-expanded`
- Breadcrumbs: wrap in `<nav aria-label="Breadcrumb">`, use `<ol>` with `<li>` items
- Pagination: wrap in `<nav aria-label="Pagination">`, current page gets `aria-current="page"`

### Cart
- Cart drawer: trap focus when open, return focus to trigger on close
- Quantity changes: announce new total via `aria-live="polite"`
- Remove item: confirm action, announce result
- Empty cart: announce "Your cart is empty" in the live region

### Announcements
- Announcement bar: use `role="status"` or `aria-live="polite"` if content rotates
- Toast notifications (added to cart, errors): use `role="alert"` for urgent or `role="status"` for informational

## Testing Checklist
1. **Keyboard:** tab through every page — can you reach and use everything?
2. **Screen reader:** test with VoiceOver (Mac) or NVDA (Windows) — does it make sense?
3. **Zoom:** zoom to 200% — does the layout still work?
4. **Color:** view in grayscale — is all information still conveyed?
5. **Motion:** enable `prefers-reduced-motion` — do animations stop?
6. **Automated:** run Lighthouse Accessibility audit and axe DevTools — fix all critical/serious issues
7. **Focus:** is focus visible on every interactive element?

## Common Mistakes
- Using `<div onclick>` instead of `<button>` — no keyboard support, no screen reader announcement
- Hiding content with `display: none` but expecting screen readers to read it — use `.visually-hidden` class instead
- Adding `aria-label` to `<div>` or `<span>` that has no role — it gets ignored
- Removing focus outlines for aesthetics — replace with a styled focus indicator
- Infinite scroll without a "Load more" button alternative
- Carousel/slider with no pause control and no keyboard navigation
- Color-only error states on forms
