# Sistema de Gestión de Alojamientos Turísticos

Este repositorio contiene la solución de la actividad evaluada **"Consultas SQL Avanzadas"** correspondiente al módulo de Bases de Datos de Kodigo.

## 🚀 Motor de Base de Datos Utilizado
* **Motor:** PostgreSQL
* **Versión:** 18.4
* **Herramienta de Administración:** pgAdmin 4

---

## 📐 Esquema de la Base de Datos (`tourism`)

El diseño de la base de datos está encapsulado bajo el esquema lógico `tourism` y está compuesto por las siguientes tablas e interrelaciones:

* **owners (Propietarios):** Almacena los datos de los arrendadores o dueños de los inmuebles (Nombres, Correo, Teléfono, Tax ID/DUI).
* **accommodation_types (Tipos de Alojamiento):** Catálogo con las categorías de hospedajes disponibles (Hotel, Hostel, Apartment, Villa, Cabin, Resort, etc.).
* **locations (Ubicaciones):** Registra las direcciones geográficas detalladas incluyendo país, estado, ciudad, distrito, código postal y coordenadas (Latitud/Longitud).
* **accommodations (Alojamientos):** Entidad principal que describe los inmuebles disponibles, capacidad máxima de huéspedes, habitaciones, baños, precios base por noche y estado de activación (`is_active`).
* **rooms (Habitaciones):** Detalle interno de los cuartos que pertenecen a un alojamiento específico, incluyendo capacidad, cantidad de camas y precios variables.
* **amenities (Comodidades):** Catálogo global de servicios incluidos (WiFi, Pool, AC, Breakfast, BeachAccess, etc.).
* **accommodation_amenities:** Tabla intermedia (Muchos a Muchos) que mapea qué servicios específicos ofrece cada hospedaje.
* **guests (Huéspedes):** Datos maestros de los clientes o turistas (Nombres, Correo, Nacionalidad, Pasaporte/DUI, Contacto de Emergencia).
* **booking_statuses (Estados de Reserva):** Catálogo de control operacional para los flujos de alquiler (`Pending`, `Confirmed`, `CheckedIn`, `CheckedOut`, `Cancelled`, `NoShow`).
* **bookings (Reservas):** Registra el histórico transaccional de alquileres asociando un huésped con un alojamiento/habitación, fechas de entrada/salida (`check_in_date`, `check_out_date`), conteo de noches y montos financieros calculados.
* **booking_guests:** Registro específico de los acompañantes o familiares que se hospedan junto al cliente principal de la reserva.
* **payments (Pagos):** Bitácora transaccional que documenta los montos cobrados, fechas, estados del pago y métodos financieros (incluyendo pasarelas tradicionales y locales como *Chivo Wallet*).
* **reviews (Reseñas):** Almacena las calificaciones de estrellas (`rating` del 1 al 5) y comentarios escritos por los huéspedes tras concluir su estadía.

---

## 📁 Estructura del Proyecto
* `consultas_solucion_tarea.sql`: Script SQL optimizado que contiene las estructuras de control iniciales junto con la resolución limpia de las 20 consultas de manipulación, agregación y subconsultas solicitadas en la guía.
