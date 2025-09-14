drop table hotels cascade constraints;
drop table bookings cascade constraints;
drop table guests cascade constraints;
drop table tour_guide cascade constraints;
drop table tour_packages cascade constraints;
drop table h_employee cascade constraints;
drop table hotel_staff cascade constraints;
drop table destination cascade constraints;
drop table stays_at cascade constraints;
drop table conducts cascade constraints;
drop table work_as cascade constraints;
drop table reserves cascade constraints;
drop table payments cascade constraints;
drop table facilities cascade constraints;
drop table h_employee_address cascade constraints;
drop table rooms cascade constraints;
drop table guests_phone_number cascade constraints;

CREATE TABLE bookings (
    booking_id      CHAR(5) NOT NULL,
    guest_id        CHAR(5) NOT NULL,
    room_id         CHAR(5) NOT NULL,
    check_in        DATE DEFAULT SYSDATE,
    check_out       DATE DEFAULT SYSDATE
);

ALTER TABLE bookings ADD CONSTRAINT bookings_pk PRIMARY KEY ( booking_id );

CREATE TABLE conducts(
    employee_id   CHAR(5) NOT NULL,
    package_id CHAR(5) NOT NULL
);

ALTER TABLE conducts ADD CONSTRAINT conducts_pk PRIMARY KEY (employee_id, package_id);

CREATE TABLE destination (
    destination_id   CHAR(5) NOT NULL,
    destination_name VARCHAR2(100),
    d_location       VARCHAR2(100)
);


ALTER TABLE destination ADD CONSTRAINT destination_pk PRIMARY KEY ( destination_id );

CREATE TABLE facilities (
    facility_id     CHAR(5) NOT NULL,
    hotel_id        CHAR(5) NOT NULL,
    f_name          VARCHAR2(100),
    available VARCHAR2(3) DEFAULT 'YES',
    cost_bdt        NUMBER(8)
);

ALTER TABLE facilities ADD CONSTRAINT facilities_pk PRIMARY KEY ( facility_id );

CREATE TABLE guests (
    g_name       VARCHAR2(100),
    from_city    VARCHAR2(100),
    guest_id     CHAR(5) NOT NULL
);

ALTER TABLE guests ADD CONSTRAINT guests_pk PRIMARY KEY ( guest_id );

CREATE TABLE guests_phone_number(
    guest_id char(5) not null,
    phone_number char(11),
    
    constraint guests_phone_number_fk foreign key (guest_id)
    references guests (guest_id) on delete cascade
);

CREATE TABLE h_employee (
    date_of_birth      DATE NOT NULL,
    employee_id        CHAR(5) NOT NULL,
    gender             VARCHAR2(6),
    name               VARCHAR2(100),
    hotel_id char(5) not null,
    address_id char(5) not null
);

ALTER TABLE h_employee ADD CONSTRAINT h_employee_pk PRIMARY KEY ( employee_id );

CREATE TABLE h_employee_address (
    street                 VARCHAR2(100),
    city                   VARCHAR2(100),
    zip                    NUMBER(6),
    address_id char(5) not null,
    employee_id CHAR(5) NOT NULL
);

ALTER TABLE h_employee_address ADD CONSTRAINT address_pk PRIMARY KEY ( address_id );

CREATE TABLE hotel_staff (
    employee_id  CHAR(5) NOT NULL,
    role         VARCHAR2(100) NOT NULL,
    shift_timing DATE NOT NULL,
    CONSTRAINT hotel_staff_pk PRIMARY KEY (employee_id),
    CONSTRAINT hotel_staff_fk FOREIGN KEY (employee_id)
        REFERENCES h_employee (employee_id)
        ON DELETE CASCADE
);

CREATE TABLE hotels (
    hotel_name       VARCHAR2(100) NOT NULL,
    hotel_id         CHAR(5) NOT NULL,
    rating           NUMBER(2) NOT NULL,
    h_location       VARCHAR2(100) NOT NULL,
    established_year NUMBER,
    destination_id   CHAR(5) NOT NULL,
    CONSTRAINT hotels_destination_fk FOREIGN KEY (destination_id)
        REFERENCES destination (destination_id) ON DELETE CASCADE
);


ALTER TABLE hotels ADD CONSTRAINT hotels_pk PRIMARY KEY ( hotel_id );

