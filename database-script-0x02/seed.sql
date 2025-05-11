-- Seeding Users
INSERT INTO "User" (user_id, first_name, last_name, email, password_hash, phone_number, role)
VALUES 
  ('11111111-1111-1111-1111-111111111111', 'Alice', 'Wonder', 'alice@example.com', 'hashed_password1', '0712345678', 'host'),
  ('22222222-2222-2222-2222-222222222222', 'Bob', 'Builder', 'bob@example.com', 'hashed_password2', '0723456789', 'guest'),
  ('33333333-3333-3333-3333-333333333333', 'Carol', 'Smith', 'carol@example.com', 'hashed_password3', NULL, 'admin');

-- Seeding Properties
INSERT INTO Property (property_id, host_id, name, description, location, pricepernight)
VALUES 
  ('aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'Cozy Cottage', 'A peaceful cottage in the countryside', 'Nairobi', 7500.00),
  ('aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '11111111-1111-1111-1111-111111111111', 'Modern Loft', 'Loft apartment in the city center', 'Mombasa', 9500.00);

-- Seeding Bookings
INSERT INTO Booking (booking_id, property_id, user_id, start_date, end_date, total_price, status)
VALUES 
  ('bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', '2025-06-01', '2025-06-05', 30000.00, 'confirmed'),
  ('bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', '2025-07-01', '2025-07-04', 28500.00, 'pending');

-- Seeding Payments
INSERT INTO Payment (payment_id, booking_id, amount, payment_method)
VALUES 
  ('ccccccc1-cccc-cccc-cccc-cccccccccccc', 'bbbbbbb1-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 30000.00, 'credit_card'),
  ('ccccccc2-cccc-cccc-cccc-cccccccccccc', 'bbbbbbb2-bbbb-bbbb-bbbb-bbbbbbbbbbbb', 28500.00, 'paypal');

-- Seeding Reviews
INSERT INTO Review (review_id, property_id, user_id, rating, comment)
VALUES 
  ('ddddddd1-dddd-dddd-dddd-dddddddddddd', 'aaaaaaa1-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', 5, 'Amazing stay, very peaceful!'),
  ('ddddddd2-dddd-dddd-dddd-dddddddddddd', 'aaaaaaa2-aaaa-aaaa-aaaa-aaaaaaaaaaaa', '22222222-2222-2222-2222-222222222222', 4, 'Great location, but a bit noisy.');

-- Seeding Messages
INSERT INTO Message (message_id, sender_id, recipient_id, message_body)
VALUES 
  ('eeeeeee1-eeee-eeee-eeee-eeeeeeeeeeee', '22222222-2222-2222-2222-222222222222', '11111111-1111-1111-1111-111111111111', 'Hi Alice, is the cottage available in June?'),
  ('eeeeeee2-eeee-eeee-eeee-eeeeeeeeeeee', '11111111-1111-1111-1111-111111111111', '22222222-2222-2222-2222-222222222222', 'Yes, it’s available from the 1st to the 5th.');
