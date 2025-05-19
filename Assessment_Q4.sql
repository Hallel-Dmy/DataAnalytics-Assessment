-- Question 4: Customer Lifetime Value (CLV) Estimation
-- Calculate CLV based on transaction history and tenure

WITH customer_metrics AS (
    SELECT 
        cu.id AS customer_id,
        CONCAT(cu.first_name, ' ', cu.last_name) AS name,
        -- Calculate how long customer has been with us (in months)
        TIMESTAMPDIFF(MONTH, cu.created_on, CURRENT_DATE()) AS tenure_months,
        -- Count total number of transactions
        COUNT(s.id) AS total_transactions,
        -- Sum total transaction value (convert from kobo to Naira)
        SUM(s.confirmed_amount) / 100 AS total_transaction_value,
        -- Calculate total profit using 0.1% of transaction value
        (SUM(s.confirmed_amount) / 100) * 0.001 AS total_profit
    FROM 
        users_customuser cu
    JOIN 
        plans_plan p ON cu.id = p.owner_id
    JOIN 
        savings_savingsaccount s ON p.id = s.plan_id
    WHERE 
        s.confirmed_amount > 0  -- Only include actual deposits
    GROUP BY 
        cu.id, cu.first_name, cu.last_name, cu.created_on
    HAVING 
        tenure_months >= 1  -- Filter out very new customers
)

SELECT 
    customer_id,
    name,
    tenure_months,
    total_transactions,
    -- CLV calculation using the specified formula
    ROUND(
        (total_transactions / tenure_months) * 12 * (total_profit / total_transactions), 
        2
    ) AS estimated_clv
FROM 
    customer_metrics
ORDER BY 
    estimated_clv DESC;  -- Show highest value customers first