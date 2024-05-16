use saklia;

SELECT
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    COUNT(DISTINCT customer_id) AS active_customers
FROM
    payment
GROUP BY
    DATE_FORMAT(payment_date, '%Y-%m');


SELECT 
    DATE_FORMAT(payment_date, '%Y-%m') AS month,
    COUNT(DISTINCT customer_id) AS active_customers,
    LAG(COUNT(DISTINCT customer_id)) OVER (ORDER BY DATE_FORMAT(payment_date, '%Y-%m')) AS active_customers_previous_month
FROM payment
GROUP BY DATE_FORMAT(payment_date, '%Y-%m');


SELECT 
    month,
    active_customers,
    active_customers_previous_month,
    ROUND(((active_customers - active_customers_previous_month) / NULLIF(active_customers_previous_month, 0)) * 100, 2) AS percentage_change
FROM (
    SELECT 
        DATE_FORMAT(payment_date, '%Y-%m') AS month,
        COUNT(DISTINCT customer_id) AS active_customers,
        LAG(COUNT(DISTINCT customer_id)) OVER (ORDER BY DATE_FORMAT(payment_date, '%Y-%m')) AS active_customers_previous_month
    FROM payment
    GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
) AS monthly_active_customers;


SELECT 
    month,
    active_customers,
    previous_month_active_customers,
    retained_customers
FROM (
    SELECT 
        month,
        active_customers,
        previous_month_active_customers,
        (active_customers - previous_month_active_customers) AS retained_customers
    FROM (
        SELECT 
            DATE_FORMAT(payment_date, '%Y-%m') AS month,
            COUNT(DISTINCT customer_id) AS active_customers,
            LAG(COUNT(DISTINCT customer_id)) OVER (ORDER BY DATE_FORMAT(payment_date, '%Y-%m')) AS previous_month_active_customers
        FROM payment
        GROUP BY DATE_FORMAT(payment_date, '%Y-%m')
    ) AS subquery
) AS subquery2;

