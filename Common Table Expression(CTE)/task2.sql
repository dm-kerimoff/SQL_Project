/*
Необходимо выбрать 5 человек, ставших клиентами компании раньше остальных.
Количество претендентов на бонусы должно быть минимальным.
Для них необходимо рассчитать сумму бонуса: скидка составляет 30% от средней суммы их чеков.
*/

with newtable1 as
(select cc.cust_id, customer_since, cust_name, rank() over (order by customer_since asc) as "rank_column"
from
sql.coffeeshop_custs cc
where exists
(select * from sql.coffeeshop_sales cs where cc.cust_id = cs.cust_id)
limit 5

),

newtable2 as
(
select cust_name, AVG(total_sum) as "avg_check"
from
(select cust_name, tr_id, SUM(cp.price * cs.quantity) as "total_sum"
from
sql.coffeeshop_products cp
join sql.coffeeshop_sales cs on cp.product_id = cs.product_id
join sql.coffeeshop_custs cc on cc.cust_id = cs.cust_id
group by cust_name, tr_id) check_sum
group by cust_name
)

select newtable1.cust_name, 0.3 * avg_check as "bonus"
from newtable1 join newtable2 on newtable1.cust_name = newtable2.cust_name
order by newtable1.cust_name asc
