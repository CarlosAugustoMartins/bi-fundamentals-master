| [Previous](./Business_Case.md) |[Back to Agenda](./SQL_Index.md)  | [Next](./Analytical_Functions.md) |
| :---------|---------|---------: |
# Concept of Cardinality

Cardinality in a table **is the number of distinct values ​​that table has. A low cardinality indicates that there are few distinct values, and with many rows for each value, and a high cardinality, means that there are many distinct values ​​with few rows for each value.** The best example of high cardinality in a table would be the Primary Key, which implies that all rows must be distinct, so there is the maximum number of distinct values ​​for the column, and each value only has 1 row.

In this specific case, we find a table with low cardinality, that is, few different values ​​for field category_id :

```SQL
select category_id, count(1)
from film_category fc
group by category_id ;
```
In this case, we find a table with high cardinality, that is, many different values ​​for field inventory _id:
```SQL
select inventory_id, count(1) 
from rental_inventory
 group by inventory_id;
```

It is important to pay attention to cardinality when joining tables based our needs. **When cardinality is high, total records must be similar to driver table**, we have this sample with similar cardinality, but **records are higher in second query due to wrong join field**, instead of of high cardinality is has become intermediate cardinality **because we have more than 1 record with same key field due to duplicity**.

```SQL
select count(distinct payment_id)
from payment a inner join rental b on a.rental_id = b.rental_id and a.customer_id = b.customer_id ;

select count(distinct payment_id)
from payment a inner join rental b on a.customer_id = b.customer_id 
;

select payment_id, count(1)
from payment a inner join rental b on a.rental_id = b.rental_id and a.customer_id = b.customer_id 
group by payment_id
--having count(1) > 1;

select payment_id, count(1)
from payment a inner join rental b on a.customer_id = b.customer_id
group by payment_id
--having count(1) > 1;
;
```


# Joins

The Join clauses are used to combine records from two or more tables in a database. A JOIN is a means for combining fields from two tables by using values common to each.

## - Join Types are

- The CROSS JOIN
- The INNER JOIN
- The LEFT OUTER JOIN
- The RIGHT OUTER JOIN
- The FULL OUTER JOIN

 ![Alt text](img/joins.png?raw=false "Title")
    
## - CROSS JOIN 

- A **CROSS JOIN matches every row of the first table with every row of the second table. If the input tables have x and y columns, respectively, the resulting table will have x+y columns**. Because CROSS JOINs have the potential to generate extremely large tables, care must be taken to use them only when appropriate.

 ![Alt text](img/sql-cross-join-working-principle-1.png?raw=false "Title")

  
The following is the syntax of CROSS JOIN
```SQL
SELECT ... FROM table1 CROSS JOIN table2 ...
```

Sample with columns i + re and 293990256 records by combination of inventory and rental tables
```SQL
select *
from public.inventory i cross join public.rental re 
```


    - Note
  
    It is valid to use cross joins in some circumstances, if you have small dimensions, it is useful to create junk dimensions.

## - INNER JOIN

- A INNER JOIN creates a new result table by combining column values of two tables (table1 and table2) based upon the join-predicate. **The query compares each row of table1 with each row of table2 to find all pairs of rows, which satisfy the join-predicate**. When the join-predicate is satisfied, **column values for each matched pair of rows of table1 and table2 are combined into a result row.**

- An INNER JOIN is the most common type of join and is the default type of join. You can use INNER keyword optionally.

The following is the syntax of INNER JOIN

```SQL
SELECT table1.column1, table2.column2...
FROM table1
INNER JOIN table2
ON table1.common_filed = table2.common_field;   
```
Sample using our dataset
```SQL
select re.rental_id, re.rental_date, re.customer_id, i.inventory_id, i.store_id , i.film_id
from public.inventory i inner join public.rental re on re.inventory_id = i.inventory_id ;   
```

## - LEFT OUTER JOIN

- The OUTER JOIN is an extension of the INNER JOIN. SQL standard defines three types of OUTER JOINs: LEFT, RIGHT, and FULL and PostgreSQL supports all of these.

- In case of LEFT OUTER JOIN, an **inner join is performed first. Then, for each row in table T1 that does not satisfy the join condition with any row in table T2, a joined row is added with null values in columns of T2**. Thus, the **joined table always has at least one row for each row in T1.**

The following is the syntax of LEFT OUTER JOIN

```SQL
SELECT ... FROM table1 LEFT OUTER JOIN table2 ON conditional_expression ...
```

Sample using our dataset
```SQL
select re.rental_id, re.rental_date, re.customer_id, i.inventory_id, i.store_id , i.film_id
from public.inventory i left outer join public.rental re on re.inventory_id = i.inventory_id ;   
```

## - RIGHT OUTER JOIN

- First, **an inner join is performed. Then, for each row in table T2 that does not satisfy the join condition with any row in table T1, a joined row is added with null values in columns of T1**. This is the converse of a left join; the **result table will always have a row for each row in T2.**

The following is the syntax of RIGHT OUTER JOIN

```SQL 
SELECT ... FROM table1 RIGHT OUTER JOIN table2 ON conditional_expression ...
```

Sample using our dataset
```SQL
select re.rental_id, re.rental_date, re.customer_id, i.inventory_id, i.store_id , i.film_id
from public.inventory i right outer join public.rental re on re.inventory_id = i.inventory_id ;   
```

## - FULL OUTER JOIN

- First, an **inner join is performed. Then, for each row in table T1 that does not satisfy the join condition with any row in table T2, a joined row is added with null values in columns of T2. In addition, for each row of T2 that does not satisfy the join condition with any row in T1, a joined row with null values in the columns of T1 is added**.

The following is the syntax of FULL OUTER JOIN

```SQL
SELECT ... FROM table1 FULL OUTER JOIN table2 ON conditional_expression ...
```

Sample using our dataset
```SQL
select re.rental_id, re.rental_date, re.customer_id, i.inventory_id, i.store_id , i.film_id
from public.inventory i full outer join public.rental re on re.inventory_id = i.inventory_id ;   
```

## - Anti Joins and Business Problems

They can be helpful in a variety of business situations **when you're trying to find something that hasn't happened**, such as:

 - Customers who did not place an order
 - Customers who have not visited your website
 - Salespeople who did not close a deal

 How to perform an anti join
  - Use a WHERE clause to filter out values that are present in Table_2.

```SQL
SELECT * FROM Table1 t1 LEFT JOIN Table2 t2 ON t1.id = t2.id WHERE t2.id IS NULL
```

Sample using our dataset, in this case the result is the movie that hasn't been rented
```SQL
select re.rental_id, re.rental_date, re.customer_id, i.inventory_id, i.store_id , i.film_id
from public.inventory i left outer join public.rental re on re.inventory_id = i.inventory_id
WHERE re.inventory_id IS NULL ;   
```


 ![Alt text](img/anti-join-4.png?raw=false "Title")


| [Previous](./Business_Case.md) |[Back to Agenda](./SQL_Index.md)  | [Next](./Analytical_Functions.md) |
| :---------|---------|---------: |
