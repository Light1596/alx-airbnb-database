# Index Optimization for the AirBnB Database

This document describes the creation of indexes to enhance query efficiency in the AirBnB database.

## High-Usage Columns Identified

Based on an analysis of application query patterns, the following key columns were selected for indexing:

- **User Table**  
  - *email:* Frequently used for login and user searches.

- **Property Table**  
  - *location:* Commonly used as a search filter.  
  - *price_per_night:* Utilized in range-based property searches.

- **Booking Table**  
  - *start_date* and *end_date:* Used to check availability.  
  - *user_id:* Joins with the User table.  
  - *property_id:* Joins with the Property table.

- **Review Table**  
  - *property_id:* Joins with the Property table.  
  - *user_id:* Joins with the User table.  
  - *rating:* Used for sorting and filtering.

## Index Creation

Indexes were added as follows (refer to `database_index.sql`):

```sql
-- User table
CREATE INDEX idx_user_email ON User(email);

-- Property table
CREATE INDEX idx_property_location ON Property(location);
CREATE INDEX idx_property_price ON Property(price_per_night);

-- Booking table
CREATE INDEX idx_booking_dates ON Booking(start_date, end_date);
CREATE INDEX idx_booking_user ON Booking(user_id);
CREATE INDEX idx_booking_property ON Booking(property_id);

-- Review table
CREATE INDEX idx_review_property ON Review(property_id);
CREATE INDEX idx_review_user ON Review(user_id);
CREATE INDEX idx_review_rating ON Review(rating);
