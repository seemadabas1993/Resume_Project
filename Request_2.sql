#Generate a report that provides an overview of number of stores in each city. 
#the results will be sorted in descending order of store counts allowing us to identify the cities 
#with the highest store presence. The report includes two essential fields city and store count, 
#which will assist in optimising our retail operation

USE retail_events_db;
SELECT city, 
COUNT(store_id) as Stores_Count
FROM dim_stores
GROUP BY city
ORDER BY Stores_count DESC;
