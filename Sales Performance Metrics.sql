use CRM_project;


-- Win Rate 
	-- by manager 
SELECT 
    ST.manager AS Manager,
    COUNT(CASE
        WHEN SP.deal_stage = 'Won' THEN SP.opportunity_id
    END) AS win_deals,
    COUNT(SP.opportunity_id) AS totalDeals,
    ROUND((COUNT(CASE
                WHEN SP.deal_stage = 'Won' THEN SP.opportunity_id
            END) / COUNT(SP.opportunity_id)) * 100,
            2) AS Win_percent
FROM
    SalesTeams ST
        INNER JOIN
    SalesPipeline SP ON (SP.sales_agent = ST.sales_agent)
GROUP BY Manager
Order by Win_percent desc ; 

	-- By Region
SELECT 
    ST.regional_office AS Region,
    COUNT(CASE
        WHEN SP.deal_stage = 'Won' THEN SP.opportunity_id
    END) AS win_deals,
    COUNT(SP.opportunity_id) AS totalDeals,
    ROUND((COUNT(CASE
                WHEN SP.deal_stage = 'Won' THEN SP.opportunity_id
            END) / COUNT(SP.opportunity_id)) * 100,
            2) AS Win_percent
FROM
    SalesTeams ST
        INNER JOIN
    SalesPipeline SP ON (SP.sales_agent = ST.sales_agent)
GROUP BY Region
Order by Win_percent desc ; 

	-- Within a TimePeriod
SELECT 
    DATE_FORMAT(SP.close_date,'%m-%Y') AS Month_Year,
    COUNT(CASE
        WHEN SP.deal_stage = 'Won' THEN SP.opportunity_id
    END) AS win_deals,
    COUNT(SP.opportunity_id) AS totalDeals,
    ROUND((COUNT(CASE
                WHEN SP.deal_stage = 'Won' THEN SP.opportunity_id
            END) / COUNT(SP.opportunity_id)) * 100,
            2) AS Win_percent
FROM
    SalesPipeline SP
GROUP BY Month_Year
Order by Win_percent desc ; 

-- Average Deal Size
	-- By Sector

with joined as (
select a.account,
SP.close_value,
a.sector,
SP.sales_agent,
SP.opportunity_id,
SP.deal_stage 
from accounts a  
inner join  
SalesPipeline SP on (a.account=SP.account))

select 
sector,
sum(close_value) as Deal_Value,
count(case when deal_stage='Won' then opportunity_id end) as deal_count,
round(sum(close_value)/count(case when deal_stage='Won' then opportunity_id end),2) as DealSize 
from joined
group by sector;

	-- By Account
with joined as (
select a.account,
SP.close_value,
a.sector,
SP.sales_agent,
SP.opportunity_id,
SP.deal_stage 
from accounts a  
inner join  
SalesPipeline SP on (a.account=SP.account))

select 
account,
sum(close_value) as Deal_Value,
count(case when deal_stage='Won' then opportunity_id end) as deal_count,
round(sum(close_value)/count(case when deal_stage='Won' then opportunity_id end),2) as DealSize 
from joined
group by 1;

-- Avg Sales Cycle length
select round(avg(datediff(close_date,engage_date))) from SalesPipeline
where engage_date is not null and close_date is not null;