USE Portafolio_EcommerceAnalytics;
GO

DROP TABLE IF EXISTS dbo.ecommerce_clean_bi;
GO

CREATE TABLE dbo.ecommerce_clean_bi (
    OrderDate DATE,
    ShipDate DATE,
    DeliveryDays INT,
    Segment VARCHAR(30),
    Category VARCHAR(30),
    SubCategory VARCHAR(30),
    Sales DECIMAL(12,3),
    Profit DECIMAL(12,4),
    ShipMode VARCHAR(20),
    Region VARCHAR(20)
);
GO

BULK INSERT dbo.ecommerce_clean_bi
FROM 'C:\Users\Thinkpad\OneDrive\Desktop\ecommerce_clean_bi.csv'
WITH (
    FIRSTROW = 2,
    FIELDTERMINATOR = ',',
    ROWTERMINATOR = '0x0d0a',
    CODEPAGE = '65001',
    TABLOCK
);
GO

SELECT COUNT(*) AS filas FROM dbo.ecommerce_clean_bi;
SELECT TOP 10 * FROM dbo.ecommerce_clean_bi;

/* Confirmación de la BAse ordenando por fecha */
SELECT COUNT(*) AS filas FROM dbo.ecommerce_clean_bi;
SELECT TOP 10 * FROM dbo.ecommerce_clean_bi ORDER BY OrderDate;

/* Ventas, ganancia y margen */
SELECT
  SUM(Sales)  AS TotalSales,
  SUM(Profit) AS TotalProfit,
  CAST(100.0 * SUM(Profit) / NULLIF(SUM(Sales),0) AS DECIMAL(10,2)) AS ProfitMarginPct
FROM dbo.ecommerce_clean_bi;

/*Top 5 regiones por ganancia*/
SELECT TOP 5
  Region,
  SUM(Sales)  AS TotalSales,
  SUM(Profit) AS TotalProfit
FROM dbo.ecommerce_clean_bi
GROUP BY Region
ORDER BY TotalProfit DESC;

/*Matriz ejecutiva: Región x Categoría*/
SELECT
  Region,
  Category,
  SUM(Sales)  AS TotalSales,
  SUM(Profit) AS TotalProfit,
  CAST(100.0 * SUM(Profit) / NULLIF(SUM(Sales),0) AS DECIMAL(10,2)) AS MarginPct
FROM dbo.ecommerce_clean_bi
GROUP BY Region, Category
ORDER BY TotalProfit DESC;

/*¿Qué Ship Mode “mata” el margen? */
SELECT
  ShipMode,
  COUNT(*)   AS Orders,
  SUM(Sales) AS TotalSales,
  SUM(Profit) AS TotalProfit,
  CAST(100.0 * SUM(Profit) / NULLIF(SUM(Sales),0) AS DECIMAL(10,2)) AS MarginPct
FROM dbo.ecommerce_clean_bi
GROUP BY ShipMode
ORDER BY MarginPct ASC;


/* Ventas, ganancia y margen */



