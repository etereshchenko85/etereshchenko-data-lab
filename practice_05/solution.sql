-- Завдання 1.3.
SELECT 'sales' AS t, COUNT(*) FROM sales
UNION ALL
SELECT 'stock_prices', COUNT(*) FROM stock_prices;

--Завдання 2. Перше знайомство: вікно без поділу на групи
--Завдання 2.1.
select 
	store_id, 
	sum(total_amount)
from sales
group by store_id
order by store_id ;

select 
	sale_id, 
	store_id, 
	total_amount,
	sum(total_amount) over () as summ_sales
from sales;

--Завдання 2.2.
select 
	sale_id, 
	store_id, 
	total_amount, 
	round(avg(total_amount) over (), 2) as avg_all
from sales
order by sale_id;

--Завдання 2.3. 
select 
	sale_id, 
	total_amount, 
	count(*) over () as sales_count
from sales
order by sale_id;

--Завдання 2.4.
select 
	sale_id, 
	store_id, 
	total_amount,
	round(total_amount / sum(total_amount) over () * 100, 2) as pct_of_total
from sales
order by sale_id;

--Завдання 2.5. 
select 
	sale_id, 
	store_id, 
	total_amount,
	rank() over (order by total_amount desc) as overall_rank
from sales
order by overall_rank;

--Завдання 3. PARTITION BY — рахуємо в межах магазину
--Завдання 3.1. 
select 
	sale_id, 
	store_id, 
	total_amount,
	round(avg(total_amount) over (partition by store_id), 2) as avg_store_sales
from sales
order by store_id, sale_id;

--Завдання 3.2.
select 
	sale_id,
	store_id, 
	total_amount,
	sum(total_amount) over w as store_total,
	min(total_amount) over w as store_min,
	max(total_amount) over w as store_max,
	count(total_amount) over w as store_sales_cnt
from sales
window w as (partition by store_id)
order by store_id, sale_id;

--Завдання 3.3.
select 
	sale_id, 
	store_id, 
	total_amount,
	round(total_amount - (avg(total_amount) over (partition by store_id)), 2) as diff_from_avg
from sales
order by store_id, sale_id;

--Завдання 3.4.
select
	sale_id, 
	store_id, 
	total_amount,
	round(total_amount * 100/ SUM(total_amount) over (partition by store_id), 2) as pct_of_store
from sales
order by store_id, sale_id;

--Завдання 3.5. 
with s as (
	select 
		sale_id, 
		store_id,
		total_amount,
		avg(total_amount) over(partition by store_id) as avg_store_sales
	from sales
)
select 
	sale_id, 
	store_id,
	total_amount,
	round(avg_store_sales, 2) as avg_store_sales
from s 
where total_amount > avg_store_sales
order by store_id, sale_id;
--Завдання 3.5. варіант2 без cte
select * 
	from (
		select sale_id, store_id, total_amount,
			round (AVG(total_amount) over (partition by store_id), 2) as avg_store_sales
		from sales)
where total_amount > avg_store_sales
order by store_id, sale_id;

-- Завдання 4. Нумерація та ранжування
-- Завдання 4.1.
select 
	sale_id, 
	store_id, 
	sale_date,
	row_number() over (partition by store_id
		order by sale_date, sale_id) as sale_rank
from sales
order by store_id, sale_id;

--Завдання 4.2.
select 
	sale_id,
	store_id,
	total_amount,
	rank() over (partition by store_id
		order by total_amount desc) as amount_rank
from sales
order by store_id, sale_id;

--Завдання 4.3.
select 
	sale_id, 
	store_id, 
	total_amount,
	rank() over (partition by store_id
		order by total_amount desc) as amount_rank ,
	dense_rank() over (partition by store_id
		order by total_amount desc) as amount_dense 
from sales
order by store_id, total_amount desc;

