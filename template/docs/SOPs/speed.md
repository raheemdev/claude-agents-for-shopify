# SOP: Speed Optimization

## Core Web Vitals Targets

| Metric | Good | Needs Improvement | Poor |
|--------|------|-------------------|------|
| LCP (Largest Contentful Paint) | < 2.5s | 2.5s - 4.0s | > 4.0s |
| CLS (Cumulative Layout Shift) | < 0.1 | 0.1 - 0.25 | > 0.25 |
| INP (Interaction to Next Paint) | < 200ms | 200ms - 500ms | > 500ms |

**Our target: All three metrics in the "Good" range for the 75th percentile of page loads.**

## Measurement Process

### Lab Data (Controlled Environment)
- Run Lighthouse via `tools/scripts/seo-audit.sh` or Chrome DevTools
- Use the `tools/prompts/speed-analysis.md` template to analyze results
- Test on simulated mobile (Moto G Power on 4G) — this is Lighthouse's default
- Run at least 3 times and use the median score

### Field Data (Real Users)
- **Primary source:** Chrome User Experience Report (CrUX) via PageSpeed Insights
- **Secondary:** Shopify Web Performance dashboard in admin
- Check field data monthly; this is what Google uses for ranking
- If lab and field data diverge significantly, investigate (usually third-party scripts or geo differences)

## Optimization Priority Order

Work through these in order. Stop when targets are met:

1. **Reduce server response time (TTFB)**
   - Use Shopify's CDN (automatic)
   - Minimize Liquid template complexity (reduce nested loops, limit `| json` on large objects)

2. **Optimize LCP element**
   - Preload the hero image: `<link rel="preload" as="image" href="...">`
   - Use Shopify's image CDN with proper sizing (`| image_url: width: 1200`)
   - Serve WebP/AVIF via Shopify CDN (`format: 'pjpg'` auto-serves WebP)

3. **Eliminate render-blocking resources**
   - Defer non-critical JS with `defer` attribute
   - Inline critical CSS, defer the rest
   - Move app scripts to load after DOM content loaded

4. **Reduce JavaScript execution**
   - Audit third-party apps — remove unused apps and their leftover code
   - Lazy-load below-fold sections and their JS
   - Replace heavy libraries with vanilla JS where possible

5. **Fix layout shifts (CLS)**
   - Set explicit width/height on all images and videos
   - Reserve space for dynamic content (reviews, app embeds)
   - Use `font-display: swap` with font preloading

6. **Optimize images**
   - Use `loading="lazy"` on below-fold images
   - Use responsive `srcset` with Shopify's image URL filters
   - Ensure hero images are NOT lazy-loaded

## Testing Before/After Methodology

1. **Before:** Run Lighthouse 3 times on the target page. Record median scores.
2. **Make one change at a time.** Never batch unrelated optimizations.
3. **After:** Run Lighthouse 3 times again. Record median scores.
4. **Document** in the client's `speed/reports/` folder using the tracking table in `tools/prompts/speed-analysis.md`.
5. **Wait 28 days** for field data (CrUX) to reflect changes before declaring success.
