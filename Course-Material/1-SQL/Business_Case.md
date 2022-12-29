| [Previous](./CTE_SubQuery_CTA_Vistas.md) |[Back to Agenda](./SQL_Index.md)   | [Next](./Joins.md) |
| :---------|---------|---------: |

#  Business Case
  Create a CTE, CTA, Sub Query and View considering more than one inventory product for rental and re calculate the payment considering a standard price for all products (films)

   - CTE version
```SQL
with rentals as (
      select rental_id, rental_date, customer_id, return_date, staff_id, last_update 
      from public.rental
    ),
    inventory_rental as (
      select floor(random()*(50000-1+1))+1 as rental_id, floor(random()*(4581-1+1))+1 as inventory_id 
      from generate_series(1, 50000)
    ),
    payments as (
      select payment_id, customer_id, staff_id, rental_id, payment_date, 30 as standard_price
      from public.payment
    )
    select r.rental_id, r.return_date, p.payment_date,count(1) as rentals, count(1) * p.standard_price as Total
    from inventory_rental i inner join rentals r on r.rental_id = i.rental_id
      inner join payments p on r.rental_id = p.rental_id
    group by r.rental_id, r.return_date, p.payment_date, p.standard_price;
```  

 - Subquery version
```SQL
select r.rental_id, r.return_date, p.payment_date,count(1) as rentals, count(1) * p.standard_price as Total
      from (select floor(random()*(50000-1+1))+1 as rental_id, floor(random()*(4581-1+1))+1 as inventory_id 
              from generate_series(1, 50000)) i 
      inner join (select rental_id, rental_date, customer_id, return_date, staff_id, last_update 
                                            from public.rental) r on r.rental_id = i.rental_id
      inner join (select payment_id, customer_id, staff_id, rental_id, payment_date, 30 as standard_price
                    from public.payment) p on r.rental_id = p.rental_id
    group by r.rental_id, r.return_date, p.payment_date, p.standard_price;
```   
  - CTE VS Subquery
```SQL

explain 
select
  a.rental_id, a.count,  b.rental_id, b.count
from (select rental_id, count(rental_id) count from public.inventory_rental 
      group by rental_id) a
     left join (SELECT rental_id, count(rental_id) count from public.inventory_rental 
      group by rental_id) b on a.rental_id = b.rental_id
; 

explain 
with aggregates as 
  (select rental_id, count(rental_id) count from public.inventory_rental 
   group by rental_id)
select
  a.rental_id, a.count,  b.rental_id, b.count
from aggregates a 
 left join aggregates b on a.rental_id = b.rental_id
; 

SET enable_sort = off;

```
  ## Note
      enable_sort (boolean)
      Enables or disables the query planner's use of explicit sort steps. It is impossible to suppress explicit sorts entirely, but turning this variable off discourages the planner from using one if there are other methods available. The default is on.


  - CTA version
```SQL
create table rental_inventory as
with rentals as (
      select rental_id, rental_date, customer_id, return_date, staff_id, last_update 
      from public.rental
    ),
    inventory_rental as (
      select floor(random()*(50000-1+1))+1 as rental_id, floor(random()*(4581-1+1))+1 as inventory_id 
      from generate_series(1, 50000)
    ),
    payments as (
      select payment_id, customer_id, staff_id, rental_id, payment_date, 30 as standard_price
      from public.payment
    )
    select r.rental_id, r.return_date, p.payment_date,count(1) as rentals, count(1) * p.standard_price as Total
    from inventory_rental i inner join rentals r on r.rental_id = i.rental_id
      inner join payments p on r.rental_id = p.rental_id
    group by r.rental_id, r.return_date, p.payment_date, p.standard_price;
```  

- View version
```SQL
create View rental_inventory_v as
with rentals as (
      select rental_id, rental_date, customer_id, return_date, staff_id, last_update 
      from public.rental
    ),
    inventory_rental as (
      select floor(random()*(50000-1+1))+1 as rental_id, floor(random()*(4581-1+1))+1 as inventory_id 
      from generate_series(1, 50000)
    ),
    payments as (
      select payment_id, customer_id, staff_id, rental_id, payment_date, 30 as standard_price
      from public.payment
    )
    select r.rental_id, r.return_date, p.payment_date,count(1) as rentals, count(1) * p.standard_price as Total
    from inventory_rental i inner join rentals r on r.rental_id = i.rental_id
      inner join payments p on r.rental_id = p.rental_id
    group by r.rental_id, r.return_date, p.payment_date, p.standard_price;
```  
- Materialized View version
```SQL
create MATERIALIZED VIEW mymatview as 
with rentals as (
      select rental_id, rental_date, customer_id, return_date, staff_id, last_update 
      from public.rental
    ),
    inventory_rental as (
      select floor(random()*(50000-1+1))+1 as rental_id, floor(random()*(4581-1+1))+1 as inventory_id 
      from generate_series(1, 50000)
    ),
    payments as (
      select payment_id, customer_id, staff_id, rental_id, payment_date, 30 as standard_price
      from public.payment
    )
    select r.rental_id, r.return_date, p.payment_date,count(1) as rentals, count(1) * p.standard_price as Total
    from inventory_rental i inner join rentals r on r.rental_id = i.rental_id
      inner join payments p on r.rental_id = p.rental_id
    group by r.rental_id, r.return_date, p.payment_date, p.standard_price;

    REFRESH MATERIALIZED VIEW mymatview;
```  

| [Previous](./CTE_SubQuery_CTA_Vistas.md) |[Back to Agenda](./SQL_Index.md)   | [Next](./Joins.md) |
| :---------|---------|---------: |