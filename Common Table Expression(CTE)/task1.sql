/*
В кофейне проходит акция: клиенты, совершившие покупку, которая вошла в топ-3 по цене за неделю, получают приз.
Для отчёта необходимо выбрать имена клиентов с призовыми чеками,
отсортировать по номеру недели и по сумме чеков. Количество призов не ограничено.
*/

with sum_cheque as
(
select extract(week from tr_date) as week,
tr_id,
cc.cust_name,
SUM(price*quantity) as cheque

from
sql.coffeeshop_sales cs
join sql.coffeeshop_custs cc on cc.cust_id = cs.cust_id
join sql.coffeeshop_products cp on cp.product_id = cs.product_id
group by extract(week from tr_date), tr_id, cc.cust_name
order by extract(week from tr_date), cust_name
),

rating as
(
select *, dense_rank() over(partition by week order by cheque desc) as rat
from sum_cheque
)

select week, cust_name as "name"
from rating
where rat <= 3
order by week, cust_name
