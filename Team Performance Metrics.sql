use CRM_project;

--  Sales per Agent

select distinct 
ST.sales_agent as Sales_Agent,
sum(SP.close_value) as Sales_val
from SalesTeams ST
inner join
SalesPipeline SP on (ST.sales_agent=SP.sales_agent)
where SP.deal_stage = 'Won'
group by Sales_Agent;


-- Manager Effectiveness

with joined as (
select distinct ST.manager as Manager,
ST.sales_agent as Sales_Agent,
SP.close_value as Sales_val
from SalesTeams ST
inner join
SalesPipeline SP on (ST.sales_agent=SP.sales_agent)
where SP.deal_stage = 'Won'
),
Team_Perf as (
select distinct Manager,
Sales_Agent,
sum(Sales_val)over(partition by Manager,Sales_Agent) as sales
from joined
),
manager_sales as (
select distinct Manager,
sum(Sales_val) as tot_sales
from joined
group by Manager
)

select Manager,Sales_Agent,concat(round((sales/tot_sales)*100.0,1),'%') as Performance from manager_sales
inner join 
Team_Perf using(Manager);

--  Regional Performance
select * from (
select distinct a.sector as Sector,
Sum(SP.close_value) as SalesVal
from accounts a
inner join
SalesPipeline SP on (a.account=SP.account)
where SP.deal_stage = 'Won'
group by Sector
) Regional 
order by SalesVal desc