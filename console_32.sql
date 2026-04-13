
CREATE TABLE flights (
                         id SERIAL PRIMARY KEY,
                         flight_code VARCHAR(10) UNIQUE,
                         origin VARCHAR(50),
                         destination VARCHAR(50),
                         seats INT
);

CREATE TABLE bookings (
                          id SERIAL PRIMARY KEY,
                          customer_name VARCHAR(100),
                          flight_id INT,
                          booking_time TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
                          CONSTRAINT fk_flight
                              FOREIGN KEY (flight_id)
                                  REFERENCES flights(id)
);

INSERT INTO flights (flight_code, origin, destination, seats) VALUES
('VN123', 'Hanoi', 'Ho Chi Minh', 5),
('VN456', 'Hanoi', 'Da Nang', 3),
('VN789', 'Ho Chi Minh', 'Hue', 2);
INSERT INTO bookings (customer_name, flight_id) VALUES
                                                    ('Tran Van B', 1),
                                                    ('Le Thi C', 2);

CREATE OR REPLACE PROCEDURE create_booking(
    p_flight_code VARCHAR,
    p_customer_name VARCHAR
)
    LANGUAGE plpgsql AS
$$
DECLARE
    v_flight_id INT;
    v_seats INT;
BEGIN
    BEGIN
        -- 1. Lấy thông tin chuyến bay
        SELECT id, seats
        INTO v_flight_id, v_seats
        FROM flights
        WHERE flight_code = p_flight_code;

        -- 2. Kiểm tra còn ghế không
        IF v_seats <= 0 THEN
            RAISE EXCEPTION 'Không còn ghế';
        END IF;

        -- 3. Giảm số ghế
        UPDATE flights
        SET seats = seats - 1
        WHERE id = v_flight_id;

        -- 4. Thêm booking
        INSERT INTO bookings(customer_name, flight_id)
        VALUES (p_customer_name, v_flight_id);

    EXCEPTION
        WHEN OTHERS THEN
            ROLLBACK;
            RAISE;
    END;
END;
$$;

call create_booking('VN123','Nguyen vna a')

select * from bookings
