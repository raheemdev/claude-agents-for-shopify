# Speed Analysis Prompt Template

Use this prompt to analyze Lighthouse JSON results for a Shopify store. Provide the JSON file path or paste the key metrics, then work through each section.

---

## 1. Summary Scores

Report the top-level Lighthouse scores:

| Metric | Score | Rating (Good / Needs Work / Poor) |
|--------|-------|-----------------------------------|
| Performance | | |
| Accessibility | | |
| Best Practices | | |
| SEO | | |

## 2. Largest Contentful Paint (LCP)

- **Current value:** (target: under 2.5s)
- What is the LCP element? (hero image, video, text block?)
- Is the LCP image preloaded with `<link rel="preload">`?
- Is the LCP image served in modern format (WebP/AVIF)?
- Is the LCP image properly sized for the viewport?
- Is server response time (TTFB) contributing to slow LCP?

## 3. Cumulative Layout Shift (CLS)

- **Current value:** (target: under 0.1)
- Which elements are shifting? (images without dimensions, dynamic ads, fonts?)
- Are explicit `width` and `height` set on all images and videos?
- Is font-display:swap causing layout shift? Consider `font-display:optional` or preloading fonts.
- Are any injected elements (app embeds, popups) causing shifts on load?

## 4. Interaction to Next Paint (INP)

- **Current value:** (target: under 200ms)
- Which interactions are slowest? (button clicks, form inputs, nav toggles?)
- Is there heavy JavaScript blocking the main thread during interaction?
- Are event handlers debounced/throttled where appropriate?
- Is third-party JS contributing to input delay?

## 5. Render-Blocking Resources

List all render-blocking resources identified:

- CSS files:
- JS files:
- For each: Can it be deferred, async-loaded, or inlined?
- Are critical CSS styles inlined in the `<head>`?
- Are non-critical scripts using `defer` or `async`?

## 6. Image Optimization Opportunities

- How many images are unoptimized?
- Total potential savings (KB/MB):
- Are images using Shopify's CDN image transformations (`_width`, `crop`, `format`)?
- Are offscreen images lazy-loaded (`loading="lazy"`)?
- Are hero/above-fold images explicitly NOT lazy-loaded?
- Is there an opportunity to use `<picture>` with responsive `srcset`?

## 7. Third-Party Impact

List third-party scripts by main thread blocking time:

| Script/Domain | Blocking Time (ms) | Transfer Size | Essential? |
|--------------|-------------------|---------------|------------|
| | | | |

- Which third-party scripts can be removed entirely?
- Which can be loaded after user interaction (e.g., chat widgets)?
- Are any duplicated (e.g., multiple analytics tags)?

## 8. Actionable Recommendations

Prioritize by estimated impact (high/medium/low):

### High Impact
1.
2.
3.

### Medium Impact
1.
2.
3.

### Low Impact / Quick Wins
1.
2.
3.

---

## Before/After Tracking

| Metric | Before | After | Change |
|--------|--------|-------|--------|
| Performance Score | | | |
| LCP (s) | | | |
| CLS | | | |
| INP (ms) | | | |
| Total Blocking Time (ms) | | | |
| Speed Index (s) | | | |
| Total Page Weight (KB) | | | |
