# Database Normalization - alx-airbnb-database

## Objective
To apply normalization principles and ensure the Airbnb-like database schema is in **Third Normal Form (3NF)**.

---

## 1. First Normal Form (1NF)

### ✅ Status: Achieved
- All tables have atomic values (e.g., `email`, `pricepernight`, `rating`).
- No repeating groups or arrays.
- Each column holds a single value of a defined type.

---

## 2. Second Normal Form (2NF)

### ✅ Status: Achieved
- All non-key attributes are fully functionally dependent on the **entire primary key**.
- All tables use a **single-column primary key (UUID)**, so 2NF is inherently satisfied.

---

## 3. Third Normal Form (3NF)

### ✅ Status: Achieved
- No transitive dependencies in any table.
- Each non-key column depends **only on the primary key**.

### 🔍 Review of Potential Redundancies

| Table     | Potential Issue                         | Resolution                         |
|-----------|------------------------------------------|-------------------------------------|
| `User`    | `role` uses ENUM                        | Acceptable, no redundancy           |
| `Property`| `host_id` is a foreign key to `User`     | Correct usage                       |
| `Booking` | `total_price` can be derived (optional) | Kept for performance reasons        |
| `Payment` | All attributes dependent on `booking_id` | ✅ No transitive dependencies        |
| `Review`  | `rating` and `comment` are atomic        | ✅ Valid                             |
| `Message` | sender_id and recipient_id both FK       | ✅ Proper many-to-many messaging     |

---

## Conclusion

No changes were required to bring the schema into 3NF. The schema is well-normalized with clear entity boundaries, foreign key relationships, and atomic fields. The use of ENUMs, UUIDs, and time-based columns supports efficient and scalable design.

