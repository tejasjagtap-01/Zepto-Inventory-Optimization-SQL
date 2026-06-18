Zepto Inventory Optimization \& Analytics (SQL)



📌 Project Overview

Efficient inventory management and stock optimization are critical to the success of quick-commerce platforms. This project focuses on analyzing an e-commerce inventory dataset simulating Zepto's operational dynamics. Using advanced PostgreSQL queries, the analysis extracts actionable business insights regarding stock health, revenue leakages, pricing strategies, and portfolio segmentation.



The goal of this analysis is to transform raw inventory data into strategic decisions that balance consumer demand with operational efficiency.







🛠️ Tech Stack \& Concepts Used

&#x20;   Database Management System:\*\* PostgreSQL / pgAdmin 4

&#x20;   SQL Concepts Applied:

&#x20; ---------                        Advanced Aggregations \& Filters

&#x20; ---------                        Common Table Expressions (CTEs)

&#x20; ---------                        Window Functions (Ranking and Partitioning)

&#x20; ---------                        Conditional Logic (`CASE WHEN` statements)

&#x20; ---------                        String \& Data Type Manipulations (Unit conversions)



## 📊DATA EXPLOARATION (EDA)
**Data Exploration**
Null Values
```sql

--Sample Data
SELECT * FROM zepto 
limit 15;

--Null Values
SELECT * FROM zepto 
WHERE name IS NULL
OR
category IS NULL
OR
mrp IS NULL
OR
discountpercent IS NULL
OR
availablequantity IS NULL
OR
discountedsellingprice IS NULL
OR
weightingms IS NULL
OR
outofstock IS NULL
OR
quantity IS NULL;
```

**Different Product Categories**
```sql
SELECT DISTINCT category
FROM zepto
ORDER BY category;
```

**Product In_Stock vs Out_Of_Stock**
```sql
SELECT outOfStock , count(sku_id)
FROM zepto
GROUP BY outOfStock;
```

**Prodcut names present multiple times**
```sql
SELECT name,count(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name 
Having count (sku_id) > 1
order by count(sku_id) DESC;
```



## 📊 Business Questions Addressed



1\. Pricing \& Value Optimization

--------- Q1. Top 10 Best-Value Products: Identified the top 10 products offering the highest consumer value based on maximum discount percentages.
```sql
SELECT Distinct name, mrp, discountPercent From zepto
Order By discountPercent DESC
limit 10;
```


--------- Q4. High MRP / Low Discount Auditing: Isolated high-ticket items (MRP > ₹500) paired with low discount incentives (< 10%) to evaluate competitive pricing strategies.
```sql
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;
```


--------- Q6. Unit Economics (Price per Gram): Standardized product weights to calculate price-per-gram for items above 100g, sorting them by best-value efficiency to find high-margin vs. consumer-friendly products.
```sql
SELECT Distinct name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice / weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram DESC;
```


2\. Inventory Health \& Revenue Leakage

--------- Q2. Revenue Bottlenecks: Discovered high-value (High MRP) items that are currently \*\*Out of Stock\*\*, pinpointing immediate revenue leakage and supply chain gaps.
```sql
SELECT DISTINCT name, mrp
From zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER By mrp DESC;
```



--------- Q3. Estimated Revenue per Category: Calculated forecasted revenue metrics across different product categories to determine which segments drive the most financial value.
```sql
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue 
FROM zepto
GROUP BY category 
ORDER BY total_revenue;
```



--------- Q8. Logistics \& Storage Load: Calculated the total cumulative inventory weight per category to help warehouse operations optimize physical shelf-space allocation.
```sql
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category 
ORDER BY total_weight;
```



3\. Strategic Product Segmentation

--------- Q5. Top 5 High-Discount Categories: Identified the top 5 product categories offering the highest average discount percentages to understand cross-subsidization strategies.
```sql
SELECT category,
round(AVG(discountPercent),2) AS avg_discount
FROM zepto 
GROUP BY category
ORDER BY avg_discount DESC
limit 5;
```



--------- Q7. Velocity \& Volume Tiers: Engineered a categorization framework to dynamically group inventory into operational tiers (Low, Medium, Bulk) for targeted marketing and stock clearing.
```sql
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'LOW'
     WHEN weightInGms < 5000 THEN 'MEDIUM'
	 ELSE 'BULK'
	 END AS weight_category
FROM zepto;
```






## 📈 Key Business Takeaways

Stockout Minimization: Prioritizing restocking schedules for the high-MRP items identified in the out-of-stock audit will directly recover trapped revenue.



Data-Driven Storage Allocation: Heavy-weight categories identified in the total weight analysis can be relocated to optimal warehouse zones to streamline pick-and-pack times.



Margin Guardrails: Segmenting items into Low, Medium, and Bulk tiers allows marketing teams to apply aggressive discounts on high-volume products while protecting margins on high-value niche items.







## 🚀 How to Use This Repository

1\. `zepto\_inventory\_analysis.sql`: Contains the full database queries corresponding to questions 1 through 8.

2\. To replicate the analysis, clone this repository, import your dataset into pgAdmin, and run the structured queries.

