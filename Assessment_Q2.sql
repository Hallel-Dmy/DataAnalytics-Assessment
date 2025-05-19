-- Question 2: Transaction Frequency Analysis
-- Analyze how often customers transact for segmentation

-- Step 1: Calculate transactions per customer per month
WITH customer_monthly_transactions AS (
    SELECT 
        cu.id AS customer_id,
        -- Group by year-month
        DATE_FORMAT(s.transaction_date, '%Y-%m') AS month_year,
        COUNT(s.id) AS transaction_count
    FROM 
        users_customuser cu
    JOIN 
        plans_plan p ON cu.id = p.owner_id
    JOIN 
        savings_savingsaccount s ON p.id = s.plan_id
    WHERE 
        s.confirmed_amount > 0  -- Only count actual deposits
    GROUP BY 
        cu.id, month_year
),
-- Step 2: Calculate average monthly transactions per customer
customer_avg_transactions AS (
    SELECT
        customer_id,
        AVG(transaction_count) AS avg_transactions_per_month
    FROM 
        customer_monthly_transactions
    GROUP BY 
        customer_id
)

-- Step 3: Categorize customers by frequency and count them
SELECT 
    CASE 
        WHEN avg_transactions_per_month >= 10 THEN 'High Frequency'
        WHEN avg_transactions_per_month >= 3 THEN 'Medium Frequency'
        ELSE 'Low Frequency'
    END AS frequency_category,
    COUNT(customer_id) AS customer_count,
    ROUND(AVG(avg_transactions_per_month), 1) AS avg_transactions_per_month
FROM 
    customer_avg_transactions
GROUP BY 
    frequency_category
ORDER BY 
    -- Custom sort to ensure logical order
    CASE 
        WHEN frequency_category = 'High Frequency' THEN 1
        WHEN frequency_category = 'Medium Frequency' THEN 2
        ELSE 3
    END;