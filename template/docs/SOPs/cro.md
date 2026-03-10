# SOP: Conversion Rate Optimization

## Experiment Framework

Every CRO change follows this cycle:

### 1. Hypothesis
Write a clear hypothesis before any work begins:

> "If we [change], then [metric] will [improve/increase/decrease] because [reason]."

Example: "If we add a sticky Add to Cart bar on mobile PDP, then mobile add-to-cart rate will increase by 10% because the CTA stays visible during scroll."

### 2. Design
- Mock up or describe the change.
- Identify the primary metric (e.g., add-to-cart rate, checkout completion).
- Identify guardrail metrics (metrics that should NOT get worse, e.g., bounce rate).

### 3. Implement
- Build the variant using theme code or an A/B testing tool.
- Use feature flags or A/B tool's traffic splitting — never deploy untested changes to 100% of traffic.
- Tag the experiment in analytics for clean measurement.

### 4. Measure
- Run for the minimum sample size (see below).
- Check results only after the minimum duration has elapsed.
- Do not stop a test early just because it "looks good."

## Minimum Sample Size

Use these minimums before drawing conclusions:

| Baseline Conversion Rate | Minimum Detectable Effect | Required Sample Per Variant |
|--------------------------|---------------------------|---------------------------|
| 1% | 20% relative (1.0% -> 1.2%) | ~16,000 sessions |
| 2% | 15% relative (2.0% -> 2.3%) | ~9,500 sessions |
| 3% | 10% relative (3.0% -> 3.3%) | ~11,500 sessions |
| 5% | 10% relative (5.0% -> 5.5%) | ~7,000 sessions |

Use an online calculator (e.g., Evan Miller's) for exact numbers based on the client's baseline.

**Minimum test duration:** 14 days (to capture weekly cycles), regardless of traffic volume.

## Statistical Significance Threshold

- **Required confidence level: 95%** (p-value < 0.05).
- Use a two-tailed test unless there is strong prior evidence for a directional hypothesis.
- If the result is not significant after reaching the required sample size, declare it inconclusive — do not extend the test indefinitely.

## Sign-Off Process

1. **Analyst** reviews data and writes the experiment report.
2. **Lead** reviews methodology and confirms statistical validity.
3. **Client** approves rolling the winner to 100% (if client approval is required per their CLAUDE.md).
4. Winning variant is implemented in the theme code and the A/B test is removed.

## Documentation Requirements

For every experiment, record the following in the client's `cro/experiments/` folder:

```
Filename: YYYY-MM-DD-{short-description}.md

# Experiment: {Title}

## Hypothesis
{hypothesis statement}

## Variant Description
{what changed}

## Metrics
- Primary: {metric}
- Guardrail: {metrics}

## Results
- Duration: {start} to {end}
- Sample size: {n} per variant
- Control: {rate}
- Variant: {rate}
- Confidence: {%}
- Result: Winner / Loser / Inconclusive

## Decision
{Ship / Revert / Iterate}

## Learnings
{What we learned, applicable to future experiments}
```

## Quarterly Review

At the end of each quarter:

1. Compile all experiment results.
2. Calculate cumulative estimated revenue impact.
3. Identify patterns (what types of changes tend to win).
4. Update the testing roadmap for the next quarter.
