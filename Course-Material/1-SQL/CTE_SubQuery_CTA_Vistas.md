| [Previous](./SQL_Index.md) |[Back to Agenda](./SQL_Index.md)  | [Next](./Business_Case.md) |
| :---------|---------|---------: |



# SQL In Business Intelligence

## Why is it needed to know SQL?

  - It’s about learning how to **make your SQL more maintainable, readable, and trustable**. In doing so you will be creating SQL at a much higher level. You will be creating data sets, dashboards, and metrics that everyone in the company can rely on for more than just a few months.
  - More and more roles in companies are needing **to become at least conversationally fluent in SQL** — from product managers to data analysts. **The ability to extract insights from data is valuable in any position**.


## Order of SQL Operations

The logical order of operations is the following (leaving out vendor specific things like CONNECT BY, MODEL, MATCH_RECOGNIZE, PIVOT, UNPIVOT and all the others):
Operation | Description
---------|----------
  FROM/JOIN| **This is actually the first thing that happens, logically. Before anything else**, we’re loading all the rows from all the tables and join them. This is what happens first logically, not actually. The optimiser will very probably not do this operation first, that would be silly, but access some index based on the WHERE clause. But again, logically, this happens first. **Also: all the JOIN clauses are actually part of this FROM clause.** JOIN is an operator in relational algebra. Just like + and - are operators in arithmetics. It is not an independent clause, like SELECT or FROM
  WHERE | **Once we have loaded all the rows** from the tables above, **we can now throw them away** using WHERE
  GROUP BY | If you want, **you can take the rows that remain after WHERE and put them in groups or buckets, where each group contains the same value for the GROUP BY expression (and all the other rows are put in a list for that group)**.  Those columns in the list are only visible to aggregate functions that can operate upon that list. See below.
  Aggregations| This is important to understand. No matter where you put your aggregate function syntactically (i.e. in the SELECT clause, or in the ORDER BY clause), **this here is the step where aggregate functions are calculated. Right after GROUP BY.** (remember: logically. Clever databases may have calculated them before, actually). This explains why you cannot put an aggregate function in the WHERE clause, because its value cannot be accessed yet. The WHERE clause logically happens before the aggregation step. **Aggregate functions can access columns that you have put in “this list” for each group, above. After aggregation, “this list” will disappear and no longer be available.** 
  HAVING | … but now you can access aggregation function values. For instance, you can check that count(*) > 1 in the HAVING clause. Because **HAVING is after GROUP BY (or implies GROUP BY), we can no longer access columns or expressions that were not GROUP BY columns.**
  WINDOW | If you’re using the awesome window function feature, this is the step where they’re all calculated. Only now. And the cool thing is, **because we have already calculated (logically!) all the aggregate functions, we can nest aggregate functions in window functions.** It’s thus perfectly fine to write things like sum(count(*)) OVER () or row_number() OVER (ORDER BY count(*)). Window functions being logically calculated only now also explains why you can put them only in the SELECT or ORDER BY clauses. They’re not available to the WHERE clause, which happened before. Note that PostgreSQL and Sybase SQL Anywhere have an actual WINDOW clause!
  SELECT | Finally. **We can now use all the rows that are produced from the above clauses and create new rows / tuples from them using SELECT. We can access all the window functions that we’ve calculated, all the aggregate functions that we’ve calculated, all the grouping columns that we’ve specified, or if we didn’t group/aggregate, we can use all the columns from our FROM clause.** Remember: Even if it looks like we’re aggregating stuff inside of SELECT, this has happened long ago, and the sweet sweet count(*) function is nothing more than a reference to the result.
  DISTINCT | **This happens after SELECT, even if it is put before your SELECT column list, syntax-wise.** But think about it. It makes perfect sense. How else can we remove distinct rows, if we don’t know all the rows (and their columns) yet?
  UNION, INTERSECT, EXCEPT| This is a no-brainer. **A UNION is an operator that connects two subqueries.** Everything we’ve talked about thus far was a subquery. **The output of a union is a new query containing the same row types (i.e. same columns) as the first subquery.** 
  ORDER BY | **It makes total sense to postpone the decision of ordering a result until the end**, because all other operations might use hashmaps, internally, so any intermediate order might be lost again. So we can now order the result. Normally, you can access a lot of rows from the ORDER BY clause, including rows (or expressions) that you did not SELECT. But when you specified DISTINCT, before, you can no longer order by rows / expressions that were not selected. Why? Because the ordering would be quite undefined.
  OFFSET | Don’t use offset
  LIMIT, FETCH, TOP | Now, some databases put the LIMIT (MySQL, PostgreSQL) or FETCH (DB2, Oracle 12c, SQL Server 2012) clause at the very end, syntactically. In the old days, Sybase and SQL Server thought it would be a good idea to have TOP as a keyword in SELECT. As if the correct ordering of SELECT DISTINCT wasn’t already confusing enough. 

 ![Alt text](img/sql-queries.jpeg?raw=false "Title")

 
