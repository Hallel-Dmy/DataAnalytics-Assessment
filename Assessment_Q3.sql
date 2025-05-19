-- Question 3: Account Inactivity Alert
-- Find accounts with no transactions in over a year

SELECT 
    p.id AS plan_id,
    p.owner_id,
    -- Determine plan type
    CASE 
        WHEN p.is_regular_savings = 1 THEN 'Savings'
        WHEN p.is_a_fund = 1 THEN 'Investment'
        ELSE 'Other'
    END AS type,
    -- Find most recent transaction
    MAX(s.transaction_date) AS last_transaction_date,
    -- Calculate days since last transaction
    DATEDIFF(CURRENT_DATE(), MAX(s.transaction_date)) AS inactivity_days
FROM 
    plans_plan p
LEFT JOIN 
    savings_savingsaccount s ON p.id = s.plan_id
WHERE 
    -- Filter for active plans only
    p.status_id = 1  -- Active status
    AND p.is_archived = 0
    AND p.is_deleted = 0
GROUP BY 
    p.id, p.owner_id
HAVING 
    -- Identify accounts with no activity in past year
    last_transaction_date IS NULL OR inactivity_days > 365
ORDER BY 
    inactivity_days DESC;  -- Show most inactive first