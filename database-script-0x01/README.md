# Schema SQL Definition

## Overview

This SQL script defines the database schema for an Airbnb-like platform, including tables for users, properties, bookings, payments, reviews, and messages.

## Tables and Keys

- **User**: Stores user information, including guests, hosts, and admins.
- **Property**: Each property is listed by a host (foreign key to User).
- **Booking**: Links users to properties for date ranges.
- **Payment**: Payments for bookings, with support for multiple methods.
- **Review**: User reviews for properties.
- **Message**: Messaging between users.

## Constraints

- Primary keys: All use UUIDs.
- Foreign keys: Maintain referential integrity.
- ENUMs: Implemented with CHECK constraints.
- Indexes: Added for performance on frequent search fields.

## Usage

Run the following in your SQL terminal to create the schema:

```bash
psql -U username -d your_database -f schema.sql
