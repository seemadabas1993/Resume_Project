USE retail_events_db;
WITH ProductIncrementalRevenue AS (
    SELECT
        dp.product_name,
        dp.category,
        SUM(fe.base_price * (fe.sold_quantity_after_promo - fe.sold_quantity_before_promo)) AS total_incremental_revenue,
        SUM(fe.base_price * fe.sold_quantity_before_promo) AS total_revenue_before_promo
    FROM
        fact_events fe
    JOIN
        dim_products dp ON fe.product_code = dp.product_code
    GROUP BY
        dp.product_name, dp.category
)

-- Calculate IR% and rankings
SELECT
    product_name,
    category,
    CASE
        WHEN total_revenue_before_promo = 0 THEN NULL 
        ELSE (total_incremental_revenue / total_revenue_before_promo) * 100
    END AS ir_percentage
FROM
    ProductIncrementalRevenue
ORDER BY
    ir_percentage DESC
LIMIT 5;
