

  
 -- a. Develop some general recommendations about the price range, genre, content rating, or any other app characteristics that the company should target.

--app should be free, no cost to consumer
---higher review count
--most populer genre 
--should have a rating >=4, you know the app is already popular
--rating should be everyone for broader audience, more users
--you make half of all in-app purchases
 
  
  

	---b. Develop a Top 10 List of the apps that App Trader should buy based on profitability/return on investment as the sole priority.


SELECT DISTINCT name, app_store_apps.price AS app_price, 
	 app_store_apps.rating AS app_rating , 
	 app_store_apps.content_rating AS app_content_rating, 
	 play_store_apps.price AS play_price, 
	 play_store_apps.rating AS play_rating,
	 primary_genre AS app_genre, 
	 genres AS play_genre,
     play_store_apps.content_rating AS play_content_rating
FROM app_store_apps
	INNER JOIN play_store_apps
	USING (name)
WHERE app_store_apps.review_count::numeric >(select round(avg(review_count ::numeric),2)
	                                             from app_store_apps)
  AND play_store_apps.review_count::numeric > (select round(avg(review_count),2)
	                                             from play_store_apps)
  AND app_store_apps.rating > 4 AND app_store_apps.price = 0.00 
  AND app_store_apps.content_rating = '4+'
ORDER BY play_store_apps.rating DESC, app_store_apps.rating DESC
	


	

	--c. Develop a Top 4 list of the apps that App Trader should buy that are profitable but that also are thematically appropriate for
	--the upcoming Halloween themed campaign.
	
	SELECT name, content_rating, rating, review_count::integer,price::numeric, 
	 case 
	      when price between 0 and 2.50 then 25000
	    else price *10000 
		 end total_cost
FROM app_store_apps
WHERE app_store_apps.name ILIKE '%Halloween%'
  OR app_store_apps.name ILIKE '%HAUNTED%' 
  AND rating >=4.0
  
	UNION
	
SELECT name, content_rating, rating, review_count,price::money::numeric,case 
	      when price::money::numeric between 0 and 2.50 then 25000
	    else price::money::numeric *10000 
		 end total_cost
FROM play_store_apps
WHERE play_store_apps.name ILIKE '%Halloween%' 
  OR play_store_apps.name ILIKE '%HAUNTED%' 
  and rating >=4.0
ORDER BY review_count DESC, rating DESC,price::numeric desc;
	
	

	

	--c. Submit a report based on your findings. The report should include both of your lists of apps along with your analysis of their cost and potential profits. 
	--All analysis work must be done using PostgreSQL, however you may export query results to create charts in Excel for your report.
	
	
--Halloween
WITH table_a AS 
    ( SELECT name,
 			 content_rating,
			 rating,
			 review_count::integer, price::numeric, (4000*12) AS min_gross_rev_year1,
			 CASE WHEN price::numeric BETWEEN 0 AND 2.50 THEN
	         	25000
			 ELSE
	         	price *10000
		     END AS total_cost_year1
        FROM app_store_apps
       WHERE    (app_store_apps.name ILIKE '%Halloween%' 
	          OR app_store_apps.name ILIKE '%HAUNTED%')
	     AND rating >= 4.0
	   UNION ALL
       SELECT name, content_rating, rating, review_count, price::numeric, (4000*12) AS min_gross_rev,
			  CASE WHEN price::numeric BETWEEN 0 AND 2.50 THEN 
	 			25000
			  ELSE 
	          	price::numeric *10000
			  END AS total_cost_year1
         FROM play_store_apps
        WHERE    (play_store_apps.name ILIKE '%Halloween%' 
	          OR  play_store_apps.name ILIKE '%HAUNTED%')
	      and rating >= 4.0
     ORDER BY review_count DESC, rating DESC, price::numeric)
SELECT name, 
       content_rating, 
	   rating, 
	   review_count::integer, 
	   price::numeric,
       ( 4000 * 12 ) AS min_gross_rev_year1,
       total_cost_year1,
       min_gross_rev_year1 - total_cost_year1 AS profit_year1
  FROM table_a;
