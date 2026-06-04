create table zepto(
sku_id SERIAL Primary Key,
category VARCHAR(100),
name VARCHAR(100) not null,
mrp NUMERIC(8,2),
discountPercent NUMERIC(5,2),
availableQuantity INTEGER,
discountedSellingPrice NUMERIC(8,2),
weightInGms INTEGER,
outOfStock BOOLEAN,
quantity INTEGER
);

--Data Exploration
SELECT COUNT (*) FROM zepto;

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

--Different Product Categories 
SELECT DISTINCT category
FROM zepto
ORDER BY category;


--Product In_Stock vs Out_Of_Stock
SELECT outOfStock , count(sku_id)
FROM zepto
GROUP BY outOfStock;


--Prodcut names present multiple times
SELECT name,count(sku_id) as "Number of SKUs"
FROM zepto
GROUP BY name 
Having count (sku_id) > 1
order by count(sku_id) DESC;


--Data Cleaning
SELECT * From zepto 
WHERE mrp = 0 or discountedSellingPrice = 0;

DELETE From zepto
WHERE mrp = 0;

--Convert Paise into Rupees
UPDATE zepto
SET mrp = mrp / 100.00,
discountedSellingPrice = discountedSellingPrice / 100.00;

SELECT mrp,discountedSellingPrice FROM zepto;

--Question That Useful For Understanding Business and The efficiency of Business

--Q1. Find the top 10 best-value products based on the discount percentage.
SELECT Distinct name, mrp, discountPercent From zepto
Order By discountPercent DESC
limit 10;

--Q2. What are the Products with High MRP but Out of Stock. Mrp is more than 300.
SELECT DISTINCT name, mrp
From zepto
WHERE outOfStock = TRUE and mrp > 300
ORDER By mrp DESC;

--Q3. Calculate Estimated Revenue for each category
SELECT category,
SUM(discountedSellingPrice * availableQuantity) AS total_revenue 
FROM zepto
GROUP BY category 
ORDER BY total_revenue;

--Q4. Find all products where MRP is greater than ₹500 and discount is less than 10%.
SELECT DISTINCT name, mrp, discountPercent
FROM zepto
WHERE mrp > 500 AND discountPercent < 10
ORDER BY mrp DESC, discountPercent DESC;

--Q5. Identify the top 5 categories offering the highest average discount percentage.
SELECT category,
round(AVG(discountPercent),2) AS avg_discount
FROM zepto 
GROUP BY category
ORDER BY avg_discount DESC
limit 5;

--Q6. Find the price per gram for products above 100g and sort by best value.
SELECT Distinct name, weightInGms, discountedSellingPrice,
ROUND(discountedSellingPrice / weightInGms,2) AS price_per_gram
FROM zepto
WHERE weightInGms >= 100
ORDER BY price_per_gram DESC;

--Q7. Group the products into categories like Low, Medium, Bulk.
SELECT DISTINCT name, weightInGms,
CASE WHEN weightInGms < 1000 THEN 'LOW'
     WHEN weightInGms < 5000 THEN 'MEDIUM'
	 ELSE 'BULK'
	 END AS weight_category
FROM zepto;

--Q8. What is the Total Inventory Weight Per Category
SELECT category,
SUM(weightInGms * availableQuantity) AS total_weight
FROM zepto
GROUP BY category 
ORDER BY total_weight;

SELECT * From zepto;
