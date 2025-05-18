# Database Performance Monitoring and Refinement

This document outlines the process of monitoring, identifying bottlenecks, and implementing improvements for database performance in the AirBnB database project. The focus is on frequently used queries that are critical for application performance.

---

## 1. Performance Monitoring Approach

We used a combination of the following SQL commands and techniques to monitor the performance of critical queries:

* `EXPLAIN ANALYZE`: To examine query execution plans and actual execution times.
* `SHOW PROFILE`: To get detailed information about resource usage during query execution.
* Query log analysis: To identify frequently executed and slow queries.

---

## 2. Frequently Used Queries Analysis

### 2.1. Property Search Query

This query is executed whenever users search for properties based on location, date availability, and guest count:

```sql
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location, p.price_per_night, 
       AVG(r.rating) as avg_rating, COUNT(r.review_id) as review_count
FROM Property p
LEFT JOIN Review r ON p.property_id = r.property_id
WHERE p.location LIKE '%New York%'
  AND p.max_guests >= 2
  AND NOT EXISTS (
    SELECT 1 FROM Booking b
    WHERE b.property_id = p.property_id
    AND (b.start_date <= '2025-06-01' AND b.end_date >= '2025-05-25')
  )
GROUP BY p.property_id, p.name, p.location, p.price_per_night
ORDER BY avg_rating DESC NULLS LAST
LIMIT 20;
```

**Execution Plan (Before Optimization):**

```
Limit  (cost=1519.78..1519.83 rows=20 width=72) (actual time=324.582..324.589 rows=20 loops=1)
  ->  Sort  (cost=1519.78..1526.95 rows=2868 width=72) (actual time=324.580..324.584 rows=20 loops=1)
        Sort Key: (avg(r.rating)) DESC NULLS LAST
        Sort Method: top-N heapsort  Memory: 28kB
        ->  GroupAggregate  (cost=1405.14..1490.17 rows=2868 width=72) (actual time=256.741..322.846 rows=242 loops=1)
              Group Key: p.property_id, p.name, p.location, p.price_per_night
              ->  Nested Loop Left Join  (cost=1405.14..1476.15 rows=2868 width=68) (actual time=256.712..322.005 rows=1932 loops=1)
                    ->  Seq Scan on Property p  (cost=1404.71..1414.74 rows=287 width=48) (actual time=256.529..320.308 rows=242 loops=1)
                          Filter: ((max_guests >= 2) AND (location ~~ '%New York%'::text) AND (NOT (SubPlan 1)))
                          Rows Removed by Filter: 1758
                          SubPlan 1
                            ->  Seq Scan on Booking b  (cost=0.00..4.85 rows=1 width=0) (actual time=0.073..0.073 rows=0 loops=2000)
                                  Filter: ((property_id = p.property_id) AND (start_date <= '2025-06-01'::date) AND (end_date >= '2025-05-25'::date))
                    ->  Index Scan using review_property_idx on Review r  (cost=0.42..0.47 rows=10 width=28) (actual time=0.002..0.004 rows=8 loops=242)
                          Index Cond: (property_id = p.property_id)
Planning Time: 0.902 ms
Execution Time: 324.652 ms
```

**Identified Bottlenecks:**

1. Sequential scan on Property table for location filtering.
2. Subquery for booking availability check executed for every Property row (nested loop).
3. Sorting operation for average rating performed on entire result set.

---

### 2.2. User Booking History Query

This query is executed when users view their booking history:

```sql
EXPLAIN ANALYZE
SELECT b.booking_id, p.name as property_name, p.location,
       b.start_date, b.end_date, b.total_price,
       r.rating, r.comment
FROM Booking b
JOIN Property p ON b.property_id = p.property_id
LEFT JOIN Review r ON b.booking_id = r.booking_id
WHERE b.user_id = 42
ORDER BY b.start_date DESC;
```

**Execution Plan (Before Optimization):**

```
Sort  (cost=479.15..480.23 rows=432 width=372) (actual time=112.458..112.463 rows=24 loops=1)
  Sort Key: b.start_date DESC
  Sort Method: quicksort  Memory: 36kB
  ->  Hash Left Join  (cost=356.63..462.88 rows=432 width=372) (actual time=89.331..112.427 rows=24 loops=1)
        Hash Cond: (b.booking_id = r.booking_id)
        ->  Hash Join  (cost=329.84..429.68 rows=432 width=340) (actual time=87.257..110.236 rows=24 loops=1)
              Hash Cond: (b.property_id = p.property_id)
              ->  Seq Scan on Booking b  (cost=0.00..93.10 rows=432 width=28) (actual time=0.023..22.954 rows=24 loops=1)
                    Filter: (user_id = 42)
                    Rows Removed by Filter: 876
              ->  Hash  (cost=230.00..230.00 rows=8000 width=320) (actual time=87.185..87.185 rows=2000 loops=1)
                    Buckets: 1024  Batches: 1  Memory Usage: 913kB
                    ->  Seq Scan on Property p  (cost=0.00..230.00 rows=8000 width=320) (actual time=0.012..85.106 rows=2000 loops=1)
        ->  Hash  (cost=22.30..22.30 rows=430 width=40) (actual time=2.057..2.057 rows=430 loops=1)
              Buckets: 1024  Batches: 1  Memory Usage: 33kB
              ->  Seq Scan on Review r  (cost=0.00..22.30 rows=430 width=40) (actual time=0.011..2.011 rows=430 loops=1)
Planning Time: 0.531 ms
Execution Time: 112.518 ms
```

**Identified Bottlenecks:**

1. Sequential scan on Booking table filtering by user\_id.
2. Sequential scan on Property table for joining.
3. Sequential scan on Review table for left joining.

---

### 2.3. Property Dashboard Query

This query is used for hosts to view the performance of their properties:

```sql
EXPLAIN ANALYZE
SELECT p.property_id, p.name, p.location,
       COUNT(b.booking_id) as booking_count,
       SUM(b.total_price) as total_revenue,
       AVG(r.rating) as average_rating
FROM Property p
LEFT JOIN Booking b ON p.property_id = b.property_id
LEFT JOIN Review r ON p.property_id = r.property_id
WHERE p.host_id = 123
GROUP BY p.property_id, p.name, p.location;
```

**Execution Plan (Before Optimization):**

```
HashAggregate  (cost=796.44..799.07 rows=5 width=72) (actual time=156.723..156.731 rows=8 loops=1)
  Group Key: p.property_id, p.name, p.location
  ->  Hash Left Join  (cost=363.18..791.99 rows=178 width=72) (actual time=89.346..156.645 rows=86 loops=1)
        Hash Cond: (p.property_id = r.property_id)
        ->  Hash Left Join  (cost=302.15..726.23 rows=5 width=44) (actual time=88.258..155.463 rows=8 loops=1)
              Hash Cond: (p.property_id = b.property_id)
              ->  Seq Scan on Property p  (cost=0.00..419.00 rows=5 width=28) (actual time=42.365..109.348 rows=8 loops=1)
                    Filter: (host_id = 123)
                    Rows Removed by Filter: 1992
              ->  Hash  (cost=264.00..264.00 rows=3052 width=16) (actual time=45.859..45.859 rows=3052 loops=1)
                    Buckets: 4096  Batches: 1  Memory Usage: 165kB
                    ->  Seq Scan on Booking b  (cost=0.00..264.00 rows=3052 width=16) (actual time=0.010..44.744 rows=3052 loops=1)
        ->  Hash  (cost=46.30..46.30 rows=1190 width=36) (actual time=1.073..1.073 rows=1190 loops=1)
              Buckets: 2048  Batches: 1 
```
