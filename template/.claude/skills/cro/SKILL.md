# Conversion Rate Optimization

## Purpose
Increase store conversion rate and average order value through proven UX patterns and data-driven experimentation.

## When to Use
Invoke when building or optimizing product pages, cart experiences, checkout flows, or implementing A/B tests.

## AOV (Average Order Value) Tactics
- **Bundle offers:** "Complete the look" or "Frequently bought together" sections on product pages
- **Tiered discounts:** "Spend $75, save 10% / Spend $150, save 15%" — display progress toward next tier in cart
- **Free shipping threshold:** Show a dynamic progress bar in cart: "Add $XX more for free shipping"
- **Upsells in cart drawer:** Recommend complementary products before checkout
- **Quantity breaks:** Volume pricing displayed on product page (e.g., "Buy 3+ save 15%")
- Always show the customer what they gain, not what they lose

## Trust Signals
- **Reviews:** Display star ratings on product cards and detailed reviews on product pages
- **Trust badges:** Payment security, satisfaction guarantee, and shipping icons below Add to Cart
- **Social proof:** "X people bought this today" or "Y people viewing now" — use real data only
- **Guarantees:** Money-back guarantee, easy returns policy — link to full policy page
- **Press mentions:** "As seen in..." with recognizable logos
- Place trust signals in the decision zone — near the Add to Cart button

## Checkout Flow Optimization
- Minimize form fields — only collect what is necessary
- Offer guest checkout prominently — do not force account creation
- Show order summary throughout checkout
- Display security indicators (lock icon, SSL badge) near payment fields
- Enable Shop Pay, Apple Pay, Google Pay for express checkout
- Show estimated delivery date at checkout — reduces abandonment

## Mobile-First Conversion Patterns
- Sticky Add to Cart button that follows scroll on mobile
- Thumb-friendly tap targets: minimum 44x44px for buttons
- Collapsible product details (accordion) to reduce scroll depth
- Swipeable product image gallery with pinch-to-zoom
- Bottom-sheet cart drawer instead of full page redirect
- Ensure form inputs use correct `type` attributes (`email`, `tel`) for mobile keyboards

## Urgency and Scarcity (Ethical Implementation Only)
- Show real inventory levels: "Only 3 left in stock" — NEVER fabricate scarcity
- Limited-time offers must have genuine deadlines — do not loop fake countdown timers
- "Selling fast" indicators only when backed by real sales velocity data
- Seasonal urgency: "Order by Dec 18 for Christmas delivery" — based on actual shipping windows
- NEVER use dark patterns — they destroy trust and increase returns

## A/B Testing Framework
Every test MUST follow this structure:
1. **Hypothesis:** "If we [change], then [metric] will [direction] because [reason]"
2. **Primary metric:** One measurable KPI (conversion rate, AOV, revenue per visitor)
3. **Sample size:** Calculate required sample before starting (use a significance calculator)
4. **Duration:** Run for minimum 2 full business cycles (typically 2-4 weeks)
5. **Segmentation:** Analyze by device type (mobile vs desktop) separately
6. **Decision rule:** Declare winner at 95% statistical significance only
- Do not stop tests early on positive trends — let them reach significance
- Test one variable at a time unless running a multivariate test

## Cart Drawer vs Cart Page
### Cart drawer (recommended for most stores):
- Keeps customer on the current page — reduces friction
- Shows upsells and cross-sells in context
- Works well for stores with AOV under $100 and impulse purchases
### Cart page (better for):
- High-consideration purchases (AOV > $200)
- Stores needing detailed cart editing (quantity, variants)
- Complex shipping calculations or discount code entry
### Implementation:
- Always allow editing quantity and removing items without page reload
- Show product thumbnails and variant details in cart
- Display estimated total with taxes and shipping when possible

## Product Page Must-Haves
1. High-quality product images (minimum 4, include lifestyle and detail shots)
2. Clear product title and price (show compare-at price for sales)
3. Variant selector with visual swatches for color options
4. Add to Cart button — prominent, high contrast, above the fold on desktop
5. Product description with scannable formatting (bullets, short paragraphs)
6. Size guide or fit information where applicable
7. Shipping and return policy summary (expandable)
8. Customer reviews section with star distribution
9. "You may also like" product recommendations
10. Mobile: all critical info and CTA visible without scrolling past first viewport
