| [Previous](./Analytical_Functions.md) |[Back to Agenda](./SQL_Index.md) | [Next](./Table_Indexes.md) |
| :---------|---------|---------: |

# Table Partitioning

## -  Overview
Partitioning refers to **splitting what is logically one large table into smaller physical pieces**. 

## Benefits:

- **Query performance can be improved dramatically in certain situations**, particularly **when most of the heavily accessed rows of the table are in a single partition or a small number of partitions.** The partitioning substitutes for leading columns of indexes, reducing index size and **making it more likely that the heavily-used parts of the indexes fit in memory**.

- When **queries or updates access a large percentage of a single partition, performance can be improved by taking advantage of sequential scan of that partition** instead of using an index and random access reads scattered across the whole table.

- **Bulk loads and deletes can be accomplished by adding or removing partitions**, if that requirement is planned into the partitioning design. Doing ALTER TABLE DETACH PARTITION or **dropping an individual partition using DROP TABLE is far faster than a bulk operation**. These commands also entirely avoid the VACUUM overhead caused by a bulk DELETE.

- **Seldom-used data can be migrated to cheaper and slower storage media**.

The benefits will normally be worthwhile only when a table would otherwise be very large. The exact point at which a table will benefit from partitioning depends on the application, although **a rule of thumb is that the size of the table should exceed the physical memory of the database server.**

## -  Should A Table Be Partitioned?
 **Partitioning can drastically improve performance on a table when done right**, but if done wrong or when not needed, it can make performance worse, even unusable.

  - How big is the table?
  
  There is no real hardline rule for how big a table must be before partitioning is an option, but based on database access trends, **database users and administrators will start to see performance on a specific table start to degrade as it gets bigger**. In general, partitioning should only be considered when **someone says “I can’t do X because the table is too big.”**

  - Is table bloat an issue?
  
  Updated and deleted rows results in dead tuples that ultimately need to be cleaned up. They must be scanned each time a vacuum is run. **Partitioning the table can help reduce the table that needs vacuuming to smaller ones, reducing the amount of unchanging data needing to be scanned, less time vacuuming overall, and more system resources freed up for user access** rather than system maintenance.
  
  - How is Data Deleted, if at all?

  If data is deleted on a schedule, say data older than 4 years get deleted and archived, this could result in heavy hitting delete statements that can take time to run, and as mentioned before, creating dead rows that need to be vacuumed. If a good partitioning strategy is implemented, **a multi- hour DELETE statement with vacuuming maintenance afterward could be turned into a one minute DROP TABLE statement on a old monthly table with zero vacuum maintenance**.

  - How Should The Table Be Partitioned?

  The **keys for access patterns are in the WHERE clause and JOIN conditions**. Any time a query specifies **columns in the WHERE and JOIN clauses**, it tells the database “this is the data I want”. Much like designing indexes that target these clauses, **partitioning strategies rely on targeting these columns to separate data and have the query access as few partitions as possible.**

  Examples:

     - A **transaction table, with a date column** that is always used in a where clause.
     - A **customer table with location columns, such as country of residence** that is always used in where clauses.
The **most common columns to focus on for partitioning are usually timestamps, since usually a huge chunk of data is historical information**, and likely will have a rather **predictable data spread across different time groupings**.

- Determine the Data Spread
  
Once we identify which columns to partition on we should take a look at the spread of data, with **the goal of creating partition sizes that spread the data as evenly as possible across the different child partitions**.

```SQL
select extract(year from payment_date), count(1) 
from public.payment
group by extract(year from payment_date);

date_part count
2008.0	  29192
2007.0	  29192
```

In this example, we truncate the timestamp column to a yearly table, resulting in about 30 thousand rows per year (They could be millions). **If all of our queries specify a date(s), or date range(s), and those specified usually cover data within a single year, this may be a great starting strategy for partitioning, as it would result in a single table per year, with a manageable number of rows per table**.

 ## - Declarative Partitioning
 
  PostgreSQL offers a way to specify how to divide a table into pieces called partitions. The table that is divided is referred to as a partitioned table. **The specification consists of the partitioning method and a list of columns or expressions to be used as the partition key.**

  All **rows inserted into a partitioned table will be routed to one of the partitions based on the value of the partition key**. Each partition has a subset of the data defined by its partition bounds. Currently supported **partitioning methods include range, list and hash, where each partition is assigned a range of keys, a list of keys and a hash function on the values, respectively.**

  Partitions may themselves be defined as partitioned tables, using what is called sub-partitioning. Partitions may have their own indexes, constraints and default values, distinct from those of other partitions. Indexes must be created separately for each partition.


## - Three Partitioning Methods
Postgres provides three built-in partitioning methods:

- Range Partitioning: **Partition a table by a range of values**. This is **commonly used with date fields, e.g., a table containing sales data that is divided into monthly partitions** according to the sale date.