You can use window functions in SELECT and ORDER BY. However, you can't put window functions anywhere in the FROM, WHERE, GROUP BY, or HAVING clauses.

Sample with a problem according to rules:
```SQL
   	select a.customer_id,staff_id, amount,
       RANK() OVER (PARTITION BY a.staff_id ORDER BY a.amount desc ) AS valor 
           from (
			select
			  customer_id,
			  staff_id,
			  sum(amount) amount
			from public.payment
			group by customer_id, staff_id
			) a
		order by staff_id, amount desc;
```
There is an improvement that we can do here for window function and order by.
```SQL
    select
	  customer_id,
	  staff_id,
	  RANK() OVER (PARTITION BY staff_id ORDER BY sum(amount) desc ) AS valor,
	  sum(amount) amount
	from public.payment
	group by customer_id, staff_id
	order by staff_id, amount desc;
  ```
As the aggregate is calculated before the window function, we can use its value in the windows function, something similar happens with the order by.


#  CTE's (Common Table Expressions)

A Common Table Expression is a **temporary data set to be used as part of a query. It only exists during the execution of that query**; it cannot be used in other queries even within the same session

## - Applications 
 - A common table expression is a temporary result set **which you can reference within another SQL statement** including SELECT, INSERT, UPDATE or DELETE.

 - Common Table Expressions are temporary in the sense that **they only exist during the execution of the query**.

 - The following example shows the syntax of creating a CTE. This is a query example to get random inventory_id and rental_id to simulate that we have more than one inventory value for same rental:
  
```SQL
  with rentals as (
      select rental_id, rental_date, customer_id, return_date, staff_id, last_update 
      from public.rental
    ),
    inventory_rental as (
      select floor(random()*(1000-1+1))+1 as rental_id, floor(random()*(4581-1+1))+1 as inventory_id 
      from public.inventory i   
    )
    select r.rental_id, i.inventory_id, rental_date, customer_id, return_date, staff_id, last_update
    from inventory_rental i inner join rentals r on r.rental_id = i.rental_id;
```    
  
## - Advantages
  - Improve the readability of complex queries. You use CTEs to **organize complex queries in a more organized and readable manner**.
  - Ability to **create recursive queries**. Recursive queries are queries that reference themselves. The recursive queries come in handy when you want to query hierarchical data such as organization chart or bill of materials.
  - Use in conjunction with window functions. **You can use CTEs in conjunction with window functions** to create an initial result set and use another select statement to further process this result set.
 


## - Equivalences between databases
  - PostgreSQL creates  a temporary structure with the results of the query defined in the CTE, and only then applied the filter to it
  - Unlike PostgreSQL, Oracle is not materializing CTEs by default. It is needed to consider that **implementations can change depending on the database**.
```SQL
WITH cte AS (
  SELECT /*+ MATERIALIZE */ rental_id, rental_date, customer_id, return_date, staff_id, last_update 
      from public.rental
)
SELECT * FROM cte WHERE rental_id = 500000;
```
  - The behaviour illustrated above is often referred to as “push predicate”, “predicate push down” or “CTE inlining”.
    - Predicate push down means that the query optimizer can move predicates around based on logical rules in order generate better execution plans.
    - CTE inlining is when the query optimizer decides to inline a CTE as a subquery which, as we’ve seen above, makes it possible to push the predicate. 
  - PostgreSQL is not inlining CTEs.
  - In My SQL CTEs are similar to tables created with CREATE [TEMPORARY] TABLE but need not be defined or dropped explicitly. For a CTE, you need no privileges to create tables.
  - In SQL Server a CTE creates the table being used in memory, but is only valid for the specific query following it.


# - Sub Queries 

A subquery is a nested query, it’s a query within a query. This means **it gives a result from a query as a temporary data set which can be used again within that query.**

 ## - Applications 