CREATE TABLE payments (
    booking_id     CHAR(5) NOT NULL,
    payment_number NUMBER(3) NOT NULL,
    amount         NUMBER(8) NOT NULL,
    payment_date   DATE DEFAULT SYSDATE,
    payment_method VARCHAR2(20),

    CONSTRAINT payments_pk PRIMARY KEY (booking_id, payment_number),
    CONSTRAINT payments_booking_fk FOREIGN KEY (booking_id)
        REFERENCES bookings (booking_id) ON DELETE CASCADE
);

CREATE TABLE reserves (
    room_id       CHAR(5) NOT NULL,
    booking_id CHAR(5) NOT NULL
);

ALTER TABLE reserves ADD CONSTRAINT reserves_pk PRIMARY KEY (room_id,
                                                             booking_id );

CREATE TABLE rooms (
    room_id         CHAR(5) NOT NULL,
    hotel_id        CHAR(5) NOT NULL,
    type            VARCHAR2(100),
    price_bdt       NUMBER(8) NOT NULL,
    sea_view        VARCHAR2(3),
    check_in_time VARCHAR2(5) DEFAULT '14:00'
);

ALTER TABLE rooms ADD CONSTRAINT rooms_pk PRIMARY KEY ( room_id );

CREATE TABLE stays_at (
    hotel_id CHAR(5) NOT NULL,
    guest_id CHAR(5) NOT NULL
);

ALTER TABLE stays_at ADD CONSTRAINT stays_at_pk PRIMARY KEY (hotel_id,
                                                             guest_id );

CREATE TABLE tour_guide (
    employee_id         CHAR(5) NOT NULL,
    language_speciality VARCHAR2(100),
    destination_list    VARCHAR2(200),
    CONSTRAINT tour_guide_pk PRIMARY KEY (employee_id),
    CONSTRAINT tour_guide_fk FOREIGN KEY (employee_id)
        REFERENCES h_employee (employee_id)
        ON DELETE CASCADE
);

CREATE TABLE tour_packages (
    price        NUMBER(8) NOT NULL,
    package_id   CHAR(5) NOT NULL,
    package_name VARCHAR2(100),
    end_date     DATE NOT NULL,
    start_date   DATE NOT NULL
);

ALTER TABLE tour_packages ADD CONSTRAINT tour_packages_pk PRIMARY KEY ( package_id );

CREATE TABLE work_as (
    hotel_id                CHAR(5) NOT NULL,
    hotel_staff_employee_id CHAR(5) NOT NULL,
    CONSTRAINT work_as_pk PRIMARY KEY (hotel_id, hotel_staff_employee_id)
);

ALTER TABLE h_employee
ADD CONSTRAINT h_id_fk FOREIGN KEY (hotel_id)
REFERENCES hotels (hotel_id) ON DELETE CASCADE;

ALTER TABLE h_employee_address
ADD CONSTRAINT address_h_employee_fk FOREIGN KEY (employee_id)
REFERENCES h_employee (employee_id) ON DELETE CASCADE;

ALTER TABLE bookings
    ADD CONSTRAINT bookings_guests_fk FOREIGN KEY (guest_id)
        REFERENCES guests (guest_id) ON DELETE CASCADE;

ALTER TABLE conducts
ADD CONSTRAINT conducts_tour_guide_fk FOREIGN KEY (employee_id)
REFERENCES tour_guide (employee_id) ON DELETE CASCADE;

ALTER TABLE facilities
    ADD CONSTRAINT facilities_hotels_fk FOREIGN KEY (hotel_id )
        REFERENCES hotels ( hotel_id ) ON DELETE CASCADE;

ALTER TABLE reserves
    ADD CONSTRAINT reserves_bookings_fk FOREIGN KEY (booking_id )
        REFERENCES bookings ( booking_id ) ON DELETE CASCADE;

ALTER TABLE reserves
    ADD CONSTRAINT reserves_rooms_fk FOREIGN KEY (room_id )
        REFERENCES rooms ( room_id ) ON DELETE CASCADE;

ALTER TABLE rooms
    ADD CONSTRAINT rooms_hotels_fk FOREIGN KEY (hotel_id)
        REFERENCES hotels ( hotel_id) ON DELETE CASCADE;

ALTER TABLE stays_at
    ADD CONSTRAINT stays_at_guests_fk FOREIGN KEY (guest_id)
        REFERENCES guests ( guest_id ) ON DELETE CASCADE;

