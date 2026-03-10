# Shopify APIs (Client-Side)

## Purpose
Guide usage of Shopify's JavaScript APIs for dynamic, interactive store features without full page reloads.

## When to Use
Invoke when building cart functionality, AJAX add-to-cart, live search, product filtering, dynamic section updates, or any feature that fetches/sends data client-side.

## Cart API

### Endpoints
All cart endpoints accept and return JSON. Base path: `/cart`

- `GET /cart.js` — fetch current cart state
- `POST /cart/add.js` — add items to cart
- `POST /cart/change.js` — update quantity of a line item
- `POST /cart/update.js` — update multiple line items at once
- `POST /cart/clear.js` — empty the cart

### Add to Cart
```javascript
const response = await fetch('/cart/add.js', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({
    items: [{ id: variantId, quantity: 1 }]
  })
});
const data = await response.json();
```
- `id` is the variant ID (number), NOT the product ID
- Can add multiple items in one request via the `items` array
- Include `properties` object for line item customization (e.g., engraving text)
- Returns the added item(s), not the full cart — fetch `/cart.js` after if you need the total

### Change Quantity
```javascript
await fetch('/cart/change.js', {
  method: 'POST',
  headers: { 'Content-Type': 'application/json' },
  body: JSON.stringify({ line: lineIndex, quantity: newQuantity })
});
```
- `line` is 1-based index (first item = 1, not 0)
- Set `quantity: 0` to remove an item
- Prefer `line` over `id` to avoid issues with duplicate variants that have different properties

### Fetch Cart
```javascript
const response = await fetch('/cart.js');
const cart = await response.json();
// cart.items, cart.total_price, cart.item_count, cart.currency
```
- `total_price` is in cents (integer) — divide by 100 for display
- `items` array contains line items with `product_title`, `variant_title`, `price`, `quantity`, `image`, `url`

### Error Handling
- 422 status: item out of stock or quantity exceeds inventory
- 404 status: invalid variant ID
- Always check `response.ok` before parsing JSON
- Display error messages from `response.json().description`

## Section Rendering API

Fetch server-rendered HTML for specific sections without a full page reload. Essential for updating cart drawers, product info on variant change, and live filtering.

### Usage
Append `?sections=section-id` to any page URL:
```javascript
const response = await fetch(`${window.location.pathname}?sections=cart-drawer,cart-icon-bubble`);
const sections = await response.json();
// sections['cart-drawer'] = rendered HTML string
// sections['cart-icon-bubble'] = rendered HTML string
```

### Key Patterns
- Request multiple sections in one call: `?sections=id1,id2,id3`
- Section IDs match the filename without `.liquid` extension
- For sections within JSON templates, use the full section ID: `template--12345678--section-name`
- After cart add/change, re-fetch cart sections to update the UI:
  ```javascript
  const response = await fetch('/?sections=cart-drawer,cart-icon-bubble');
  const html = await response.json();
  document.querySelector('#cart-drawer').innerHTML = html['cart-drawer'];
  ```
- After variant change on PDP, re-fetch the product section with the new variant:
  ```javascript
  const url = `${productUrl}?variant=${variantId}&sections=main-product`;
  ```

### Performance
- Only fetch sections you need to update — don't over-fetch
- Debounce rapid changes (e.g., quantity +/- buttons) — wait 300ms before fetching
- Show loading state while fetching (disable buttons, show spinner)

## Product Recommendations API

```javascript
const response = await fetch(
  `/recommendations/products.json?product_id=${productId}&limit=4&intent=related`
);
const { products } = await response.json();
```

- `intent`: `related` (similar products) or `complementary` (goes well with)
- `limit`: max 10 products
- Returns full product objects with variants, images, prices
- Returns empty array if no recommendations available — handle gracefully
- Cache results if the product doesn't change (avoid re-fetching on every render)

## Predictive Search API

```javascript
const response = await fetch(
  `/search/suggest.json?q=${encodeURIComponent(query)}&resources[type]=product,collection,article&resources[limit]=5`
);
const { resources } = await response.json();
// resources.results.products, resources.results.collections, resources.results.articles
```

- Debounce input: wait 300ms after the user stops typing before fetching
- Cancel previous requests using `AbortController` to avoid race conditions
- `resources[type]` accepts: `product`, `collection`, `article`, `page`
- `resources[limit]` caps results per type (max 10)
- Minimum query length: 2 characters before searching
- Render results in a dropdown with keyboard navigation (arrow keys + enter)

## Storefront API (GraphQL)

For advanced use cases only (headless sections, custom apps). Requires a Storefront API access token.

```javascript
const response = await fetch('/api/2024-01/graphql.json', {
  method: 'POST',
  headers: {
    'Content-Type': 'application/json',
    'X-Shopify-Storefront-Access-Token': token
  },
  body: JSON.stringify({ query: `{ shop { name } }` })
});
```

- Use only when Liquid + Ajax API can't achieve the goal
- Rate limited: 1 request per second for unauthenticated, higher for authenticated
- Common use cases: customer account features, wishlist functionality, multi-step forms

## General Patterns

### AbortController for Cancellation
Always cancel in-flight requests when starting a new one:
```javascript
let controller = null;

async function fetchData(url) {
  if (controller) controller.abort();
  controller = new AbortController();

  const response = await fetch(url, { signal: controller.signal });
  return response.json();
}
```

### Debounce
```javascript
function debounce(fn, delay = 300) {
  let timer;
  return (...args) => {
    clearTimeout(timer);
    timer = setTimeout(() => fn(...args), delay);
  };
}
```

### Custom Events for Communication
Dispatch events so other components can react without tight coupling:
```javascript
document.dispatchEvent(new CustomEvent('cart:updated', {
  detail: { cart: cartData }
}));
```
- Use `cart:updated` after any cart modification
- Use `variant:changed` after variant selection
- Use `search:submitted` after search query
- Listen with `document.addEventListener('cart:updated', handler)`

### Loading States
- Disable submit buttons during requests (`button.disabled = true`)
- Add `aria-busy="true"` to containers being updated
- Show visual indicator (spinner, opacity change)
- Re-enable and remove indicators in both success and error paths
