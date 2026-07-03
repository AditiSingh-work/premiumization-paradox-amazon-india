-- ANALYSIS 1: Average discount % by brand tier
SELECT Brand_Tier, 
       ROUND(AVG(Discount_Percent), 2) AS Avg_Discount_Percent,
       COUNT(*) AS Num_Products
FROM "T-shirts and Polos dataset"
GROUP BY Brand_Tier
ORDER BY Avg_Discount_Percent DESC;

-- ANALYSIS 2: Average rating and review volume by brand tier
SELECT Brand_Tier, 
       ROUND(AVG(ratings), 2) AS Avg_Rating,
       ROUND(AVG(no_of_ratings), 0) AS Avg_Review_Count
FROM "T-shirts and Polos dataset"
WHERE ratings IS NOT NULL
GROUP BY Brand_Tier;

-- ANALYSIS 3: Heavy discount rate (50%+ off) by brand tier
SELECT Brand_Tier,
       SUM(CASE WHEN Discount_Percent >= 50 THEN 1 ELSE 0 END) AS Heavy_Discount_Count,
       COUNT(*) AS Total_Products,
       ROUND(100.0 * SUM(CASE WHEN Discount_Percent >= 50 THEN 1 ELSE 0 END) / COUNT(*), 1) AS Heavy_Discount_Percent
FROM "T-shirts and Polos dataset"
GROUP BY Brand_Tier
ORDER BY Heavy_Discount_Percent DESC;
