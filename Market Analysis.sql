use CRM_project;

-- Revenue Per employee for each account
WIth joined as (select A.account,A.employees as Employeees,sum(SP.close_value) as Revenue from accounts A 
inner join 
SalesPipeline SP on (A.account=SP.account)
group by A.account
)

select account,round(Revenue/Employeees,2) as Revenue_Per_employee from joined;

-- Account Worth
select * from 
(select A.account,sum(SP.close_value) as Revenue from accounts A 
inner join 
SalesPipeline SP on (A.account=SP.account)
where SP.deal_stage='Won'
group by A.account
) acc;

-- Market Penetration by Sector
with Sector as (
select sector,count(account) as Sector_count from accounts
group by sector),
Total as (select count(account) as tot from accounts)

select sector,Sector_count,tot,((Sector_count)/tot)*100 as percent from Total,Sector