# Image Optimization Pipeline

Standards and configuration for image handling across all Shopify themes.

## Recommended Formats

| Format | Use Case | Notes |
|--------|----------|-------|
| **WebP** | Primary format for all raster images | 25-35% smaller than JPEG at equivalent quality. Shopify CDN serves WebP automatically via `image_url` filter. |
| **AVIF** | Progressive enhancement where supported | 40-50% smaller than JPEG. Limited browser support; use as first `<source>` in `<picture>` elements. |
| **JPEG** | Fallback for raster photos | Universal support. Use as the `<img>` src fallback. |
| **PNG** | Graphics requiring transparency | Avoid for photographs. Use SVG instead when possible. |
| **SVG** | Icons, logos, simple illustrations | Inline for icons under 2KB. Reference via `<img>` for larger assets. Always minify with SVGO. |

## Maximum Dimensions by Use Case

| Context | Max Width | Aspect Ratio | Notes |
|---------|-----------|--------------|-------|
| **Hero / Banner** | 2048px | 16:9 or 21:9 | Serve 2x for retina. Use `sizes="100vw"`. |
| **Product Main Image** | 1024px | 1:1 or 3:4 | Serve 2x for retina. Square preferred for grid consistency. |
| **Product Thumbnail** | 400px | 1:1 | Used in galleries, cart drawers, quick views. |
| **Collection Card** | 600px | 1:1 or 3:4 | Grid cards on collection pages. |
| **Blog / Article Feature** | 1200px | 16:9 | Open Graph images should be exactly 1200x630. |
| **Logo** | 400px | Variable | SVG preferred. PNG fallback at 2x. |
| **Favicon** | 180px | 1:1 | Provide 32x32, 180x180 (Apple touch), and SVG. |

## Compression Targets

| Context | Format | Quality | Target File Size |
|---------|--------|---------|-----------------|
| Hero / Banner | WebP | 75-80 | < 200KB |
| Product Main | WebP | 80-85 | < 120KB |
| Thumbnail | WebP | 70-75 | < 30KB |
| Collection Card | WebP | 75-80 | < 80KB |
| Blog Feature | WebP | 75-80 | < 150KB |
| Logo (raster) | PNG | Lossless | < 50KB |

## Srcset Widths

Standard breakpoints for the `srcset` attribute:

```
200, 400, 600, 800, 1000, 1200, 1600, 2048
```

Use the responsive image snippet (`snippet-image-responsive.liquid`) which generates srcset with widths: 200, 400, 600, 800, 1000.

For hero images requiring wider renders, extend to 1200, 1600, and 2048 manually.

## Lazy Loading Strategy

- **Eager load** (`loading="eager"`): Above-the-fold images only. Typically the hero image and first visible product image.
- **Lazy load** (`loading="lazy"`): Everything below the fold. The responsive image snippet defaults to lazy loading.
- Set `decoding="async"` on all lazy-loaded images to avoid blocking the main thread.
- Always provide explicit `width` and `height` attributes to prevent layout shift (CLS).

## Shopify CDN Usage

Always use Shopify's `image_url` filter rather than `img_url` (deprecated). The CDN automatically handles format negotiation (serves WebP/AVIF to supported browsers).

```liquid
{{ image | image_url: width: 800 }}
```

For precise control over crop and dimensions:

```liquid
{{ image | image_url: width: 600, height: 600, crop: 'center' }}
```

## Pre-Upload Checklist

1. Strip EXIF metadata (reduces file size, removes GPS data).
2. Resize to 2x the maximum display dimension (e.g., 2048px source for a 1024px display slot).
3. Compress to target quality before upload -- Shopify's CDN does not re-compress.
4. Use descriptive filenames: `navy-wool-sweater-front.jpg` not `IMG_4392.jpg`.
5. Ensure alt text is set on every image in the Shopify admin.

## Performance Budget

| Metric | Target |
|--------|--------|
| Total image weight per page | < 500KB (initial viewport) |
| Largest Contentful Paint image | < 200KB |
| Layout shift from images (CLS) | 0 (explicit dimensions required) |
| Number of image requests above fold | <= 5 |