ALTER TABLE stays_at
    ADD CONSTRAINT stays_at_hotels_fk FOREIGN KEY (hotel_id)
        REFERENCES hotels ( hotel_id ) ON DELETE CASCADE;

ALTER TABLE work_as
    ADD CONSTRAINT work_as_hotel_staff_fk FOREIGN KEY ( hotel_staff_employee_id )
        REFERENCES hotel_staff ( employee_id ) ON DELETE CASCADE;

ALTER TABLE work_as
    ADD CONSTRAINT work_as_hotels_fk FOREIGN KEY (hotel_id )
        REFERENCES hotels ( hotel_id ) ON DELETE CASCADE;
       
create view hotel_occupancy as
(
select h.hotel_id, h.hotel_name, count(distinct r.room_id) as total_rooms, count(distinct b.room_id) as booked_rooms
from hotels h
left join rooms r on h.hotel_id = r.hotels_hotel_id
left join bookings b on r.room_id = b.room_id
group by h.hotel_id, h.hotel_name
);

--View created by Chaiti

CREATE OR REPLACE VIEW destination_top_hotels AS
SELECT 
    d.destination_name, 
    h.hotel_name, 
    h.rating
FROM destination d
JOIN hotels h
    ON d.destination_id = h.destination_id
WHERE h.rating >= 4;

SELECT * FROM destination_top_hotels;

CREATE OR REPLACE VIEW last7days_checkouts AS
SELECT booking_id,
       guest_id,
       room_id,
       check_in,
       check_out
FROM bookings
WHERE check_out >= SYSDATE - 7;

SELECT * FROM last7days_checkouts;

CREATE OR REPLACE VIEW destination_avg_rating AS
SELECT 
    d.destination_name, 
    AVG(h.rating) AS avg_rating,
    COUNT(h.hotel_id) AS total_hotels
FROM destination d
JOIN hotels h
    ON d.destination_id = h.destination_id
GROUP BY d.destination_name;

SELECT * FROM destination_avg_rating;

CREATE OR REPLACE VIEW active_bookings AS
SELECT booking_id, guest_id, room_id, check_in, check_out
FROM bookings
WHERE check_out >= SYSDATE;

SELECT * FROM active_bookings;

create view guest_booking_details as
(
    select  g.guest_id, g.g_name, g.from_city, b.booking_id, b.check_in, b.check_out, r.room_id, r.type, h.hotel_name, h.h_location
    from guests g
    join bookings b on g.guest_id = b.guest_id
    join rooms r on b.room_id = r.room_id
    join hotels h on r.hotel_id = h.hotel_id
);

create view high_rated_hotels as
( select hotel_id, hotel_name, h_location, rating
from hotels
where rating >= 4
);

create view vw_rooms_hotels_dest as
(
select 
    r.room_id,
    r.type as room_type,
    r.price_bdt,
    r.sea_view,
    r.check_in_time,
    h.hotel_name,
    d.destination_name
from rooms r
join hotels h on r.hotel_id = h.hotel_id
join destination d on h.destination_id = d.destination_id);

create view vw_hotel_facilities as
select 
    h.hotel_name,
    f.f_name as facility,
    f.available,
    f.cost_bdt
from facilities f
join hotels h on f.hotel_id = h.hotel_id;

create view vw_payments_guests as
select 
    p.booking_id,
    g.g_name as guest_name,
    p.payment_number,
    p.amount,
    p.payment_date,
    p.payment_method
from payments p
join bookings b on p.booking_id = b.booking_id
join guests g on b.guest_id = g.guest_id;

create view view_employee_details as
select
    e.employee_id,
    e.name,
    e.gender,
    e.date_of_birth,
    a.street,
    a.city,
    a.zip,
    e.hotel_id
from h_employee e
join h_employee_address a on e.address_id = a.address_id;

create view view_employee_roles as
select
    hs.employee_id,
    e.name as employee_name,
    hs.role,
    hs.shift_timing,
    e.hotel_id,
    h.hotel_name
from hotel_staff hs
join h_employee e on hs.employee_id = e.employee_id
join hotels h on e.hotel_id = h.hotel_id;

create view view_guest_contact as
(select
    g.guest_id,
    g.g_name,
    g.from_city,
    p.phone_number
from guests g
left join guests_phone_number p on g.guest_id = p.guest_id);

commit;