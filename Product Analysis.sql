use CRM_project;

--  Average Selling Price vs List Price
select distinct P.series as series,
Avg(P.sales_price) as List_price,
avg(SP.close_value) as Selling_Price
from products P
inner join
SalesPipeline SP on (P.product=SP.product)
where SP.deal_stage = 'Won'
group by series;

-- Product Profitability Proxy

select distinct P.series as series,
sum(SP.close_value) as Selling_Price
from products P
inner join
SalesPipeline SP on (P.product=SP.product)
where SP.deal_stage = 'Won'
group by series;

-- product popularity

With Product_count as (
select distinct P.series as Series,
count(SP.close_value) as Prod_Total
from products P
right join
SalesPipeline SP on (P.product=SP.product)
where SP.deal_stage = 'Won'
group by series
)

select  Series,
Prod_Total,
(select count(*) from SalesPipeline where deal_stage='Won') as total,
(
Prod_Total/
(select count(*) from SalesPipeline where deal_stage='Won')
)*100 as Popularity
from Product_count