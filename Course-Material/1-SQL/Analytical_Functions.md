| [Previous](./Joins.md) |[Back to Agenda](./SQL_Index.md) | [Next](./Table_Partitioning.md) |
| :---------|---------|---------: |

# Analytical Functions

Analytic functions or window functions are used to perform **calculations in a simpler and more elegant way than with complex SQL queries, subqueries, or join operations**.

## - Applications 

 - Make it **easier to obtain complex calculations** in reports and ETL processes.
 - **Improve the performance** of SQL queries by **eliminating join operations**.
 - Provide **cleanliness to the code, thereby minimizing maintenance and improving productivity**.
 - **They are part of standard SQL.**

## - RANK
  Query to sort the customer rows by ranking within each staff member by amount
  
  ```SQL
  select
	  customer_id,
	  staff_id,
	  RANK() OVER (PARTITION BY staff_id ORDER BY sum(amount) desc ) AS valor,
	  SUM(amount) amount
	from public.payment
	group by customer_id, staff_id
	order by staff_id, amount desc;
  ```

## - DENSE_RANK
 
Same as the previous function except that in case of a tie in rank it does not leave gaps between the elements 
```SQL
  select
	  customer_id,
	  staff_id,
	  DENSE_RANK() OVER (PARTITION BY staff_id ORDER BY sum(amount) desc ) AS valor,
	  SUM(amount) amount
	from public.payment
	group by customer_id, staff_id
	order by staff_id, amount desc;
  ```

## - ROW_NUM

Number rows of films by film_id and store_id

```SQL
SELECT 
  inventory_id,
  film_id,
  store_id,
  ROW_NUMBER() OVER (PARTITION BY  film_id,store_id) AS valor
FROM 
  public.inventory  
ORDER BY
  inventory_id, film_id, store_id;
```
## - LISTAGG (STRING_AGG in Postgres)

Concatenate rows of actors grouping by film title

```SQL
SELECT title, STRING_AGG(actor, '; ' ORDER BY actor) AS group_ids 
	from (
	select b.film_id , c.title, a.first_name || ' ' || a.last_name AS actor
	from actor a inner join film_actor b on   a.actor_id = b.actor_id 
	  inner join film c on  b.film_id = c.film_id 
	order by film_id) a
    group by title;
  ```
## - GROUPING SETS 

A grouping set **is a set of columns by which you group by using the GROUP BY clause**.

A grouping set is denoted by a **comma-separated list of columns placed inside parentheses**:

(column1, column2, ...)

For example, the following query uses the GROUP BY clause to return **the amount of payments by customer and rental**. In other words, **it defines a grouping set of the customer and rental which is denoted by (customer_id, rental_id) for some specific rental_ids** 

```SQL
SELECT
    customer_id,
    rental_id,
    SUM (amount)
FROM
    public.payment
where rental_id in (4591, 20640, 36689, 52738)    
GROUP BY
    customer_id,
    rental_id;
```
The following query finds the sum amount by customer. It defines a grouping set (customer):
```SQL
SELECT
    customer_id,
    SUM (amount)
FROM
    public.payment
where rental_id in (4591, 20640, 36689, 52738)    
GROUP BY
    customer_id;
```
The following query finds the sum amount by rental. It defines a grouping set (rental):

```SQL
SELECT
    rental_id,
    SUM (amount)
FROM
    public.payment
where rental_id in (4591, 20640, 36689, 52738)    
GROUP BY
    rental_id;
```
The following query finds sum amount sold for all customers and rental. It defines an empty grouping set which is denoted by ().

```SQL
SELECT
    SUM (amount)
FROM
    public.payment
where rental_id in (4591, 20640, 36689, 52738) ;
```
Suppose that you want to all the grouping sets by using a single query. To achieve this, you may use the UNION ALL to combine all the queries above.

Because UNION ALL requires all result sets to have the same number of columns with compatible data types, you need to adjust the queries by adding NULL to the selection list of each as shown below:
```SQL
SELECT
    customer_id,
    rental_id,
    SUM (amount)
FROM
    public.payment
where rental_id in (4591, 20640, 36689, 52738)    
GROUP BY
    customer_id,
    rental_id

UNION ALL

SELECT
    customer_id,
    1 rental_id,
    SUM (amount)
FROM
    public.payment
where rental_id in (4591, 20640, 36689, 52738)    
GROUP BY
    customer_id,
    1 

UNION ALL

select
    1,
    rental_id,
    SUM (amount)
FROM
    public.payment
where rental_id in (4591, 20640, 36689, 52738)    
GROUP by 
    1,
    rental_id

UNION ALL

select
    1,
    1,
    SUM (amount)
FROM
    public.payment
where rental_id in (4591, 20640, 36689, 52738) ;
```

This **query generated a single result set with the aggregates for all grouping sets**.

Even though the above query works as you expected, it has **two main problems**.

First, **it is quite lengthy**.
Second, it has a **performance issue** because PostgreSQL has to **scan the sales table separately for each query**.
To make it more efficient, PostgreSQL provides the GROUPING SETS clause which is the subclause of the GROUP BY clause.

The **GROUPING SETS allows you to define multiple grouping sets in the same query.**

The general syntax of the GROUPING SETS is as follows:

```SQL
SELECT
    c1,
    c2,
    aggregate_function(c3)
FROM
    table_name
GROUP BY
    GROUPING SETS (
        (c1, c2),
        (c1),
        (c2),
        ()
);
```
In this syntax, we have four grouping sets (c1,c2), (c1), (c2), and ().

To apply this syntax to the above example, you can use GROUPING SETS clause instead of the UNION ALL clause like this:


```SQL
SELECT
    customer_id ,
    rental_id ,
    SUM (amount)
FROM
    public.payment
    where rental_id in (4591, 20640, 36689, 52738)
GROUP BY
    GROUPING SETS (
        (customer_id, rental_id),
        (customer_id),
        (rental_id),
        ()
    );
  ```
 

| [Previous](./Joins.md) |[Back to Agenda](./SQL_Index.md) | [Next](./Table_Partitioning.md) |
| :---------|---------|---------: |