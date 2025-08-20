-- Заказы не должны иметь отрицательную суммарную оплату
-- Тест возвращает нарушителей (total_amount < 0)
{{ config(severity='error') }}  -- можно поставить 'warn', если не хочешь валить сборку

with
    agg as (
        select order_id, sum(amount) as total_amount
        from {{ ref('stg_stripe__payments') }}  -- двойное подчёркивание!
        where status = 'success'  -- считаем только успешные платежи
        group by 1
    )

select *
from agg
where total_amount < 0
