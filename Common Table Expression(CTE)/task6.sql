/*
Напишите запрос, чтобы вычислить:
общую сумму продаж кофейни,
сумму продаж по категориям товаров,
сумму покупок, совершённых мужчинами и женщинами, по категориям.
Отсортируйте по типу продукта.
*/

select distinct product_type,
SUM(cp.price * cs.quantity) over() total_sum,
SUM(cp.price * cs.quantity) over(partition by product_type) category_sum,
SUM(cp.price * cs.quantity) filter (where gender = 'M') over(partition by product_type) M_sum,
SUM(cp.price * cs.quantity) filter (where gender = 'F') over(partition by product_type) F_sum


from sql.coffeeshop_products cp
join sql.coffeeshop_sales cs on cp.product_id = cs.product_id
join sql.coffeeshop_custs cc on cs.cust_id = cc.cust_id
order by product_type
