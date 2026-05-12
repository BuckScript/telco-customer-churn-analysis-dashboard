SELECT *
FROM telco_churn;

SELECT COUNT(*) AS total_customer
FROM telco_churn;

SELECT COUNT(*) AS churn_customer
FROM telco_churn
WHERE Churn = 'Yes';

CREATE DATABASE telco_churn_db;
show databases;
CREATE DATABASE telco_churn_db;

SELECT 
    ROUND(
        SUM(
            CASE 
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) * 100.0 / COUNT(*),
        2
    ) AS churn_rate
FROM telco_churn; -- Presentasi Churn

SELECT 
    Contract,
    COUNT(*) AS total_customer
FROM telco_churn
GROUP BY Contract; -- Total Customer by Contract

SELECT 
    Contract,

    COUNT(*) AS total_customer,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churn_customer

FROM telco_churn

GROUP BY Contract; -- Churn by Contract

SELECT 
    SUM(TotalCharges) AS total_revenue
FROM telco_churn;

SELECT 
    SUM(TotalCharges) AS revenue_lost
FROM telco_churn
WHERE Churn = 'Yes'; -- Revenue Lost from Churn

SELECT 
    customerID,
    TotalCharges
FROM telco_churn
ORDER BY TotalCharges DESC; -- Customer dengan Revenue Tertinggi

SELECT 
    customerID,
    TotalCharges
FROM telco_churn
ORDER BY TotalCharges DESC
LIMIT 10; -- Limit Data

SELECT 
    AVG(MonthlyCharges) AS avg_monthly_charge
FROM telco_churn;

SELECT 
    AVG(tenure) AS avg_tenure
FROM telco_churn; -- Menghitung rata-rata.

SELECT 
    MAX(MonthlyCharges) AS highest_charge
FROM telco_churn; -- Customer Charge Tertinggi

SELECT 
    MIN(MonthlyCharges) AS lowest_charge
FROM telco_churn; -- Customer Charge Terendah
  
SELECT 
    Contract,

    COUNT(*) AS total_customer,

    ROUND(SUM(TotalCharges),2) AS total_revenue,

    ROUND(AVG(MonthlyCharges),2) AS avg_monthly_charge

FROM telco_churn

GROUP BY Contract; -- Revenue by Contract

SELECT 
    Contract,
    ROUND(SUM(TotalCharges),2) AS total_revenue
FROM telco_churn
GROUP BY Contract
HAVING total_revenue > 1000000; -- Filter hasil aggregation.

SELECT 
    customerID,

    MonthlyCharges,

    CASE
        WHEN MonthlyCharges < 35 THEN 'Low Value'

        WHEN MonthlyCharges BETWEEN 35 AND 70 THEN 'Medium Value'

        ELSE 'High Value'
    END AS customer_segment

FROM telco_churn; -- Segmentasi customer berdasarkan value

SELECT 
    customerID,
    tenure,
    Contract,
    MonthlyCharges,

    CASE

        WHEN tenure < 12 
             AND Contract = 'Month-to-month'
        THEN 'High Risk'

        WHEN tenure BETWEEN 12 AND 36
        THEN 'Medium Risk'

        ELSE 'Low Risk'

    END AS risk_level

FROM telco_churn; -- Churn Risk Analysis

SELECT 
    gender,
    Contract,

    COUNT(*) AS total_customer,

    SUM(
        CASE
            WHEN Churn = 'Yes' THEN 1
            ELSE 0
        END
    ) AS churn_customer

FROM telco_churn

GROUP BY gender, Contract; -- Membandingkan churn antar segment

SELECT 
    customerID,
    TotalCharges
FROM telco_churn

WHERE TotalCharges >

(
    SELECT AVG(TotalCharges)
    FROM telco_churn
); -- Customer di Atas Average Revenue

WITH churn_summary AS (

    SELECT 
        Contract,

        COUNT(*) AS total_customer,

        SUM(
            CASE
                WHEN Churn = 'Yes' THEN 1
                ELSE 0
            END
        ) AS churn_customer

    FROM telco_churn

    GROUP BY Contract
)

SELECT *,
       ROUND(churn_customer * 100.0 / total_customer,2) AS churn_rate

FROM churn_summary; -- CTE (Common Table Expression)

SELECT 
    customerID,

    TotalCharges,

    RANK() OVER(
        ORDER BY TotalCharges DESC
    ) AS revenue_rank

FROM telco_churn; -- Ranking Customer Revenue

SELECT 
    customerID,

    TotalCharges,

    ROUND(
        TotalCharges * 100.0 /
        (SELECT SUM(TotalCharges)
         FROM telco_churn),
        2
    ) AS revenue_contribution_pct

FROM telco_churn

ORDER BY revenue_contribution_pct DESC; -- Revenue Contribution

-- Insight 1
-- Customer dengan kontrak month-to-month memiliki churn rate paling tinggi dibanding kontrak jangka panjang.
-- Insight 2 
-- Customer dengan tenure rendah memiliki risiko churn lebih besar.
-- Insight 3
-- Revenue loss akibat churn cukup signifikan terhadap total revenue perusahaan.
-- Insight 4
-- Customer high-value memberikan kontribusi revenue terbesar namun beberapa memiliki churn risk tinggi.