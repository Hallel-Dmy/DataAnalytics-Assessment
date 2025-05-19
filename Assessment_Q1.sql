-- Question 1: High-Value Customers with Multiple Products
-- Identifying customers who have both savings and investment plans

-- Find customers with funded savings and investment plans
SELECT 
    cu.id AS owner_id,
    CONCAT(cu.first_name, ' ', cu.last_name) AS name,
    -- Count savings plans
    COUNT(DISTINCT CASE WHEN p.is_regular_savings = 1 THEN p.id END) AS savings_count,
    -- Count investment plans
    COUNT(DISTINCT CASE WHEN p.is_a_fund = 1 THEN p.id END) AS investment_count,
    -- Calculate total deposits (convert from kobo to Naira)
    SUM(s.confirmed_amount) / 100 AS total_deposits
FROM 
    users_customuser cu
JOIN 
    plans_plan p ON cu.id = p.owner_id
JOIN 
    savings_savingsaccount s ON p.id = s.plan_id
WHERE 
    -- Make sure we only include customers with both plan types
    cu.id IN (
        SELECT owner_id FROM plans_plan WHERE is_regular_savings = 1
    )
    AND cu.id IN (
        SELECT owner_id FROM plans_plan WHERE is_a_fund = 1
    )
GROUP BY 
    cu.id, cu.first_name, cu.last_name
HAVING 
    savings_count > 0 AND investment_count > 0
ORDER BY 
    total_deposits DESC;