--Завдання 4.4.
select 
	sale_id, 
	store_id, 
	total_amount, 
	ntile(2) over (partition by store_id
		order by total_amount desc) as half 
from sales
order by store_id, total_amount desc;

-- Завдання 4.5.
select 
	sale_id,
	sale_date,
	total_amount,
	row_number() over (partition by sale_date
		order by total_amount desc) as date_rank 
from sales
order by sale_date, date_rank;

-- Завдання 4.6.
select
	sale_id, 
	sale_date, 
	product_id,
	row_number() over (partition by product_id
		order by sale_date, sale_id) as product_rank 
from sales
order by product_id, sale_date, sale_id;

-- Завдання 5. Сусідні рядки: LAG і LEAD
-- Завдання 5.1.
select 
	sale_id, 
	store_id,
	total_amount,
	lag(total_amount) over w as previous_sale_amount
from sales
window w as (partition by store_id ORDER BY sale_date, sale_id)
order by store_id, sale_date, sale_id;

-- Завдання 5.2.
select 
	sale_id, 
	store_id,
	total_amount,
	lead(total_amount) over w as next_sale_amount
from sales
window w as (partition by store_id ORDER BY sale_date, sale_id)
order by store_id, sale_date, sale_id;

-- Завдання 5.3.
select 
	sale_id,
	store_id,
	total_amount,
	total_amount - lag(total_amount, 1, 0) over w as diff_prev 
from sales
window w as (partition by store_id ORDER BY sale_date, sale_id)
order by store_id, sale_date, sale_id;

-- Завдання 5.4.
select 
	sale_id, 
	store_id,
	total_amount,
	coalesce(lag(total_amount) over w, 0) as previous_sale_amount_clsc,
	lag(total_amount, 1, 0) over w as previous_sale_amount
from sales
window w as (partition by store_id ORDER BY sale_date, sale_id)
order by store_id, sale_date, sale_id;

-- Завдання 5.5.
select 
	sale_id, 
	store_id, 
	total_amount,
	lag(total_amount, 2, 0) over w as two_sales_ago
from sales
window w as (partition by store_id ORDER BY sale_date, sale_id)
order by store_id, sale_date, sale_id;

-- Завдання 5.6.
select *,
		case 
			when diff_prev is null  then 'перший продаж'
			when diff_prev > 0 then 'зростання'
			when diff_prev < 0 then 'падіння'
			else 'без змін'
		end as trend
from (
		select 
			sale_id, 
			store_id, 
			total_amount,
			total_amount - lag(total_amount) over w as diff_prev 
		from sales
		window w as (partition by store_id ORDER BY sale_date, sale_id)
	) as t
order by store_id, sale_id;
	
	--- Завдання 6. Рамка вікна: накопичені підсумки й ковзаюче середнє
--Завдання 6.1.
select 
	sale_id, 
	store_id, 
	sale_date,
	total_amount,
	sum(total_amount) over (partition by store_id order by sale_date, sale_id) as cumulative_store_sales
from sales
order by store_id, sale_date, sale_id;

--Завдання 6.2.
select 
	sale_id, 
	store_id,
	quantity_sold,
	sum(quantity_sold) over (partition by store_id order by sale_date, sale_id) as cumulative_qty
from sales
order by store_id, sale_date, sale_id;

--Завдання 6.3.
select 
	sale_id, 
	store_id, 
	sale_date, 
	total_amount,
	round(avg(total_amount) over (partition by store_id order by sale_date, sale_id
                        rows between 2 preceding and current row), 2) as moving_avg_3rows
   from sales
order by store_id, sale_date, sale_id;

--Завдання 6.4.
select 
	sale_id, 
	store_id, 
	sale_date, 
	total_amount,
	round(avg(total_amount) over (partition by store_id order by sale_date, sale_id
                        rows between 2 preceding and current row), 2) as moving_avg_3rows,
    round(avg(total_amount) over (partition by store_id order by sale_date
                        range between interval '2 days' preceding and current row), 2) as moving_avg_3days
