/*
Продолжаем анализировать поведение клиента.
Напишите запрос, который поможет ответить на вопрос: какова в среднем разность между суммой первого заказа и суммой второго заказа?
Столбец к выводу — diff.
*/

with a as
(
select
	cust_id, tr_date, tr_id, lag(sum(cs.quantity*cp.price)) over(partition by cust_id order by tr_date, tr_id) as "lag", row_number() over(partition by cust_id order by tr_date, tr_id) as "row_column",
	sum(cs.quantity*cp.price) revenue,
	lag(sum(cs.quantity*cp.price)) over(partition by cust_id order by tr_date, tr_id) - sum(cs.quantity*cp.price) as raznost
from
	sql.coffeeshop_products cp join sql.coffeeshop_sales cs on cp.product_id = cs.product_id
where cust_id is not null
group by 1,2,3
)

select AVG(raznost) as "diff"
from a
where row_column between 1 and 2
