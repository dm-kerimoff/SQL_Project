/*
Напишите запрос, чтобы определить среднюю сумму повторных покупок клиентов.
Повторная покупка определяется путём последовательной сортировки — сначала по дате транзакции (tr_date),
затем — по идентификатору транакции (tr_id).
*/

with a as
(
select
	cust_id, tr_date, tr_id, sum(cs.quantity*cp.price) revenue, row_number() over (partition by cust_id order by tr_date, tr_id) as "rang"
from
	sql.coffeeshop_products cp join sql.coffeeshop_sales cs on cp.product_id = cs.product_id
where cust_id is not null
group by 1,2,3
)

select avg(revenue) as amount
from a
where rang > 1
