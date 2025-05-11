# Seed SQL Data

## Overview

This script (`seed.sql`) provides **realistic sample data** for the Airbnb-like database. It includes:

- Users (guests, hosts, admin)
- Property listings
- Booking records
- Payment transactions
- Guest reviews
- Messaging between users

## How to Use

To seed your database after running `schema.sql`, run the following:

```bash
psql -U your_user -d your_database -f seed.sql
