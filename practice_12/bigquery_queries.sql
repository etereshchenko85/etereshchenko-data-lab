-- Завдання 1 
select country,
  count(*) as users_count
FROM `bigquery-public-data.thelook_ecommerce.users` 
group by country
order by users_count desc
limit 10;

--Завдання 2
select 
 category,
 count(*) as items_sold,
 round(sum(sale_price), 2) as revenue
from `bigquery-public-data.thelook_ecommerce.order_items` as OI
join `bigquery-public-data.thelook_ecommerce.products` as PD on OI.product_id = PD.id
group by category
order by revenue desc;

-- Завдання 3
select status,
 count(*)orders_count
from `bigquery-public-data.thelook_ecommerce.orders`
where status in ('Complete', 'Shipped')
group by status;

-- Завдання 4
select
  format_date('%Y-%m', date(created_at)) as month,
  count(*) as items_sold,
  round(avg(sale_price), 2) as avg_price
from `bigquery-public-data.thelook_ecommerce.order_items`
where extract(YEAR from created_at) in (2024, 2025)
group by month
order by month;

-- Завдання 5
select 
 category,
 round(sum(sale_price), 2) as revenue
from `bigquery-public-data.thelook_ecommerce.order_items` as OI
join `bigquery-public-data.thelook_ecommerce.products` as PD on OI.product_id = PD.id
group by category
having sum(sale_price) > 100000
order by revenue desc;

-- Завдання 6
select
  name as product_name,
  brand,
  count(*) as times_sold,
  round(sum(sale_price), 2) as revenue
from `bigquery-public-data.thelook_ecommerce.order_items` as OI
join `bigquery-public-data.thelook_ecommerce.products` as PD on OI.product_id = PD.id
group by 
  name,
  brand
order by revenue desc
limit 10;

--Завдання 7
select
  category,
  count(*) as total_items,
  countif(returned_at is not null) as returned_items,
  round(countif(returned_at is not null) / count(*) * 100, 2) as return_rate_pct
from `bigquery-public-data.thelook_ecommerce.order_items` as oi
join `bigquery-public-data.thelook_ecommerce.products` as pd on oi.product_id = pd.id
group by category
order by return_rate_pct desc;

--Завдання 8
with buyers_cat as (
  select distinct
    p.category,
    u.id,
    u.age
  from `bigquery-public-data.thelook_ecommerce.order_items` as oi
  join `bigquery-public-data.thelook_ecommerce.products` as p on oi.product_id = p.id
  join `bigquery-public-data.thelook_ecommerce.users` as u on oi.user_id = u.id
)

select
  category,
  count(id) as buyers,
  round(avg(age), 2) as avg_age
from buyers_cat
group by category
order by avg_age desc;

--Завдання 9
select
  format_date('%Y-%m', date(created_at)) as month,
  round(sum(sale_price), 2) as revenue,
  rank() over (order by (sum(sale_price)) desc) as revenue_rank
from `bigquery-public-data.thelook_ecommerce.order_items` 
where extract(YEAR from created_at) = 2025
group by month 
order by revenue_rank;

--Завдання 10
with monthly_rev as (
  select
    format_date('%Y-%m', date(created_at)) as month,
    round(sum(sale_price), 2) as revenue
  from `bigquery-public-data.thelook_ecommerce.order_items` 
  where extract(YEAR from created_at) = 2025
  group by month
)

select
  month,
  revenue,
  lag(revenue) over (order by month) as prev_month_revenue,
  round((revenue - (lag(revenue) over (order by month))) /
  (lag(revenue) over (order by month))
   * 100, 1) as growth_pct
from monthly_rev
order by month;

--Завдання 11
select
  category,
  p.name as product_name,
  round(sum(sale_price), 2) as revenue,
  row_number() over (partition by category 
    order by (sum(sale_price)) desc)
    as rank_in_category
from `bigquery-public-data.thelook_ecommerce.order_items` as oi
join `bigquery-public-data.thelook_ecommerce.products` as p on oi.product_id = p.id 
group by category, name
qualify row_number() over (partition by category order by (sum(sale_price)) desc) <= 3
order by category,
  rank_in_category;










