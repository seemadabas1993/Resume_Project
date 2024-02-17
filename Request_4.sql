#Produce a report that calculates the incremental sold quantity (ISU%) for each category during Diwali campaign. 
#Additionally provide rankings for the categories based on their ISU%. The report will include three key fields: 
#category, isu% and rank order. This information will assist in assessing the category wise success and 
#impact of the Diwali campaign on incremental sales.
#Note: ISU % is calculated as the percentage increased/decreased in quantity sold (after promo) 
#compared to quantity sold before promo.


USE retail_events_db;
-- Calculate incremental sold quantity (ISU%) for each category during Diwali campaign
WITH Diwali_Campaign AS (
    SELECT
        pc.category,
        SUM(fe.sold_quantity_after_promo) AS total_quantity_after_promo,
        SUM(fe.sold_quantity_before_promo) AS total_quantity_before_promo
    FROM
        fact_events fe
    JOIN
        dim_products pc ON fe.product_code = pc.product_code
    WHERE
        fe.campaign_id = 'CAMP_DIW_01'
    GROUP BY
        pc.category
)

-- Calculate ISU%
SELECT
    category,
    CASE
        WHEN total_quantity_before_promo = 0 THEN NULL -- Avoid division by zero
        ELSE ((total_quantity_after_promo - total_quantity_before_promo) / total_quantity_before_promo) * 100
    END AS isu_percentage,
    RANK() OVER (ORDER BY ((total_quantity_after_promo - total_quantity_before_promo) / total_quantity_before_promo) DESC) AS rank_order
FROM
    Diwali_Campaign
ORDER BY
    isu_percentage DESC; -- Order by ISU% in descending order to get the highest first