- If we want a way **to pass the result of one first query to a second query in one query**. The solution is to use a subquery.
- A subquery is a query nested inside another query such as SELECT, INSERT, DELETE and UPDATE.
- To construct a subquery, **we put the second query in brackets**:

This is a query example to get random inventory_id and rental_id to simulate that we have more than one inventory value for same rental:
```SQL
  select r.rental_id, i.inventory_id, rental_date, customer_id, return_date, staff_id, last_update
    from (select floor(random()*(1000-1+1))+1 as rental_id, floor(random()*(4581-1+1))+1 as inventory_id 
           from public.inventory i) i 
           inner join public.rental r on r.rental_id = i.rental_id;
``` 
  - The query inside the brackets is called a **subquery or an inner query**. The query that contains the subquery is known as an outer query.

  - PostgreSQL executes the query that contains a subquery in the following sequence:

    - First, executes the subquery.
    - Second, gets the result and passes it to the outer query.
    - Third, executes the outer query.
     
## - Subquery with IN operator
  - A subquery can return zero or more rows. To use this subquery, you use the IN operator in the WHERE clause.

This query is recovering rented films between the dates '2005-05-24' and '2006-05-24'
```SQL
  select i.inventory_id, i.film_id, f.title 
   from public.inventory i inner join public.film f on i.film_id = f.film_id 
   where i.inventory_id in (
				   select distinct i.inventory_id 
				    from (select floor(random()*(1000-1+1))+1 as rental_id, floor(random()*(4581-1+1))+1 as inventory_id 
				           from public.inventory i) i 
				           inner join (select rental_id, rental_date, customer_id, return_date, staff_id, last_update 
				                         from public.rental) r on r.rental_id = i.rental_id
				                  where return_date between '2005-05-24' and '2006-05-24'
                          );
``` 
## - Subquery with EXISTS operator
  - A subquery can be an input of the EXISTS operator. **If the subquery returns any row, the EXISTS operator returns true. If the subquery returns no row, the result of EXISTS operator is false.**

  - The **EXISTS operator only cares about the number of rows returned from the subquery, not the content of the rows**, therefore, the common coding convention of EXISTS operator is as follows:


This query is recovering first name and last name of clients that have a payment for rentals
```SQL
  SELECT
	c.first_name, 
	c.last_name
  FROM public.rental r inner join public.customer c on r.customer_id = c.customer_id 
  WHERE
	EXISTS (
		SELECT
			1
		FROM
			public.payment p
		WHERE
			p.rental_id = r.rental_id
	);   
```
- The query works like an inner join on the rental_id column. However, **it returns at most one row for each row in the rental table even though there are some corresponding rows in the payment table.**
 
## - Exists vs. IN clause

- The Exists keyword evaluates true or false, but the IN keyword will compare all values in the corresponding subuery column.  **If you are using the IN operator, the SQL engine will scan all records fetched from the inner query. On the other hand, if we are using EXISTS, the SQL engine will stop the scanning process as soon as it found a match.**

- The **EXISTS subquery is used when we want to display all rows where we have a matching column in both tables**.  In most cases, **this type of subquery can be re-written with a standard join to improve performance.**

- The **EXISTS clause is much faster than IN when the subquery results is very large**. Conversely, **the IN clause is faster than EXISTS when the subquery results is very small**.

- Also, the **IN clause can't compare anything with NULL values, but the EXISTS clause can compare everything with NULLs.**



## - Common Table Expressions and Subqueries
 - **Both are tools for breaking up complex SQL queries**, and sometimes the only way to achieve a goal.
 - While CTEs are arguably easier to read than subqueries, **we will demostrate that they can have similar performance**.
  
  For example these queries are simulating rentals with different physical films, then that dataset is used in cte and subquery aggregates for comparison:
```SQL
create table  public.inventory_rental as
 select floor(random()*(64176-1+1))+1 as rental_id, floor(random()*(4581-1+1))+1 as inventory_id 
  from generate_series(1, 10000);


explain 
SELECT
  rental_id, count
FROM (SELECT rental_id, count(rental_id) count FROM public.inventory_rental 
      GROUP BY rental_id) aggregates
; 

HashAggregate  (cost=205.00..297.78 rows=9278 width=16)
  Group Key: inventory_rental.rental_id
  ->  Seq Scan on inventory_rental  (cost=0.00..155.00 rows=10000 width=8)

explain 
WITH aggregates AS 
  (SELECT rental_id, count(rental_id) count FROM public.inventory_rental 
   GROUP BY rental_id)
SELECT
  rental_id, count
FROM aggregates
; 

HashAggregate  (cost=205.00..297.78 rows=9278 width=16)
  Group Key: inventory_rental.rental_id
  ->  Seq Scan on inventory_rental  (cost=0.00..155.00 rows=10000 width=8)
```
They have similar execution plan.

