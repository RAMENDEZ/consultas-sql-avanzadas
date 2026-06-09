-- ============================================================================
-- ACTIVIDAD EVALUADA: CONSULTAS SQL AVANZADAS (KODIGO)
-- MOTOR: PostgreSQL 18.4 (Adaptado al esquema real 'tourism')
-- ============================================================================
-- IMPORTANTE
-- CONFIGURACIÓN INICIAL DEL ESQUEMA TOURISM
SET search_path TO tourism, public;

-- 01. Insertar propietario: Agregar un nuevo propietario
-- Explicación: Insertamos un arrendador local salvadoreño en la tabla 'owners'.
INSERT INTO 
owners (first_name, last_name, company_name, email, phone, tax_id, address_line1, city, state, country, postal_code)
VALUES 
('Glenda Beatriz', 'Claros', 'Alojamientos Claros S.A.', 'glenda.claros@hotmail.sv', '+503 7100-9999',
'04567890-2', 'Playa El Tunco', 'Tamanique', 'La Libertad', 'El Salvador', '01101');

-- 02. Insertar alojamiento: Crear alojamiento vinculado
INSERT INTO 
accommodations (owner_id, accommodation_type_id, location_id, name, description, max_guests, bedroom_count,
bathroom_count, base_price_per_night, currency_code, check_in_time, check_out_time, is_active)
VALUES (25, 3, 19, 'Rancho Surf City Premium', 'Hermoso apartamento frente al mar con vista al sunset.', 6, 2, 2, 165.00,
'USD', '14:00:00', '11:00:00', true);

-- 03. Huésped y reserva: Registrar huésped y reserva
INSERT INTO
guests (first_name, last_name, email, phone, date_of_birth, nationality, passport_number, emergency_contact_name, emergency_contact_phone)
VALUES ('Fernando', 'Chinchilla', 'fchinchilla@gmail.com', '+503 7233-4455', '1994-06-20', 'Salvadoreña', '05123456-7', 'Gaby Meléndez',
'7011-8888');

INSERT INTO 
bookings (guest_id, accommodation_id, room_id, booking_status_id, check_in_date, check_out_date, adult_count, child_count,
subtotal_amount, tax_amount, discount_amount, total_amount, special_requests, booking_reference)
VALUES (101, 22, NULL, 2, '2026-07-01', '2026-07-04', 2, 0, 495.00, 64.35, 0.00, 559.35, 'Habitación con vista despejada', 'BK-SV996');

-- 04. Insertar pago: Registrar pago
-- Explicación: Registramos el cobro de la reserva en la tabla 'payments' usando Chivo Wallet como método de pago local.
INSERT INTO payments (booking_id, amount, payment_method, payment_status, transaction_reference, notes)
VALUES (103, 559.35, 'Chivo Wallet', 'Completed', 'TX-CHIVO-99827', 'Pago completo de estadía en Surf City');

-- ----------------------------------------------------------------------------
-- CATEGORÍA: SELECT (Consultas)
-- ----------------------------------------------------------------------------

-- 05. Alojamientos activos: Filtrar activos
SELECT * FROM accommodations 
WHERE is_active = true;

-- 06. Huéspedes por país: Filtrar por nacionalidad
SELECT * FROM guests 
WHERE nationality = 'Honduras' OR nationality = 'Salvadoreña';

-- 07. Reservas por fechas: Uso de BETWEEN
-- Buscamos las reservas que se hicieron para entrar en el rango de junio de 2025 
SELECT * FROM bookings 
WHERE check_in_date BETWEEN '2025-06-01' AND '2025-06-30';

-- ----------------------------------------------------------------------------
-- CATEGORÍA: UPDATE
-- ----------------------------------------------------------------------------

-- 08. Actualizar precio: Modificar precio
UPDATE accommodations 
SET base_price_per_night = 195.00 
WHERE accommodation_id = 25;

-- 09. Estado reserva: Actualizar estado
-- Cambio el estado de la reserva a CheckedIn (ID 3 de la tabla booking_statuses)
UPDATE bookings 
SET booking_status_id = 3 
WHERE booking_id = 103;

-- ----------------------------------------------------------------------------
-- CATEGORÍA: DELETE 
-- ----------------------------------------------------------------------------

-- 10. Eliminar reseña: DELETE WHERE
DELETE FROM reviews 
WHERE review_id = 1;

-- ----------------------------------------------------------------------------
-- CATEGORÍA: JOIN 
-- ----------------------------------------------------------------------------

-- 11. Reservas + huésped: INNER JOIN
SELECT b.booking_id, b.booking_reference, g.first_name, g.last_name, b.check_in_date, b.total_amount
FROM bookings b
INNER JOIN guests g ON b.guest_id = g.guest_id;

-- 12. Alojamiento completo: INNER JOIN múltiple
SELECT a.name AS alojamiento, o.first_name || ' ' || o.last_name AS propietario, g.first_name || ' ' || g.last_name AS huesped,
b.check_in_date
FROM bookings b
INNER JOIN accommodations a ON b.accommodation_id = a.accommodation_id
INNER JOIN owners o ON a.owner_id = o.owner_id
INNER JOIN guests g ON b.guest_id = g.guest_id;

-- 13. Pagos + reservas: JOIN combinado
SELECT p.payment_id, b.booking_reference, p.amount AS monto_pagado, p.payment_method, p.payment_status
FROM payments p
INNER JOIN bookings b ON p.booking_id = b.booking_id;

-- ----------------------------------------------------------------------------
-- CATEGORÍA: LEFT JOIN 
-- ----------------------------------------------------------------------------

-- 14. Sin reseñas: Incluye nulls
SELECT a.accommodation_id, a.name, r.review_id, r.rating
FROM accommodations a
LEFT JOIN reviews r ON a.accommodation_id = r.accommodation_id
WHERE r.review_id IS NULL;

-- 15. Sin reservas: Filtrar nulls
SELECT a.accommodation_id, a.name, a.base_price_per_night
FROM accommodations a
LEFT JOIN bookings b ON a.accommodation_id = b.accommodation_id
WHERE b.booking_id IS NULL;

-- ----------------------------------------------------------------------------
-- CATEGORÍA: AGG - AGREGACIÓN 
-- ----------------------------------------------------------------------------

-- 16. Total ingresos: SUM
SELECT SUM(amount) AS total_ingresos_globales 
FROM payments 
WHERE payment_status = 'Completed';

-- 17. Promedio rating: AVG
SELECT AVG(rating) AS promedio_calificaciones FROM reviews;

-- 18. Top alojamientos: COUNT + LIMIT
SELECT accommodation_id, COUNT(booking_id) AS total_reservas
FROM bookings
GROUP BY accommodation_id
ORDER BY total_reservas DESC
LIMIT 2;

-- ----------------------------------------------------------------------------
-- CATEGORÍA: HAVING (Consulta 19)
-- ----------------------------------------------------------------------------

-- 19. Más de 3 reservas: GROUP BY + HAVING
SELECT accommodation_id, COUNT(booking_id) AS total_reservas
FROM bookings
GROUP BY accommodation_id
HAVING COUNT(booking_id) >= 3;

-- ----------------------------------------------------------------------------
-- CATEGORÍA: SUBCONSULTA (Consulta 20)
-- ----------------------------------------------------------------------------

-- 20. Alojamiento más caro: Subquery
SELECT name, base_price_per_night, currency_code
FROM accommodations
WHERE base_price_per_night = (SELECT MAX(base_price_per_night) FROM accommodations);
