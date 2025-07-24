use CRM_project;

-- Value by Stage
select deal_stage,sum(close_value) as Val from SalesPipeline
group by deal_stage;

-- Pipe Velocity

WIth win_Rate as 
(
SELECT 
    ROUND((COUNT(CASE
                WHEN SP.deal_stage = 'Won' THEN SP.opportunity_id
            END) / COUNT(SP.opportunity_id)) * 100,
            2) AS Win_percent
FROM
    SalesTeams ST
        INNER JOIN
    SalesPipeline SP ON (SP.sales_agent = ST.sales_agent)
),
Avgtime as 
(
select round(avg(datediff(close_date,engage_date))) as AvgTime from SalesPipeline
where engage_date is not null and close_date is not null
),

PipeVal as (
select sum(close_value) as totalVal from SalesPipeline
)

select round((totalVal*Win_percent)/(AvgTime),2) as Velocity from PipeVal,Avgtime,win_Rate;

--  Conversion Rate by Stage
 -- Overall Rate
SELECT 
    (COUNT(CASE
        WHEN deal_stage = 'Won' THEN opportunity_id
    END) / COUNT(opportunity_id)) * 100 AS Conversion_Rate
FROM
    SalesPipeline;
	-- Prospecting to engage
    SELECT 
    (COUNT(CASE
        WHEN deal_stage = 'Engaging' THEN opportunity_id
    END) / COUNT(CASE
        WHEN deal_stage = 'Prospecting' THEN opportunity_id
    END)) * 100 AS Conversion_Rate
FROM
    SalesPipeline;
    
    -- Engagin to Won 
    SELECT 
    (COUNT(CASE
        WHEN deal_stage = 'Won' THEN opportunity_id
    END) / COUNT(CASE
        WHEN deal_stage = 'Engaging' THEN opportunity_id
    END)) * 100 AS Conversion_Rate
FROM
    SalesPipeline;