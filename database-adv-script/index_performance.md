# Index Performance Optimization

## Objective
Improve database query performance by identifying and creating indexes on high-usage columns.

---

## 1. Identified High-Usage Columns

| Table     | Column         | Reason for Indexing                      |
|-----------|----------------|------------------------------------------|
| User      | email          | Used frequently for authentication/login |
| Booking   | user_id        | In WHERE, JOIN conditions                |
| Booking   | property_id    | For joins and filtering bookings         |
| Property  | location       | Used in search filters                   |
| Booking   | status         | For filtering by booking state           |
| Property  | name           | For ORDER BY or filtering                |

---

## 2. SQL Index Creation

Indexes were implemented using the following SQL commands:

```sql
CREATE INDEX idx_user_email ON User(email);
CREATE INDEX idx_booking_user_id ON Booking(user_id);
CREATE INDEX idx_booking_property_id ON Booking(property_id);
CREATE INDEX idx_property_location ON Property(location);
CREATE INDEX idx_booking_status ON Booking(status);
CREATE INDEX idx_property_name ON Property(name);