from sales
order by store_id, sale_date, sale_id;

--Завдання 6.5.
select 
	sale_id, 
	store_id, 
	sale_date, 
	total_amount,
	max(total_amount) over (partition by store_id 
					  order by sale_date, sale_id
					  rows between  unbounded preceding and current row
					) as running_max
from sales
order by store_id, sale_date, sale_id;


--- Завдання 7. Часові ряди: ціни акцій 
--Завдання 7.1.
select 
	stock_id, 
	stock_symbol, 
	price_date, 
	closing_price,
	lag(closing_price, 1, 0) over (partition by stock_symbol order by price_date) as yesterday_price,
	lead(closing_price, 1, 0) over (partition by stock_symbol order by price_date) as tomorrow_price 
from public.stock_prices
order by stock_symbol, price_date;

-- Завдання 7.2.
select 
	stock_id, 
	stock_symbol, 
	price_date, 
	closing_price,
	closing_price - lag(closing_price) over (partition by stock_symbol order by price_date) as price_delta 
from public.stock_prices
order by stock_symbol, price_date;

-- Завдання 7.3.
select 
	stock_id, 
	stock_symbol, 
	price_date, 
	closing_price,
	round((closing_price * 100 / lag(closing_price)
				over (partition by stock_symbol order by price_date) - 100)
		, 2) as pct_change 
from public.stock_prices
order by stock_symbol, price_date;

-- Завдання 7.4.
select 
	stock_id, 
	stock_symbol, 
	price_date, 
	closing_price,
	first_value(closing_price) over (partition by stock_symbol order by price_date) as first_price,
	round((closing_price * 100 / first_value(closing_price)
				over (partition by stock_symbol order by price_date) - 100)
		, 2) as growth_from_start_pct
from public.stock_prices
order by stock_symbol, price_date;

-- Завдання 7.5.
select 
	stock_id, 
	stock_symbol, 
	price_date, 
	closing_price,
	max(closing_price) over (partition by stock_symbol) as  max_price,
	max(closing_price) over (partition by stock_symbol) - closing_price as diff_from_max
from public.stock_prices
order by stock_symbol, price_date;

-- Завдання 7.6.
with d as (
    select 
    	stock_symbol, 
    	price_date, 
    	closing_price,
        closing_price - lag(closing_price)
              over (partition by stock_symbol order by price_date) as price_delta
    from stock_prices)
select 
	stock_symbol, 
	price_date, 
	closing_price,
	price_delta,
    sum(coalesce(price_delta, 0))
           over (partition by stock_symbol order by price_date) as cumulative_change
from d
order by stock_symbol, price_date;

-- Завдання 7.7.
select 
	stock_id, 
	stock_symbol,
	price_date, 
	closing_price,
	case 
		when closing_price > lag(closing_price, 1) over w 
		and lag(closing_price, 1)over w  > lag(closing_price, 2) over w 
		then 'так'
		else 'ні'
	end as three_day_growth
from public.stock_prices
window w as (partition by stock_symbol order by price_date)
order by stock_symbol, price_date;


-- Завдання 8.
-- Завдання 8.1.
select *
from (
    select 
    	sale_id, 
    	store_id, 
    	total_amount,
        row_number() over (partition by store_id
        	order by total_amount desc, sale_id) as rn
    from sales
) as t
where rn = 1
order by store_id;

-- Завдання 8.2.
select store_id,
	min(sale_date) over (partition by store_id) as first_sale_date,
	max(sale_date) over (partition by store_id) as last_sale_date,
	max(sale_date) over (partition by store_id) - min(sale_date) over (partition by store_id) as days_between
from sales
order by store_id;
	
-- Завдання 8.3.
select 
	product_id,
	sum(total_amount) as product_total,
	dense_rank() over (order by sum(total_amount)) as product_rank
from sales
group by product_id
order by product_rank, product_id;


