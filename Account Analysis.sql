use CRM_project;

-- Sales Ratio

select round(
sum(close_value)/
(select count(sales_agent) from SalesTeams)
,2) as Ratio
from SalesPipeline;

-- Top 10 Account Percent

with Top_10_Acc as (
select a.account as Accounts,
Sum(SP.close_value) as Revenue
from accounts a  
inner join  
SalesPipeline SP on (a.account=SP.account)
group by Accounts
order by Revenue desc limit 10
)

select Accounts,
100.0*(
(Revenue)/
(select sum(close_value) from SalesPipeline where account is not null)
) as Ratio 
from Top_10_Acc;


-- Loss Deals

select 100.0*(sum(case when deal_stage='Lost' then close_value else 0 end)/sum(close_value)) as Loss_Deals 
from SalesPipeline