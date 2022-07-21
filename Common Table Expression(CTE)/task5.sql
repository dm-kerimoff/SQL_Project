/*
Напишите запрос по следующим условиям:
Выберите среднюю цену товара в категории.
Обратите внимание, что в расчет среднего не должны попасть товары дешевле 3 (< 3).
По вашей выборке должно быть видно, на сколько цена товара дешевле самого дорогого товара в той же категории.
*/

select product_type, product, price,
avg(price) filter (where price >= 3) over (partition by product_type) as "avg_price",
max(price) over (partition by product_type) - price as "delta_price"
from sql.coffeeshop_products cp