So there you have it. **CTEs and subqueries are the exact same in terms of performance. Since in the CTE the query is on its own and not embedded within another FROM or JOIN statement**, it can help logically separate parts of your query.

So it’s all just syntactic sugar? Not quite. **What happens if we join to the aggregates twice. Can the compiler tell that it’s the same data set?**

```SQL

explain 
SELECT
  a.rental_id, a.count,  b.rental_id, b.count
FROM (SELECT rental_id, count(rental_id) count FROM public.inventory_rental 
      GROUP BY rental_id) a
     left join (SELECT rental_id, count(rental_id) count FROM public.inventory_rental 
      GROUP BY rental_id) b on a.rental_id = b.rental_id
; 

Hash Left Join  (cost=711.53..921.96 rows=430406 width=32)
  Hash Cond: (inventory_rental.rental_id = inventory_rental_1.rental_id)
  ->  HashAggregate  (cost=205.00..297.78 rows=9278 width=16)
        Group Key: inventory_rental.rental_id
        ->  Seq Scan on inventory_rental  (cost=0.00..155.00 rows=10000 width=8)
  ->  Hash  (cost=390.56..390.56 rows=9278 width=16)
        ->  HashAggregate  (cost=205.00..297.78 rows=9278 width=16)
              Group Key: inventory_rental_1.rental_id
              ->  Seq Scan on inventory_rental inventory_rental_1  (cost=0.00..155.00 rows=10000 width=8)

explain 
WITH aggregates AS 
  (SELECT rental_id, count(rental_id) count FROM public.inventory_rental 
   GROUP BY rental_id)
SELECT
  a.rental_id, a.count,  b.rental_id, b.count
FROM aggregates a 
 left join aggregates b on a.rental_id = b.rental_id
; 

SET enable_sort = off;

Hash Left Join  (cost=599.32..15874.61 rows=430406 width=32)
  Hash Cond: (a.rental_id = b.rental_id)
  CTE aggregates
    ->  HashAggregate  (cost=205.00..297.78 rows=9278 width=16)
          Group Key: inventory_rental.rental_id
          ->  Seq Scan on inventory_rental  (cost=0.00..155.00 rows=10000 width=8)
  ->  CTE Scan on aggregates a  (cost=0.00..185.56 rows=9278 width=16)
  ->  Hash  (cost=185.56..185.56 rows=9278 width=16)
        ->  CTE Scan on aggregates b  (cost=0.00..185.56 rows=9278 width=16)
```
  ## Note
      enable_sort (boolean)
      Enables or disables the query planner's use of explicit sort steps. It is impossible to suppress explicit sorts entirely, but turning this variable off discourages the planner from using one if there are other methods available. The default is on.

Notice right away that **the query with the CTE is easier to read and has less redundancy**. When I ran this, the CTE statement scanned 599.32 to 15874.61 while the subquery one scanned 711.53 to 921.96. Why is this? **In the CTE query, the compiler knows you’re querying the same data set since it has saved it (albeit temporarily) as aggregates. In the second query, even though the SQL is the exact same, the compiler does not realize they’re the same query until it runs them**. Notice that we have to call the same query by the two distinct aliases: t1 and t2. Not only does this query take more compute and contain redundancy, it also forces us to call the same query two different names. This is misleading; life is much better when both the SQL compiler and your coworkers know when you’re using the same data set rather than creating a new one.

My general advice would be to only **use subqueries in adhoc queries when you need results quickly. If the query is going to be read by others, run every day, or reused, try to use a CTE for readability and performance**. Performance may not kick in until the CTE is used twice, but if the second JOIN has to be built in, your syntax will allow for that development more easily.

# - CTAS (CREATE TABLE AS SELECT)

Define a new table from the results of a query.

 ## - Applications 
  - CTAS(CREATE TABLE AS SELECT) statement **is used to create a table from an existing table by copying the existing table's columns**
  - The **table columns have the names and data types associated with the output columns of the SELECT** (except that you can override the column names by giving an explicit list of new column names).
  - it creates a new table and evaluates the query just once to fill the new table initially. **The new table will not track subsequent changes to the source tables of the query**. In contrast, a view re-evaluates its defining SELECT sttatement whenever it is queried.
  - The TEMPORARY or TEMP keyword allows you to to create a temporary table
  - The following shows the syntax example of creating a CTA:
  
  This is a query example to get random inventory_id and rental_id to simulate that we have more than one inventory value for same rental:
```SQL
  create table rental_inventory as 
  with rentals as (
      select rental_id, rental_date, customer_id, return_date, staff_id, last_update 
      from public.rental
    ),
    inventory_rental as (
      select floor(random()*(1000-1+1))+1 as rental_id, floor(random()*(4581-1+1))+1 as inventory_id 
      from public.inventory i   
    )
    select r.rental_id, i.inventory_id, rental_date, customer_id, return_date, staff_id, last_update
    from inventory_rental i inner join rentals r on r.rental_id = i.rental_id;
```  

 ## - Equivalences between databases
  - Similar usage in Oracle
  - In SQL Server you can use syntax "SELECT INTO"
  - Similar Usage in MySQL

#  Views

A view is a database object that **is of a stored query**.

 ## - Applications
  - When you create a view, **you basically create a query and assign it a name, therefore a view is useful for wrapping a commonly used complex query.**
  - Regular views **do not store any data** except the materialized views. In PostgreSQL, **you can create special views called materialized views that store data physically and periodically refresh data from the base tables.**
  - The following shows the syntax example of creating a View:
  
This is a query example to get random inventory_id and rental_id to simulate that we have more than one inventory value for same rental:  
```SQL
  create view rental_inventory_v  as 
  with rentals as (
      select rental_id, rental_date, customer_id, return_date, staff_id, last_update 
      from public.rental
    ),
    inventory_rental as (
      select floor(random()*(1000-1+1))+1 as rental_id, floor(random()*(4581-1+1))+1 as inventory_id 
      from public.inventory i   
    )
    select r.rental_id, i.inventory_id, rental_date, customer_id, return_date, staff_id, last_update
    from inventory_rental i inner join rentals r on r.rental_id = i.rental_id;
```  
 ## - Advantages
  - A view helps **simplify the complexity of a query because you can query a view, which is based on a complex query**, using a simple SELECT statement.
  - Like a table, **you can grant permission to users through a view** that contains specific data that the users are authorized to see.
  - A view provides a **consistent layer even the columns of underlying table changes**.

 
#  Materialized Views

They are **similar to regular views, in that they are a logical view of your data (based on a select statement)**, however, **the underlying query result set has been saved to a table**. The upside of this is that when you query a materialized view, you are querying a table, **which may also be indexed**.

This is a query example to get random inventory_id and rental_id to simulate that we have more than one inventory value for same rental:  

```SQL
CREATE MATERIALIZED VIEW mymatview AS 
with rentals as (
      select rental_id, rental_date, customer_id, return_date, staff_id, last_update 
      from public.rental
    ),
    inventory_rental as (
      select floor(random()*(1000-1+1))+1 as rental_id, floor(random()*(4581-1+1))+1 as inventory_id 
      from public.inventory i   
    )
    select r.rental_id, i.inventory_id, rental_date, customer_id, return_date, staff_id, last_update
    from inventory_rental i inner join rentals r on r.rental_id = i.rental_id;
```

 ## - Applications
- In addition, because **all the joins have been resolved at materialized view refresh time, you pay the price of the join once (or as often as you refresh your materialized view)**, rather than each time you select from the materialized view.
- In situations where you create materialized views **as forms of aggregate tables, or as copies of frequently executed queries, this can greatly speed up the response time of your end user application**. The downside though is that the data you get back from the **materialized view is only as up to date as the last time the materialized view has been refreshed.**
- Materialized views are most often used in data warehousing / business intelligence applications **where querying large fact tables with thousands of millions of rows would result in query response times that resulted in an unusable application.**
- The materialized views are very useful in many scenarios such as **faster data access to a remote server and caching**.

 ## - How to refresh
- Materialized views **can be set to refresh manually, on a set schedule, or based on the database detecting a change in data from one of the underlying tables**. Materialized views can be incrementally updated by combining them with materialized view logs, which act as change data capture sources on the underlying tables.


A job could be scheduled to update the statistics each night using this SQL statement in Postgres:

```SQL
REFRESH MATERIALIZED VIEW mymatview;
```

| [Previous](./SQL_Index.md) |[Back to Agenda](./SQL_Index.md)  | [Next](./Business_Case.md) |
| :---------|---------|---------: |