| [Previous](./Table_Partitioning.md) |[Back to Agenda](./SQL_Index.md) 
| :---------|---------: |
 # Table Indexes

 Indexes are a common way to enhance database performance. **An index allows the database server to find and retrieve specific rows much faster than it could do without an index.** But indexes **also add overhead to the database system as a whole, so they should be used sensibly**.
   
# -Indexes types

There are several index types, **most common are B-TREE, HASH and BITMAP. Each index type uses a different algorithm that is best suited to different types of queries**. By default, the CREATE INDEX command creates **B-tree indexes, which fit the most common situations**.

 ###  - B-Tree
  
  B-trees **can handle equality and range queries on data that can be sorted into some ordering**. In particular, the PostgreSQL query planner will consider using a B-tree index whenever an indexed column is involved in a comparison using one of these operators:

```SQL
<
<=
=
>=
>
```
Constructs equivalent to **combinations of these operators, such as BETWEEN and IN**, can also be implemented with a B-tree index search. Also, an **IS NULL or IS NOT NULL** condition on an index column can be used with a B-tree index.

 ![Alt text](img/b_tree.jpg?raw=false "Title")

B-Tree is the default and the most commonly used index type. **Specifying a primary key or a unique within a CREATE TABLE statement causes PostgreSQL to create B-Tree indexes**. CREATE INDEX statements without the USING clause will also create B-Tree indexes:

 ```SQL
 -- the default index type is btree
CREATE INDEX idx_year ON public.film (release_year);

-- equivalent, explicitly lists the index type
CREATE INDEX idx_year ON public.film USING btree (release_year);
  ```

- Ordering

**B-tree indexes can also be used to retrieve data in sorted order. This is not always faster than a simple scan and sort, but it is often helpful**. B-Tree indexes are inherently ordered. PostgreSQL can make use of this order rather than sorting on the indexed expression. For example, getting the titles of all 80s movies sorted by title would require a sort:

```SQL
explain select title from public.film where release_year between 1980 and 1989 order by title asc;

Plan
Sort  (cost=8.30..8.31 rows=1 width=15)
  Sort Key: title
  ->  Index Scan using idx_year on film  (cost=0.28..8.29 rows=1 width=15)
        Index Cond: (((release_year)::integer >= 1980) AND ((release_year)::integer <= 1989))
```

But if you’re sorting them by the indexed column (year), additional sort is not required.
```SQL
explain select title from public.film where release_year between 1980 and 1989 order by release_year asc;

Plan 
Index Scan using idx_year on film  (cost=0.28..8.29 rows=1 width=19)
  Index Cond: (((release_year)::integer >= 1980) AND ((release_year)::integer <= 1989))

```

**B-tree indexes are valuable on the most common data types such as text, numbers, and timestamps**

-  Indexing on Text

B-Tree indexes can help in prefix matching of text. Let’s take a query to list all the movies starting with the letter ‘T’:

```SQL
explain select title from public.film where title like 'T%';

Plan 
Seq Scan on film  (cost=0.00..66.50 rows=40 width=15)
  Filter: ((title)::text ~~ 'T%'::text)
```

This plan calls for a full sequential scan of the table. What happens if we add a B-Tree index on movies.title?
```SQL
CREATE INDEX idx_title ON public.film USING btree (title)

Plan 
Seq Scan on film  (cost=0.00..66.50 rows=40 width=15)
  Filter: ((title)::text ~~ 'T%'::text)

```
Well, that didn’t help at all. However, there is a way that we can use to get Postgres to do what we want:

```SQL
create index idx_title2 on public.film (title text_pattern_ops);

Plan
Bitmap Heap Scan on film  (cost=4.69..58.10 rows=40 width=15)
  Filter: ((title)::text ~~ 'T%'::text)
  ->  Bitmap Index Scan on idx_title2  (cost=0.00..4.68 rows=40 width=0)
        Index Cond: (((title)::text ~>=~ 'T'::text) AND ((title)::text ~<~ 'U'::text))
```
The plan now uses an index, and the cost has reduced. **The magic here is “text_pattern_ops” which allows the B-Tree index over a “text” expression to be used for pattern operators (LIKE and regular expressions). The “text_pattern_ops” is called an Operator Class.**

Note that this will work only for patterns with a fixed text prefix, so “%Angry%” or “%Men” will not work. Use PostgreSQL’s full text search for advanced text queries.

###  - Hash

Hash indexes at times can provide faster lookups than B-Tree indexes, and can boast faster creation times as well. The big issue with them is **they’re limited to only equality operators so you need to be looking for exact matches. This makes hash indexes far less flexible than the more commonly used B-Tree indexes** and something you won’t want to consider as a drop-in replacement but rather a special case.

Because hash functions **is non-linear, such index cannot be sorted. This causes inability to use the comparisons more/less and “IS NULL” with this index**. In addition, **since the hashes are not unique, then the matching hashes used methods of resolving conflicts**.

![Alt text](img/hash_.jpg?raw=false "Title")

**Hash indexes can only handle simple equality comparisons. The query planner will consider using a hash index whenever an indexed column is involved in a comparison using the = operator**. The following command is used to create a hash index:
  ```SQL
  CREATE INDEX idx_username ON public.staff USING hash (username);

  explain select * from public.staff where username = 'Mike'

  ```
    - Caution
  
    Hash index operations are not presently WAL-logged (Before Postgres 10), so **hash indexes might need to be rebuilt with REINDEX after a database crash if there were unwritten changes**. Also, changes to hash indexes are not replicated over streaming or file-based replication after the initial base backup, so they give wrong answers to queries that subsequently use them. For these reasons, hash index use is presently discouraged.

## Bitmap Index

In contrast to B-tree, the **bitmap index is designed for cases where the values of a variable repeat very frequently**. For example, the sex field in a customer database usually contains at most three distinct values: male, female or unknown (not recorded). For such variables, the bitmap index can have a significant performance advantage over the commonly used trees.

 

Compared to tree-based indexing algorithms, on-disk bitmap indexes provide a substantial space and performance advantage for low-cardinality, read-mostly data. **The reason for this advantage is due primarily to I/O and CPU savings.**

Advantages:

- Compact representation (small amount of disk space)
- Fast reading and searching for the predicate “is”
- Effective algorithms for packing masks (even more compact representation, than indexed data)

Disadvantages:

- You can not change the method of encoding values in the process of updating the data. From this it follows that if the distribution data has changed, it is required the index to be completely rebuild

PostgreSQL is not provide persistent bitmap index. But it can be used in database to combine multiple indexes. PostgreSQL scans each needed index and prepares a bitmap in memory giving the locations of table rows that are reported as matching that index’s conditions. The bitmaps are then ANDed and ORed together as needed by the query. Finally, the actual table rows are visited and returned.

 
###  Which do you use?
We just covered a lot and if you’re a bit overwhelmed you’re not alone. If all you knew before was CREATE INDEX you’ve been using B-Tree indexes all along, and the good news is you’re still performing as well or better than most databases that aren’t Postgres :) As you start to use more Postgres features consider this a cheatsheet for when to use other Postgres types:

- B-Tree - For most datatypes and queries

- GIN - For JSONB/hstore/arrays

- GiST - For full text search and geospatial datatypes

- SP-GiST - For larger datasets with natural but uneven clustering

- BRIN - For really large datasets that line up sequentially

- Hash - For equality operations, and generally B-Tree still what you want here

| [Previous](./Table_Partitioning.md) |[Back to Agenda](./SQL_Index.md) 
| :---------|---------: |