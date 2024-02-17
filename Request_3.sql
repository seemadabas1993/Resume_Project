#Generate a report that displays each campaign along with the total revenue generated before and after 
#the campaign. The report include three key field like campaign name, total revenue before promotion, 
#total revenue after promotion. This report should help in evaluating the financial impact of our 
#promotional campaigns. Display the value in millions.


USE retail_events_db;

-- Create a temporary table to calculate revenue before promotion
CREATE TEMPORARY TABLE temp_revenue_before_promo_final AS
SELECT
    d.campaign_id,
    d.campaign_name,
    SUM(p.base_price * p.Sold_quantity_before_promo) / 1000000 AS total_revenue_before_promo_final
FROM
    dim_campaigns d
JOIN
    fact_events p ON d.campaign_id = p.campaign_id
GROUP BY
    d.campaign_id, d.campaign_name;


-- Create a temporary table to calculate revenue after promotion
CREATE TEMPORARY TABLE temp_revenue_after_promo AS
SELECT
    d.campaign_id,
    d.campaign_name,
    SUM(p.base_price * p.Sold_quantity_after_promo) / 1000000 AS total_revenue_after_promo
FROM
    dim_campaigns d
JOIN
    fact_events p ON d.campaign_id = p.campaign_id
GROUP BY
    d.campaign_id, d.campaign_name;

-- Final report combining both total revenues
SELECT
    d.campaign_id,
    d.campaign_name,
    COALESCE(rbp.total_revenue_before_promo, 0) AS total_revenue_before_promo,
    COALESCE(rap.total_revenue_after_promo, 0) AS total_revenue_after_promo
FROM
    dim_campaigns d
LEFT JOIN
    temp_revenue_before_promo rbp ON d.campaign_id = rbp.campaign_id
LEFT JOIN
    temp_revenue_after_promo rap ON d.campaign_id = rap.campaign_id;
