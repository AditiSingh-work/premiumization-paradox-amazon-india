# The Premiumization Paradox

**Full write-up:** [Read on Medium](https://medium.com/@2003adiaditi/54755f2be503)
**Live dashboard:** [Tableau Public](https://public.tableau.com/shared/NMCKHG7M3?:display_count=n&:origin=viz_share_link)

## Business Question
Is premiumization in Indian fashion e-commerce a real shift toward
higher-quality, brand-driven purchasing, or is it mostly a narrative
while consumers remain discount-driven?

## Data
19,104 product listings scraped from Amazon India's T-Shirts & Polos
category (public Kaggle dataset). Listing-level data: product name,
brand (embedded in title), ratings, number of ratings, discounted
price, MRP.

## Methodology
- Excel: brand extraction from free-text titles, data cleaning
- SQLite (DB Browser): brand tier classification via CASE logic,
  aggregation and comparison queries
- Tableau Public: dashboard visualization

## Key Findings
- Premium brands discount almost identically to unbranded sellers
  (54.7% vs 55.4% average discount)
- Customer ratings show no premium "halo" (3.83–3.91 across all tiers)
- Premium brands are meaningfully less likely to go into deep
  discounting (55% cross the 50%+ threshold vs 65–66% for other tiers)

## Repo Structure
- `/sql` — brand classification and aggregation queries
- `/excel` — cleaning and feature engineering workbook
- `/dashboard` — Tableau dashboard screenshot

## Limitations
Listing-level data, not transaction data — reflects seller pricing
and discounting behavior, not individual purchase decisions.

## Author
Aditi Singh — clinical psychology postgraduate transitioning into
consumer insights and market research, Delhi NCR.
