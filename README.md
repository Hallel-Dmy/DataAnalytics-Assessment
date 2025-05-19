# Data Analytics Assessment

This repository contains my solutions for the Data Analyst SQL proficiency assessment. Each solution addresses a specific business scenario using SQL queries to extract meaningful insights from the company database.

## Question 1: High-Value Customers with Multiple Products

### Approach
For this question, my goal was to identify customers who use both savings and investment products. I approached this by:

1. Joining the user, plan, and savings tables to access customer and transaction data
2. Using `COUNT(DISTINCT CASE WHEN...)` to separately count savings and investment plans
3. Adding subqueries in the WHERE clause to filter for customers who have both plan types
4. Converting monetary values from kobo to Naira for better readability

The challenge was making sure I correctly identified customers with both types of plans. I accomplished this by using both the HAVING clause with counts and the WHERE clause with subqueries to ensure complete accuracy.

## Question 2: Transaction Frequency Analysis

### Approach
To analyze transaction frequency patterns, I used a multi-step process:

1. First, I created a CTE (Common Table Expression) to calculate transactions per customer per month
2. Next, I created a second CTE to average these monthly counts for each customer
3. Finally, I applied the business segmentation rules (High/Medium/Low) and aggregated the results

My biggest challenge was determining the right column to use for transaction dates. After examining the table structure, I confirmed that `transaction_date` was the appropriate field to track when transactions occurred.

The query structure keeps calculations separate and focused, making it easier to maintain and adjust if segmentation thresholds change in the future.

## Question 3: Account Inactivity Alert

### Approach
For identifying inactive accounts, my approach was to:

1. Join plan data with savings transactions using a LEFT JOIN (crucial to include accounts with no transactions)
2. Group by plan ID and calculate the most recent transaction date
3. Use DATEDIFF to calculate inactivity in days
4. Apply appropriate filters to focus only on active accounts

A key insight was using the LEFT JOIN rather than INNER JOIN to ensure we captured accounts that have never had transactions (which would be the most inactive of all).

## Question 4: Customer Lifetime Value (CLV) Estimation

### Approach
Calculating CLV required careful consideration of both transaction patterns and customer tenure:

1. I used TIMESTAMPDIFF to calculate tenure in months from customer creation date
2. Calculated total transactions and transaction value for each customer
3. Applied the specified CLV formula: (transactions/tenure) * 12 * avg_profit_per_transaction
4. Filtered out customers with less than 1 month tenure to avoid skewed results

The most challenging aspect was handling the profit calculation correctly. I made sure to convert kobo to Naira first (dividing by 100) and then apply the 0.1% profit margin as specified.

## Challenges and Solutions

### Understanding Database Structure
Without complete documentation, I had to explore the table structure carefully. I examined the column names and relationships between tables, particularly focusing on how the plans_plan table connects to both users and transactions.

### Data Type Conversions
Working with monetary values required attention to detail. The values stored in kobo needed conversion to Naira for meaningful business analysis. I consistently applied the division by 100 to present values in the expected format.

### Date Calculations
Working with dates required using appropriate MySQL functions. I used DATE_FORMAT to group by month, DATEDIFF to calculate days of inactivity, and TIMESTAMPDIFF to calculate customer tenure in months.

### Edge Cases
I made sure to handle edge cases like:
- New customers with limited history
- Accounts with no transaction history
- Potential division by zero in calculations
