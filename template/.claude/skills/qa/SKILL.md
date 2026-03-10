# QA — Bug Verification & Issue Resolution

## Purpose
Ensure bugs are properly fixed, root causes are identified, and fixes don't introduce new issues. Follow a systematic process from reproduction through verification.

## When to Use
Invoke when fixing a reported bug, verifying a fix, investigating unexpected behavior, or reviewing a bug-fix PR.

## Bug Fix Process

### 1. Reproduce First
Before writing any code:
- Read the full bug report (steps to reproduce, expected vs actual behavior, screenshots/videos)
- Reproduce the issue locally using `shopify theme dev`
- Test on the same device/browser the bug was reported on
- Document the exact steps you follow to trigger the bug
- If you can't reproduce it, ask for more details — don't guess

### 2. Identify Root Cause
- Don't fix the symptom — find the actual cause
- Use browser DevTools: Console (JS errors), Elements (DOM state), Network (failed requests), Performance (rendering issues)
- Check if the bug exists in the live theme, preview theme, or both
- Check if it's device-specific, browser-specific, or viewport-specific
- Check if it's related to a recent change (use `git log` and `git diff`)
- Check if a Shopify app is injecting code that conflicts

### 3. Fix
- Make the smallest possible change that fixes the root cause
- Don't refactor surrounding code in a bug fix — keep the diff focused
- If the fix requires a larger change, discuss before implementing
- Comment the fix only if the reason isn't obvious from the code

### 4. Verify the Fix
Run through ALL of these:

#### Same Conditions
- [ ] Bug no longer occurs following the exact original reproduction steps
- [ ] Tested on the same device/browser as the report
- [ ] Tested at the same viewport width
- [ ] If the bug involved specific data (product, variant, collection), test with that same data

#### Regression Check
- [ ] The page/feature still works correctly in all normal use cases
- [ ] Related features are not broken (e.g., fixing cart quantity doesn't break cart removal)
- [ ] No new console errors introduced
- [ ] No visual layout shifts or broken styles
- [ ] Theme editor still works for the affected section/template

#### Cross-Device
- [ ] Desktop (Chrome + Safari minimum)
- [ ] Mobile (iOS Safari + Chrome Android minimum)
- [ ] If the bug was device-specific, verify on at least 2 other device types

#### Edge Cases
- [ ] Empty state (no products, empty cart, no search results)
- [ ] Max state (many items, long text, large images)
- [ ] Rapid interaction (double-click, fast typing, quick add/remove)
- [ ] Slow connection (throttle network in DevTools)

## Common Bug Categories

### Layout/CSS Bugs
**Symptoms:** Elements overlap, content clips, spacing is wrong, layout breaks at certain widths
**Investigation:**
- Inspect element in DevTools → check computed styles
- Toggle CSS rules on/off to find the conflicting rule
- Check for missing responsive breakpoints
- Check if a Shopify app injects CSS that overrides theme styles
**Verification:** Test at all breakpoints (375px, 768px, 1024px, 1280px), rotate mobile

### JavaScript Bugs
**Symptoms:** Feature doesn't work, console errors, page freezes, incorrect behavior
**Investigation:**
- Check console for errors — the error message usually points to the file and line
- Add `console.log` at key points to trace execution flow
- Check Network tab for failed API calls (cart, search, sections)
- Check if the issue is a race condition (does it work on slow connection?)
- Check if `defer` or `type="module"` loading order causes the issue
**Verification:** Test the feature end-to-end, check console is clean, test with and without browser cache

### Liquid/Rendering Bugs
**Symptoms:** Wrong content displayed, missing sections, broken template, Liquid errors in page source
**Investigation:**
- View page source to see raw Liquid output
- Check if the object exists: `{% if product %}` before accessing `.title`
- Check for nil/blank values: `{{ value | default: 'fallback' }}`
- Check if the bug is in a specific template (product, collection, page) or global (theme.liquid)
- Check JSON template structure for correct section references
**Verification:** Test with different products/collections/pages to ensure the fix is generic

### Cart Bugs
**Symptoms:** Wrong quantities, items not adding, cart total incorrect, cart drawer not updating
**Investigation:**
- Check Network tab for cart API calls — are they succeeding?
- Check the response body for error messages
- Check if variant IDs are correct (log them before the fetch)
- Check if the Section Rendering API response is being applied correctly
- Check for race conditions with rapid add/remove
**Verification:** Add item → change quantity → remove item → add different item → verify totals at each step

### Theme Editor Bugs
**Symptoms:** Section doesn't appear, settings don't save, preview doesn't update, editor crashes
**Investigation:**
- Validate `{% schema %}` JSON is valid (use a JSON validator)
- Check that setting IDs are unique within the section
- Check that block types are properly defined
- Check that default values match the setting type
**Verification:** Open theme editor → add the section → change every setting → reorder blocks → save and reload

## Bug Fix PR Template

```markdown
## Bug Fix

**Issue:** [Brief description of the bug]

**Root Cause:** [What was actually wrong]

**Fix:** [What was changed and why]

**Reproduction Steps:**
1. [Step 1]
2. [Step 2]
3. [Expected: X, Was: Y, Now: X]

**Verification:**
- [ ] Bug no longer reproduces
- [ ] Tested on [devices/browsers]
- [ ] No regressions in related features
- [ ] No new console errors
- [ ] Theme editor still works

**Preview:** [Preview theme link]
**Screenshots:** [Before/after if visual]
```

## When a Fix Doesn't Work

If the bug persists after your fix:
1. Re-read the original report — are you fixing the right thing?
2. Clear all caches (browser cache, Shopify CDN cache — add `?v=timestamp` to asset URLs)
3. Check if the fix deployed to the right theme
4. Check if another section/snippet is overriding your fix
5. Check if a Shopify app is re-injecting the broken behavior
6. Hard refresh (`Cmd+Shift+R`) — the browser may be serving a cached version

## Severity Guide

| Severity | Description | Response |
|----------|-------------|----------|
| **Critical** | Can't add to cart, checkout broken, site down, data loss | Fix immediately, deploy to production |
| **High** | Feature broken for a segment of users (mobile, specific browser) | Fix within 24 hours |
| **Medium** | Visual bug, minor functionality issue, workaround exists | Fix in next sprint/PR batch |
| **Low** | Cosmetic, edge case, minor text issue | Fix when convenient |
