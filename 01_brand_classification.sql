-- STEP 1: Add a new column to hold the brand tier label
ALTER TABLE "T-shirts and Polos dataset" ADD COLUMN Brand_Tier TEXT;

-- STEP 2: First attempt at classifying brands into tiers
UPDATE "T-shirts and Polos dataset"
SET Brand_Tier = CASE
    WHEN Brand_Fixed IN ('U.S. Polo Assn.', 'Tommy Hilfiger', 'Puma', 'Adidas', 'Reebok', 'Jockey', 'Levi''s') THEN 'Premium'
    WHEN Brand_Fixed IN ('Van Heusen', 'Allen Solly', 'Peter England', 'Pepe Jeans', 'United Colors of Benetton', 'Arrow', 'Wrangler', 'Lee', 'Spykar', 'Jack & Jones') THEN 'Mid-Premium'
    WHEN Brand_Fixed IN ('Amazon Brand', 'Bewakoof', 'Campus Sutra', 'Hangout', 'VIKCLIQUE', 'Kalt', 'INDISSH', 'ADRO', 'Creativit', 'Bigbanana', 'Caseria', 'LEOTUDE', 'EYEBOGLER', 'Toodlegram') THEN 'Mass/Value'
    ELSE 'Unclassified'
END;

-- STEP 3: Check how many products landed in each tier
SELECT Brand_Tier, COUNT(*) FROM "T-shirts and Polos dataset" GROUP BY Brand_Tier;

-- STEP 4: Find the most common brands still unclassified
SELECT Brand_Fixed, COUNT(*) AS Num_Products
FROM "T-shirts and Polos dataset"
WHERE Brand_Tier = 'Unclassified'
GROUP BY Brand_Fixed
ORDER BY Num_Products DESC
LIMIT 40;

-- STEP 5: Add a column that extracts the first two words of the product name
-- (helps catch multi-word brand names like "Van Heusen" or "Red Tape")
ALTER TABLE "T-shirts and Polos dataset" ADD COLUMN Brand_TwoWord TEXT;

UPDATE "T-shirts and Polos dataset"
SET Brand_TwoWord = 
    SUBSTR(name, 1, 
        CASE 
            WHEN INSTR(SUBSTR(name, INSTR(name, ' ')+1), ' ') > 0 
            THEN INSTR(name, ' ') + INSTR(SUBSTR(name, INSTR(name, ' ')+1), ' ') - 1
            ELSE LENGTH(name)
        END
    );

-- STEP 6: Inspect full product names for ambiguous single-word brand matches
SELECT DISTINCT name
FROM "T-shirts and Polos dataset"
WHERE Brand_Fixed IN ('The', 'Red', 'Max', 'JJ', 'Classic', 'Campus', 'Marks', 'Scott', 'Duke', 'Quote', 'Being', 'Bon', 'THE', 'Men''s', 'Men', 'Colorplus', 'WC')
LIMIT 60;

-- STEP 7: Final, refined brand tier classification using both single-word
-- and two-word brand matching
UPDATE "T-shirts and Polos dataset"
SET Brand_Tier = CASE
    WHEN Brand_Fixed IN ('U.S. Polo Assn.', 'Tommy Hilfiger', 'Puma', 'Adidas', 'Reebok', 'Jockey', 'Levi''s', 'Nike', 'AEROPOSTALE') THEN 'Premium'
    WHEN Brand_Fixed IN ('Van Heusen', 'Allen Solly', 'Peter England', 'Pepe Jeans', 'United Colors of Benetton', 'Jack & Jones', 'Arrow', 'Wrangler', 'Lee', 'Spykar', 'Parx', 'blackberrys', 'VIMAL', 'Proline') THEN 'Mid-Premium'
    WHEN Brand_Fixed IN ('Amazon Brand', 'Bewakoof', 'Hangout', 'VIKCLIQUE', 'Kalt', 'INDISSH', 'ADRO', 'Creativit', 'Bigbanana', 'Caseria', 'LEOTUDE', 'EYEBOGLER', 'Toodlegram', 'Max', 'Duke') THEN 'Mass/Value'
    WHEN Brand_TwoWord LIKE 'Red Tape%' THEN 'Mass/Value'
    WHEN Brand_TwoWord LIKE 'Campus Sutra%' THEN 'Mass/Value'
    WHEN Brand_TwoWord LIKE 'Scott International%' THEN 'Mid-Premium'
    WHEN Brand_TwoWord LIKE 'Classic Polo%' THEN 'Mass/Value'
    WHEN Brand_TwoWord LIKE 'JJ TEES%' THEN 'Mass/Value'
    WHEN Brand_TwoWord LIKE 'The Souled%' THEN 'Mass/Value'
    WHEN Brand_TwoWord LIKE 'The Modern%' THEN 'Mass/Value'
    WHEN Brand_TwoWord LIKE 'THE BLAZZE%' THEN 'Mass/Value'
    ELSE 'Unclassified'
END;

-- STEP 8: Rename anything still unclassified to "Unbranded/Long-tail"
-- (this is the 4th tier, kept intentionally rather than dropped)
UPDATE "T-shirts and Polos dataset"
SET Brand_Tier = 'Unbranded/Long-tail'
WHERE Brand_Tier = 'Unclassified';