```SQL

CREATE TABLE rental_part (
    rental_id int4 NOT NULL,
	rental_date timestamp NOT NULL,
	inventory_id int4 NOT NULL,
	customer_id int2 NOT NULL,
	return_date timestamp NULL,
	staff_id int2 NOT NULL,
	last_update timestamp NOT NULL DEFAULT now()
) PARTITION BY RANGE(rental_date);


CREATE TABLE rental_2005 PARTITION OF rental_part FOR VALUES FROM ('2005-01-01') TO ('2005-12-31');

CREATE TABLE rental_2006 PARTITION OF rental_part FOR VALUES FROM ('2006-01-01') TO ('2006-12-31');

CREATE TABLE rental_2007 PARTITION OF rental_part FOR VALUES FROM ('2007-01-01') TO ('2007-12-31');

CREATE TABLE rental_others PARTITION OF rental_part DEFAULT;

insert into rental_part
select  rental_id,	rental_date, inventory_id, 	customer_id, return_date, staff_id, last_update from  rental;
commit;

 ```

   Check data for specific partitions
  ```SQL   
  select extract(year from rental_date), count(1) 
  from rental_2007
  group by extract(year from rental_date);
   ```

  Check data for all partitions
  ```SQL
   select extract(year from rental_date), count(1) 
   from rental_part
   group by extract(year from rental_date);
   ```


- List Partitioning: **Partition a table by a list of known values**. This is **typically used when the partition key is a categorical value, e.g., a global sales table divided into regional partitions**. The partition key in this case can be the country or city code, and each partition will define the list of codes that map to it.
  ```SQL 
  create table  public.customer_part 
  (customer_id int2 NOT NULL,
	store_id int2 NOT NULL,
	first_name varchar(45) NOT NULL,
	last_name varchar(45) NOT NULL,
	email varchar(50) NULL,
	address_id int2 NOT NULL,
	activebool bool NOT NULL DEFAULT true,
	create_date date NOT NULL DEFAULT 'now'::text::date,
	last_update timestamp NULL DEFAULT now(),
	active int4 NULL) 
    PARTITION BY LIST(active);

  CREATE TABLE cust_active PARTITION OF customer_part FOR VALUES IN (1);
  CREATE TABLE cust_archived PARTITION OF customer_part FOR VALUES IN (0);
  CREATE TABLE cust_others PARTITION OF customer_part DEFAULT;

  insert into customer_part
  select customer_id,	store_id, first_name, 	last_name, 	email, 	address_id,	activebool,	create_date,	last_update,	active from  customer;
  commit;
  ```

  Check data for specific partitions
  ```SQL
   select *
   from cust_archived;

   select *
   from cust_active;
   ```

  Check data for all partitions
  ```SQL
   select active, count(*)
   from customer_part
   group by active;
   ```

- Hash Partitioning: **Partition a table using a hash function on the partition key. This is especially useful when there is no obvious way of dividing data into logically similar groups and is often used on categorical partitioning keys that are accessed individually**. E.g., if a sales table is often accessed by product, the table might benefit from a hash partition on the product SKU. **Hash paritioning is great when you have many different values.**
  
  Hash type partitions **distribute the rows based on the hash value of the partition key. The remainder of the hash value when divided by a specified integer is used to calculate which partition the row goes into** (or can be found in).:



```SQL
  CREATE TABLE customers_part_h (
    customer_id varchar(100) NOT NULL,,
	store_id int2 NOT NULL,
	first_name varchar(45) NOT NULL,
	last_name varchar(45) NOT NULL,
	email varchar(50) NULL,
	address_id int2 NOT NULL,
	activebool bool NOT NULL DEFAULT true,
	create_date date NOT NULL DEFAULT 'now'::text::date,
	last_update timestamp NULL DEFAULT now(),
	active int4 null
	) PARTITION BY HASH(customer_id);

CREATE TABLE customers_part_h1 PARTITION OF customers_part_h FOR VALUES WITH (modulus 3, remainder 0);

CREATE TABLE customers_part_h2 PARTITION OF customers_part_h FOR VALUES WITH (modulus 3, remainder 1);

CREATE TABLE customers_part_h3 PARTITION OF customers_part_h FOR VALUES WITH (modulus 3, remainder 2);


insert into customers_part_h
select md5(concat(last_name, first_name)) as customer_id,	store_id, first_name, 	last_name, 	email, 	address_id,	activebool,	create_date,	last_update,	active from  customer;
commit;


```
Check data distribution. We expect each partition to contain about a third of all the rows

```SQL
select count(1)
from customers_part_h;

select count(1)
from customers_part_h1;

select count(1)
from customers_part_h2;

select count(1)
from customers_part_h3;

```

Deciding on the partitioning key and method is crucial to performance, as, when set correctly, partitions can have a significant positive effect on performance and manageability.


This way of creating partitions is called “declarative partitioning.” Prior to Postgres 10, only EDB Postgres Advanced Server provided declarative partitioning syntax. In open source PostgreSQL, partitioned tables were declared using table inheritance. Declarative partitions are a bit more restricted than inheritance-based partitions, but they are easier to understand and maintain and are suitable for most use cases.

If your application needs to use other forms of partitioning not listed above, **alternative methods such as inheritance and UNION ALL views can be used instead. Such methods offer flexibility but do not have some of the performance benefits of built-in declarative partitioning.**

| [Previous](./Analytical_Functions.md) |[Back to Agenda](./SQL_Index.md) | [Next](./Table_Indexes.md) |
| :---------|---------|---------: |
