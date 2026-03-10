# SOP: Theme Development

## Git Flow

1. **Branch from `main`** for every change. Never commit directly to `main`.
2. **Branch naming:**
   - Feature: `client/{name}/feature/{description}`
   - Bugfix: `client/{name}/fix/{description}`
   - Hotfix: `client/{name}/hotfix/{description}`
3. **Pull requests** are required for all changes. PRs need at least one review before merge.
4. **Squash merge** into `main` to keep history clean.
5. **Delete the branch** after merge.

## Naming Conventions

- **Sections:** `section-{name}.liquid` (e.g., `section-featured-collection.liquid`)
- **Snippets:** `snippet-{name}.liquid` (e.g., `snippet-product-card.liquid`)
- **CSS classes:** BEM — `block__element--modifier` (e.g., `product-card__image--featured`)
- **JS files:** `{feature}.js` (e.g., `quick-add.js`)
- **Settings:** `snake_case` with section prefix (e.g., `hero_heading_size`)

## Testing Checklist

Before opening a PR, verify on all of the following:

### Devices
- [ ] Mobile (375px — iPhone SE size)
- [ ] Tablet (768px — iPad)
- [ ] Desktop (1440px)

### Browsers
- [ ] Chrome (latest)
- [ ] Safari (latest)
- [ ] Firefox (latest)
- [ ] Safari iOS

### Accessibility
- [ ] Keyboard navigation works for all interactive elements
- [ ] Screen reader announces content in logical order
- [ ] Color contrast meets WCAG AA (4.5:1 for text)
- [ ] Focus states are visible
- [ ] Images have descriptive alt text

### Functionality
- [ ] Theme editor: section settings render and update correctly
- [ ] No console errors or warnings
- [ ] Page speed is not degraded (run Lighthouse before and after)

## Deployment Process

1. Merge PR to `main`.
2. Push to a staging/unpublished theme via Shopify CLI for QA.
3. Get client approval if required.
4. Push to the live theme via Shopify CLI.
5. Verify live site within 15 minutes.

## Rollback Procedure

If a production deploy causes issues:

1. **Immediate:** In Shopify Admin, go to Online Store > Themes and publish the previous theme version.
2. **If theme backup exists:** Push the backup theme using `shopify theme push --live`.
3. **Document** the issue in the client's CHANGELOG.md.
4. **Post-mortem:** Create a brief note in the client's decision log explaining what went wrong and how to prevent it.
