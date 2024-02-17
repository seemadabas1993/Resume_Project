#Provide a list of products with the base price greator than 500 and that are featured in promo type of BOGOF (By One Get One Free) 
#this information will help us identify high value products that are currently being heavily discounted 
#which can be useful for evaluting our pricing and promotion stratgies.

USE retail_events_db;
SELECT 
p.product_code, 
p.product_name, 
f.base_price, 
f.promo_type
FROM dim_products p 
JOIN fact_events f 
ON p.product_code = f.product_code
WHERE f.base_price > 500
  AND f.promo_type = 'BOGOF';
