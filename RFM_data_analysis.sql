SELECT * FROM [dbo].[sales_data_sample];

-- Checking status list
SELECT DISTINCT STATUS 
FROM  [dbo].[sales_data_sample];

SELECT SUM(SALES) revenue, STATUS 
FROM  [dbo].[sales_data_sample]
GROUP BY STATUS;


-- Summarize sales amount by productline
SELECT PRODUCTLINE, SUM(sales) Revenue 
FROM [dbo].[sales_data_sample]
WHERE STATUS NOT IN ('Shipped')
GROUP BY PRODUCTLINE 
ORDER BY 2 desc;


-- Total sales amount by year
SELECT YEAR_ID, SUM(sales) Revenue 
FROM [dbo].[sales_data_sample]
WHERE STATUS NOT IN ('Shipped')
GROUP BY YEAR_ID 
ORDER BY 2 desc;

-- Monthly Highest Sales by Year
SELECT YEAR_ID, MONTH_ID, revenue
FROM (
	SELECT YEAR_ID, MONTH_ID, SUM(SALES) revenue,
			RANK() OVER(PARTITION BY YEAR_ID ORDER BY SUM(SALES) DESC) AS rank_sales
	FROM [dbo].[sales_data_sample]
	WHERE STATUS NOT IN ('Shipped')
	GROUP BY YEAR_ID, MONTH_ID
	) AS ranked_sales
WHERE rank_sales = 1
ORDER BY YEAR_ID, revenue DESC;


-- Total sales amount by size
SELECT DEALSIZE, SUM(sales) Revenue 
FROM [dbo].[sales_data_sample]
WHERE STATUS NOT IN ('Shipped')
GROUP BY DEALSIZE 
ORDER BY 2 desc;



-- Most product category sales by year
SELECT YEAR_ID, PRODUCTLINE, Revenue
FROM (
	SELECT YEAR_ID, PRODUCTLINE, SUM(SALES) Revenue, 
		RANK() OVER(PARTITION BY YEAR_ID ORDER BY SUM(SALES) DESC ) AS rank_by_sales
	FROM [dbo].[sales_data_sample]
	GROUP BY YEAR_ID, PRODUCTLINE
	) AS Products_sales
WHERE rank_by_sales = 1
ORDER BY YEAR_ID 
;


-- Customer who has highest purchase amount and smallest purchase amount
SELECT MAX(Revenue) max_amount, MIN(Revenue) min_amount
FROM	
	(
	SELECT CUSTOMERNAME, SUM(SALES) Revenue
	FROM  [dbo].[sales_data_sample]
	GROUP BY CUSTOMERNAME
	) as total_sales;




DROP TABLE IF EXISTS #temp_tb_rfm;
WITH rfm AS
(
	-- Checking Recency Frequency Monetary 
	SELECT
		CUSTOMERNAME,
		max(ORDERDATE) last_order_date,
		AVG(SALES) AvgMonetary,
		DATEDIFF(DD, 
				MAX(ORDERDATE),	
				(SELECT MAX(ORDERDATE) FROM [dbo].[sales_data_sample])) recency, 
		COUNT(ORDERNUMBER) frequency,
		SUM(SALES) monetary
		FROM [dbo].[sales_data_sample]
	GROUP BY CUSTOMERNAME
),
rfm_cal as 
(
	SELECT r.*,
			NTILE(5) OVER( ORDER BY recency desc ) cal_recency,
			NTILE(5) OVER( ORDER BY frequency ) cal_frequency,
			NTILE(5) OVER( ORDER BY monetary ) cal_monetary
	FROM rfm r
)

SELECT r.*, 
	cast(cal_recency as varchar) +
	cast(cal_frequency as varchar) +
	cast(cal_monetary as varchar) cast_rfm
INTO #temp_tb_rfm -- create temporary table
FROM rfm_cal r;


-- run temporary table with RFM segment
SELECT CUSTOMERNAME, recency, frequency, monetary, cal_recency, cal_frequency, cal_monetary, 
	CASE
		WHEN cal_recency IN (3,2,1) AND cal_frequency IN (2,1) AND cal_monetary IN (5,4,3,2,1)
			THEN 'churned_customer' 
	--Inactive customers who haven't bought in a long time. Try win-back campaigns.
	
		WHEN cal_recency IN (1) AND cal_frequency IN (5,4,3) AND cal_monetary IN (5,4,3,2)
			THEN 'need_attention'
		WHEN cal_recency IN (3,2) AND cal_frequency IN (5,4,3,2) AND cal_monetary IN (5,4,3,2)
			THEN 'need_attention'
	--Customers who used to buy often but haven't purchased recently. Send reactivation emails.
		
		WHEN cal_recency IN (5,4) AND cal_frequency IN (3,2,1) AND cal_monetary IN (3,2,1)
			THEN 'new_customer'
	--New customers with recent and frequent purchases. Nurture them.

		WHEN cal_recency IN (5,4,3) AND cal_frequency IN (4,3) AND cal_monetary IN (4,3)
			THEN 'potential_loyalists'
	-- Regular buyers who spend consistently. Offer loyalty rewards.

		WHEN cal_recency IN (5,4,3) AND cal_frequency IN (5,4,3) AND cal_monetary IN (5,4)
			THEN 'cant_lose'
	-- Most loyal, frequent, and high-spending customers. Give them VIP offers.

	END as rfm_segment
FROM #temp_tb_rfm
ORDER BY cast_rfm desc
;
