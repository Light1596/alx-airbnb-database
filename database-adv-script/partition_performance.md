# Booking Table Partitioning Performance Analysis

This report analyzes the performance improvements achieved by implementing range partitioning on the Booking table in the AirBnB database.

## Partitioning Strategy

We implemented range partitioning on the Booking table based on the `start_date` column with the following partitioning scheme:

1. **Quarterly partitions** for 2024 and 2025 (8 partitions)  
2. **Historical partition** for dates before 2024  
3. **Future partition** for dates after 2025  

This partitioning strategy was chosen because:  
- Booking queries are frequently filtered by date ranges  
- Date-based partitioning aligns with business reporting periods (quarterly)  
- Current date (May 2025) falls within one of the quarters, optimizing recent booking queries  

## Performance Testing Methodology

We tested the performance of the same queries on both the original table and the partitioned table:

1. **Date Range Query**: Fetching all bookings within Q1 2025  
2. **Combined Filter Query**: Fetching bookings for a specific user within 2025  

Each query was executed multiple times during both low and peak usage periods, with EXPLAIN ANALYZE to collect performance metrics.

## Performance Results

### Date Range Query (Q1 2025)

```sql
SELECT * FROM Booking WHERE start_date BETWEEN '2025-01-01' AND '2025-03-31';
