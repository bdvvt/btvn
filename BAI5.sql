CREATE SCHEMA hotel;
SET search_path TO hotel;

CREATE TABLE hotel.RoomTypes(
    room_type_id SERIAL PRIMARY KEY ,
    type_name VARCHAR(50) NOT NULL UNIQUE ,
    price_per_night NUMERIC(10,2) CHECK(price_per_night>0),
    max_capacity INT CHECK(max_capacity>0)
);

CREATE TABLE hotel.Rooms(
    room_id SERIAL PRIMARY KEY ,
    room_number VARCHAR NOT NULL UNIQUE ,
    room_type_id INT,
    FOREIGN KEY (room_type_id) REFERENCES RoomTypes(room_type_id),
    status VARCHAR(20) CHECK(status IN ('Available','Occupied','Maintenace'))
);

CREATE TABLE hotel.Customers(
    customers_id SERIAL PRIMARY KEY ,
    full_name VARCHAR(100) NOT NULL ,
    email VARCHAR(100) UNIQUE NOT NULL ,
    phone VARCHAR(15) NOT NULL
);

CREATE TABLE hotel.Bookings (
    booking_id SERIAL PRIMARY KEY,
    customer_id INT,
    room_id INT,
    FOREIGN KEY (customer_id) REFERENCES Customers(customers_id),
    FOREIGN KEY (room_id) REFERENCES Rooms(room_id) ,
    check_in DATE NOT NULL,
    check_out DATE NOT NULL,
    status VARCHAR(20) CHECK (status IN ('Pending', 'Confirmed', 'Cancelled'))
);


CREATE TABLE hotel.Payments (
    payment_id SERIAL PRIMARY KEY,
    booking_id INT REFERENCES Bookings(booking_id),
    amount NUMERIC(10, 2) CHECK (amount >= 0),
    payment_date DATE NOT NULL,
    method VARCHAR(20) CHECK (method IN ('Credit Card', 'Cash', 'Bank Transfer'))
);
