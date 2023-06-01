-- Creating data base and schema 

-- create database employment_agency;
create schema if not exists agency;

-- 1. Create tables with NOT NULL constraints, default values and generated columns.



CREATE TABLE IF NOT EXISTS agency.customer
(
	customer_id bigserial not null,  -- primary key,
	customer_name varchar(40) not null,
	customer_address varchar(60) not null,
	customer_telephone integer not null
--	check (customer_telephone > 10000000) -- 1/5
);

CREATE TABLE IF NOT EXISTS agency.position
(
	position_id bigserial not null, -- primary key,
	position_title varchar(30) not null,
	position_salary decimal not null,
	customer_id bigint not null, --references agency.customer(customer_id),
	is_open bool not null
);

CREATE TABLE IF NOT EXISTS agency.skill
(
	skill_id bigserial not null, -- primary key,
	skill_name varchar(40) not null,
	skill_description varchar(100) not null
);


CREATE TABLE IF NOT EXISTS agency.requirements 
(
	position_id bigint not null, -- references agency.position(position_id) not null,
	skill_id bigint not null, -- references agency.skill(skill_id) not null,
	is_necessary bool not null
--	CONSTRAINT requirements_pk
--    PRIMARY key (position_id, skill_id)
);


CREATE TABLE IF NOT EXISTS agency.education
(
	education_id bigserial not null, -- primary key,
	education_level varchar(15) not null,
	major varchar(30) not null
);


CREATE TABLE IF NOT EXISTS agency.education_requirements 
(
	position_id bigint not null, -- references agency.position(position_id) not null,
	education_id bigint not null, --references agency.education(education_id) not null,
	is_viable bool not null
--	CONSTRAINT education_requirements_pk
--    PRIMARY key (position_id, education_id)
);


CREATE TABLE IF NOT EXISTS agency.branch
(
	branch_id bigserial not null, -- primary key,
	branch_name varchar(40) not null,
	branch_address varchar(60) not null,
	branch_telephone integer not null
);



CREATE TABLE IF NOT EXISTS agency.employee
(
	employee_id bigserial not null, -- primary key,
	employee_name varchar(40) not null,
	employee_address varchar(60) not null,
	employee_telephone integer not null,
	branch_id bigint not null, -- references agency.branch(branch_id),
	employee_salary decimal not null
--	check (employee_salary > 0) -- 2/5
);


CREATE TABLE IF NOT EXISTS agency.worker
(
	worker_id bigserial not null, -- primaty key,
	worker_name varchar(40) not null,
	worker_address varchar(60) not null,
	worker_telephone integer not null,
	employee_id bigint not null, -- references agency.employee(employee_id),
	is_working bool not null,
	worker_salary decimal
);


CREATE TABLE IF NOT EXISTS agency.worker_skill 
(
	worker_id bigint not null, -- references agency.worker(worker_id),
	skill_id bigint not null -- references agency.skill(skill_id),
	--CONSTRAINT worker_skill_pk
    --PRIMARY key (worker_id, skill_id)
);


CREATE TABLE IF NOT EXISTS agency.worker_education 
(
	worker_id bigint not null, -- references agency.worker(worker_id),
	education_id bigint not null -- references agency.education(education_id),
	--CONSTRAINT worker_education_pk
    --PRIMARY key (worker_id, education_id)
);


CREATE TABLE IF NOT EXISTS agency.worker_position
(
	worker_id bigint not null, -- references agency.worker(worker_id),
	position_id bigint not null -- references agency.position(position_id),
	--CONSTRAINT worker_position_pk
    --PRIMARY key (worker_id, position_id)
);


CREATE TABLE IF NOT EXISTS agency.tax_code
(
	tax_code_id bigserial not null, -- primary key,
	tax_code varchar(10) not null default 'S-PL',
	deduction_rate decimal not null default 0.23
	--check (tax_code in ('S-PL','R-PL','R1','Z','E')) -- 3/5
	--check (deduction_rate in (0.23, 0.08, 0.05, 0))  -- 4/5
);



CREATE TABLE IF NOT EXISTS agency.deduction
(
	deduction_id bigserial not null, -- primary key,
	deduction_reason varchar(100) not null,
	amount decimal not null
);


CREATE TABLE IF NOT EXISTS agency.payroll
(
	payroll_id bigserial not null, -- primary key,
	employee_id bigint,-- references agency.employee(employee_id),
	worker_id bigint,-- references agency.worker(worker_id),
	tax_code_id bigint not null,-- references agency.tax_code(tax_code_id),
	deduction_id bigint, -- references agency.deduction(deduction_id),
	payroll_date date not null default now(),
	payment_method varchar(15) not null default 'WIRE TRANSFER',
	salary decimal not null,
	net decimal not null
--	check (payment_method in ('WIRE TRANSFER', 'CASH', 'CHEQUE')) -- 5/5
);















-- 2. Create primary and foreign keys using separate DDL scripts.

-- We are droping any existing keys before adding new ones for code reusability

-- Customer table
alter table agency.customer
drop constraint if exists customer_pk cascade;

alter table agency.customer
add constraint customer_pk primary key(customer_id);


-- Branch table
alter table agency.branch
drop constraint if exists branch_pk cascade;

alter table agency.branch
add constraint branch_pk primary key(branch_id);


-- Employee table
alter table agency.employee
drop constraint if exists employee_pk cascade;

alter table agency.employee
add constraint employee_pk primary key(employee_id);

alter table agency.employee
drop constraint if exists branch_fk;

ALTER TABLE agency.employee ADD constraint branch_fk
FOREIGN KEY (branch_id) REFERENCES agency.branch(branch_id);


-- Deduction table
alter table agency.deduction
drop constraint if exists deduction_pk cascade;

alter table agency.deduction
add constraint deduction_pk primary key(deduction_id);


-- Tax code table
alter table agency.tax_code
drop constraint if exists tax_code_pk cascade;

alter table agency.tax_code
add constraint tax_code_pk primary key(tax_code_id);


-- Worker table
alter table agency.worker
drop constraint if exists worker_pk cascade;

alter table agency.worker
add constraint worker_pk primary key(worker_id);

alter table agency.worker
drop constraint if exists employee_fk;

ALTER TABLE agency.worker ADD constraint employee_fk
FOREIGN KEY (employee_id) REFERENCES agency.employee(employee_id);


-- Skill table
alter table agency.skill
drop constraint if exists skill_pk cascade;

alter table agency.skill
add constraint skill_pk primary key(skill_id);


-- Position table
alter table agency.position
drop constraint if exists position_pk cascade;

alter table agency.position
add constraint position_pk primary key(position_id);

alter table agency.position
drop constraint if exists customer_fk;

ALTER TABLE agency.position ADD constraint customer_fk
FOREIGN KEY (customer_id) REFERENCES agency.customer(customer_id);


-- Education table
alter table agency.education
drop constraint if exists education_pk cascade;

alter table agency.education
add constraint education_pk primary key(education_id);


-- Position table
alter table agency.education_requirements
drop constraint if exists position_fk;

ALTER TABLE agency.education_requirements ADD constraint position_fk
FOREIGN KEY (position_id) REFERENCES agency.position(position_id);

alter table agency.education_requirements
drop constraint if exists education_fk;

ALTER TABLE agency.education_requirements ADD constraint education_fk
FOREIGN KEY (education_id) REFERENCES agency.education(education_id);

alter table agency.education_requirements
drop constraint if exists education_requirements_pk;

alter table agency.education_requirements
add constraint education_requirements_pk primary key(position_id, education_id);


-- Requirements table
alter table agency.requirements
drop constraint if exists position_fk;

ALTER TABLE agency.requirements ADD constraint position_fk
FOREIGN KEY (position_id) REFERENCES agency.position(position_id);

alter table agency.requirements
drop constraint if exists skill_fk;

ALTER TABLE agency.requirements ADD constraint skill_fk
FOREIGN KEY (skill_id) REFERENCES agency.skill(skill_id);

alter table agency.requirements
drop constraint if exists requirements_pk;

alter table agency.requirements
add constraint requirements_pk primary key(position_id, skill_id);


-- Worker education table
alter table agency.worker_education
drop constraint if exists worker_fk;

ALTER TABLE agency.worker_education ADD constraint worker_fk
FOREIGN KEY (worker_id) REFERENCES agency.worker(worker_id);

alter table agency.worker_education
drop constraint if exists education_fk;

ALTER TABLE agency.worker_education ADD constraint education_fk
FOREIGN KEY (education_id) REFERENCES agency.education(education_id);

alter table agency.worker_education
drop constraint if exists worker_education_pk;

alter table agency.worker_education
add constraint worker_education_pk primary key(worker_id, education_id);


-- Worker position table
alter table agency.worker_position
drop constraint if exists worker_fk;

ALTER TABLE agency.worker_position ADD constraint worker_fk
FOREIGN KEY (worker_id) REFERENCES agency.worker(worker_id);

alter table agency.worker_position
drop constraint if exists position_fk;

ALTER TABLE agency.worker_position ADD constraint position_fk
FOREIGN KEY (position_id) REFERENCES agency.position(position_id);

alter table agency.worker_position
drop constraint if exists worker_position_pk;

alter table agency.worker_position
add constraint worker_position_pk primary key(worker_id, position_id);


-- Worker skill table
alter table agency.worker_skill
drop constraint if exists worker_fk;

ALTER TABLE agency.worker_skill ADD constraint worker_fk
FOREIGN KEY (worker_id) REFERENCES agency.worker(worker_id);

alter table agency.worker_skill
drop constraint if exists skill_fk;

ALTER TABLE agency.worker_skill ADD constraint skill_fk
FOREIGN KEY (skill_id) REFERENCES agency.skill(skill_id);

alter table agency.worker_skill
drop constraint if exists worker_skill_pk;

alter table agency.worker_skill
add constraint worker_skill_pk primary key(worker_id, skill_id);



-- Payroll table
alter table agency.payroll
drop constraint if exists worker_fk;

ALTER TABLE agency.payroll ADD constraint worker_fk
FOREIGN KEY (worker_id) REFERENCES agency.worker(worker_id);

alter table agency.payroll
drop constraint if exists employee_fk;

ALTER TABLE agency.payroll ADD constraint employee_fk
FOREIGN KEY (employee_id) REFERENCES agency.employee(employee_id);

alter table agency.payroll
drop constraint if exists payroll_pk;

alter table agency.payroll
add constraint payroll_pk primary key(payroll_id);

alter table agency.payroll
drop constraint if exists tax_code_fk;

ALTER TABLE agency.payroll ADD constraint tax_code_fk
FOREIGN KEY (tax_code_id) REFERENCES agency.tax_code(tax_code_id);

alter table agency.payroll
drop constraint if exists deduction_fk;

ALTER TABLE agency.payroll ADD constraint deduction_fk
FOREIGN KEY (deduction_id) REFERENCES agency.deduction(deduction_id);














-- Exercise 3: Create check constraints.

alter table agency.customer
drop constraint if exists check_telephone;

ALTER TABLE agency.customer ADD constraint check_telephone
check (customer_telephone > 100000000); --1/5

alter table agency.employee 
drop constraint if exists check_salary;

ALTER TABLE agency.employee ADD constraint check_salary
check (employee_salary > 0); -- 2/5

alter table agency.tax_code  
drop constraint if exists check_tax_code;

ALTER TABLE agency.tax_code ADD constraint check_tax_code
check (tax_code in ('S-PL','R-PL','R1','Z','E')); -- 3/5

alter table agency.tax_code  
drop constraint if exists check_deduction;

ALTER TABLE agency.tax_code ADD constraint check_deduction
check (deduction_rate in (0.23, 0.08, 0.05, 0));  -- 4/5

alter table agency.payroll  
drop constraint if exists check_pay_method;

ALTER TABLE agency.payroll ADD constraint check_pay_method
check (payment_method in ('WIRE TRANSFER', 'CASH', 'CHEQUE')); -- 5/5

















-- Exercise 4: Fill the tables.


-- **Fill your tables with sample data (create it yourself, 20+ rows total in all tables, make sure each table has at least 2 rows).**
-- Filling Branch table
 
insert into agency.branch(branch_name, branch_address, branch_telephone)
select 'Warsaw Branch', 'Poland, 40-000 Warsaw, Rolnicza 30', 123456789
where not exists (select b.branch_name, b.branch_address, b.branch_telephone from agency.branch b where
	b.branch_name = 'Warsaw Branch');

insert into agency.branch(branch_name, branch_address, branch_telephone)
select 'Roma Branch', 'Italy, 40088 Roma, Piazza Nuova 40', 983456789
where not exists (select b.branch_name, b.branch_address, b.branch_telephone from agency.branch b where
	b.branch_name = 'Roma Branch');


-- Filling Employee table
INSERT INTO agency.employee (employee_name, employee_address, employee_telephone, branch_id, employee_salary)
SELECT 'Tommy Vercetti', 'Italy, 40088 Roma, Via Latina 1140/90', '983456222', b.branch_id, 9999.99
FROM agency.branch b
WHERE b.branch_name = 'Roma Branch'
AND NOT EXISTS (
  SELECT *
  FROM agency.employee e
  WHERE e.employee_name = 'Tommy Vercetti'
  AND e.branch_id = b.branch_id
);

INSERT INTO agency.employee (employee_name, employee_address, employee_telephone, branch_id, employee_salary)
SELECT 'Janusz Tracz', 'Poland, 40-001 Warsaw, Kwietna 10/90', '553456222', b.branch_id, 6999.99
FROM agency.branch b
WHERE b.branch_name = 'Warsaw Branch'
AND NOT EXISTS (
  SELECT *
  FROM agency.employee e
  WHERE e.employee_name = 'Janusz Tracz'
  AND e.branch_id = b.branch_id
);


-- Filling Deduction table
INSERT INTO agency.deduction (deduction_reason, amount)
SELECT 'HOLIDAY', 30
WHERE NOT EXISTS (
  SELECT *
  FROM agency.deduction d
  WHERE d.deduction_reason = 'HOLIDAY'
  AND d.amount = 30
);

INSERT INTO agency.deduction (deduction_reason, amount)
SELECT 'PAYMENT ON ACCOUNT', 500
WHERE NOT EXISTS (
  SELECT *
  FROM agency.deduction d
  WHERE d.deduction_reason = 'PAYMENT ON ACCOUNT'
  AND d.amount = 500
);


-- Filling tax_code table
INSERT INTO agency.tax_code (tax_code, deduction_rate)
SELECT 'S-PL', 0.23
WHERE NOT EXISTS (
  SELECT *
  FROM agency.tax_code a
  WHERE a.tax_code = 'S-PL'
  AND a.deduction_rate = 0.23
);

INSERT INTO agency.tax_code (tax_code, deduction_rate)
SELECT 'R-PL', 0.08
WHERE NOT EXISTS (
  SELECT *
  FROM agency.tax_code a
  WHERE a.tax_code = 'R-PL'
  AND a.deduction_rate = 0.08
);


-- Filling Customer table
INSERT INTO agency.customer (customer_name, customer_address, customer_telephone)
SELECT 'Fabryka Broni', 'Poland, 40-101 Warsaw, Wspaniała 300', 999111000
WHERE NOT EXISTS (
  SELECT *
  FROM agency.customer c
  WHERE c.customer_name = 'Fabryka Broni'
);

INSERT INTO agency.customer (customer_name, customer_address, customer_telephone)
SELECT 'Pizzeria Berlusconi', 'Italy, 402101 Roma, Via Bianca', 333111000
WHERE NOT EXISTS (
  SELECT *
  FROM agency.customer c
  WHERE c.customer_name = 'Pizzeria Berlusconi'
);


-- Filling Education table
INSERT INTO agency.education (education_level, major)
SELECT 'Master', 'Computer Science'
WHERE NOT EXISTS (
  SELECT *
  FROM agency.education e
  WHERE e.education_level = 'Master'
  and e.major = 'Computer Science'
);

INSERT INTO agency.education (education_level, major)
SELECT 'Bachelor', 'Pharmacy'
WHERE NOT EXISTS (
  SELECT *
  FROM agency.education e
  WHERE e.education_level = 'Bachelor'
  and e.major = 'Pharmacy'
);


-- Filling Position table
INSERT INTO agency.position (position_title, position_salary, customer_id, is_open)
SELECT 'Firearm Tester', 6000.00, c.customer_id, True
FROM agency.customer c
WHERE c.customer_name = 'Fabryka Broni'
AND NOT EXISTS (
  SELECT *
  FROM agency.position p
  WHERE p.position_title = 'Firearm Tester'
  AND p.customer_id = c.customer_id
);

INSERT INTO agency.position (position_title, position_salary, customer_id, is_open)
SELECT 'Waiter', 2000.00, c.customer_id, True
FROM agency.customer c
WHERE c.customer_name = 'Pizzeria Berlusconi'
AND NOT EXISTS (
  SELECT *
  FROM agency.position p
  WHERE p.position_title = 'Waiter'
  AND p.customer_id = c.customer_id
);


-- Filling Skill table
INSERT INTO agency.skill (skill_name, skill_description)
SELECT 'Teamwork', 'Ability to work in a team'
WHERE NOT EXISTS (
  SELECT *
  FROM agency.skill s
  WHERE s.skill_name = 'Teamwork'
);

INSERT INTO agency.skill (skill_name, skill_description)
SELECT 'Gun Licence Type A', 'Licence issued by National Firepower Association to bear arms type A'
WHERE NOT EXISTS (
  SELECT *
  FROM agency.skill s
  WHERE s.skill_name = 'Gun Licence Type A'
);


-- Filling Worker table
INSERT INTO agency.worker (worker_name, worker_address, worker_telephone, employee_id, is_working, worker_salary)
SELECT 'Alicja Chlebek', 'Poland, 40-011 Warsaw, Kwietna 12/90', 553445222, e.employee_id, false, 2491.39
FROM agency.employee e
WHERE e.employee_name  = 'Janusz Tracz'
AND NOT EXISTS (
  SELECT *
  FROM agency.worker w
  WHERE w.worker_name = 'Alicja Chlebek'
  AND e.employee_id = w.employee_id
);

INSERT INTO agency.worker (worker_name, worker_address, worker_telephone, employee_id, is_working, worker_salary)
SELECT 'Ryszard Kowalski', 'Poland, 40-013 Warsaw, Solidarności 112/48', 553098222, e.employee_id, true, 2191.39
FROM agency.employee e
WHERE e.employee_name  = 'Janusz Tracz'
AND NOT EXISTS (
  SELECT *
  FROM agency.worker w
  WHERE w.worker_name = 'Ryszard Kowalski'
  AND e.employee_id = w.employee_id
);


-- Filling Worker_skill table
INSERT INTO agency.worker_skill (worker_id, skill_id)
SELECT w.worker_id, s.skill_id
FROM agency.worker w
INNER JOIN agency.skill s ON s.skill_name = 'Gun Licence Type A'
WHERE w.worker_name = 'Ryszard Kowalski' AND NOT EXISTS (
  SELECT 1
  FROM agency.worker_skill ws
  WHERE ws.worker_id = w.worker_id AND ws.skill_id = s.skill_id
);

INSERT INTO agency.worker_skill (worker_id, skill_id)
SELECT w.worker_id, s.skill_id
FROM agency.worker w
INNER JOIN agency.skill s ON s.skill_name = 'Teamwork'
WHERE w.worker_name = 'Alicja Chlebek' AND NOT EXISTS (
  SELECT 1
  FROM agency.worker_skill ws
  WHERE ws.worker_id = w.worker_id AND ws.skill_id = s.skill_id
);


-- Filling Worker_position table
INSERT INTO agency.worker_position (worker_id, position_id)
SELECT w.worker_id, p.position_id
FROM agency.worker w
INNER JOIN agency.position p ON p.position_title = 'Firearm Tester'
WHERE w.worker_name = 'Ryszard Kowalski' AND NOT EXISTS (
  SELECT 1
  FROM agency.worker_position wp
  WHERE wp.worker_id = w.worker_id AND wp.position_id = p.position_id
);

INSERT INTO agency.worker_position (worker_id, position_id)
SELECT w.worker_id, p.position_id
FROM agency.worker w
INNER JOIN agency.position p ON p.position_title = 'Firearm Tester'
WHERE w.worker_name = 'Alicja Chlebek' AND NOT EXISTS (
  SELECT 1
  FROM agency.worker_position wp
  WHERE wp.worker_id = w.worker_id AND wp.position_id = p.position_id
);


-- Filling Worker_education table
INSERT INTO agency.worker_education (worker_id, education_id)
SELECT w.worker_id, e.education_id
FROM agency.worker w
INNER JOIN agency.education e ON e.major = 'Pharmacy' and e.education_level = 'Bachelor'
WHERE w.worker_name = 'Ryszard Kowalski' AND NOT EXISTS (
  SELECT 1
  FROM agency.worker_education we
  WHERE we.worker_id = w.worker_id AND we.education_id = e.education_id
);

INSERT INTO agency.worker_education (worker_id, education_id)
SELECT w.worker_id, e.education_id
FROM agency.worker w
INNER JOIN agency.education e ON e.major = 'Computer Science' and e.education_level = 'Master'
WHERE w.worker_name = 'Alicja Chlebek' AND NOT EXISTS (
  SELECT 1
  FROM agency.worker_education we
  WHERE we.worker_id = w.worker_id AND we.education_id = e.education_id
);


-- Filling Requirements table
INSERT INTO agency.requirements (position_id, skill_id, is_necessary)
SELECT p.position_id, s.skill_id, True
FROM agency.position p
INNER JOIN agency.skill s ON s.skill_name  = 'Teamwork'
WHERE p.position_title = 'Waiter' AND NOT EXISTS (
  SELECT 1
  FROM agency.requirements r
  WHERE r.position_id  = p.position_id  AND s.skill_id = r.skill_id
);

INSERT INTO agency.requirements (position_id, skill_id, is_necessary)
SELECT p.position_id, s.skill_id, True
FROM agency.position p
INNER JOIN agency.skill s ON s.skill_name  = 'Gun Licence Type A'
WHERE p.position_title = 'Firearm Tester' AND NOT EXISTS (
  SELECT 1
  FROM agency.requirements r
  WHERE r.position_id  = p.position_id  AND s.skill_id = r.skill_id
);


-- Filling Education_Requirements table
INSERT INTO agency.education_requirements (position_id, education_id, is_viable)
SELECT p.position_id, e.education_id, True
FROM agency.position p
INNER JOIN agency.education e ON e.education_level = 'Master' and e.major = 'Computer Science'
WHERE p.position_title = 'Waiter' AND NOT EXISTS (
  SELECT 1
  FROM agency.education_requirements edr
  WHERE edr.position_id  = p.position_id  AND e.education_id = edr.education_id
);

INSERT INTO agency.education_requirements (position_id, education_id, is_viable)
SELECT p.position_id, e.education_id, True
FROM agency.position p
INNER JOIN agency.education e ON e.education_level = 'Bachelor' and e.major = 'Pharmacy'
WHERE p.position_title = 'Waiter' AND NOT EXISTS (
  SELECT 1
  FROM agency.education_requirements edr
  WHERE edr.position_id  = p.position_id  AND e.education_id = edr.education_id
);


-- Filling Payroll table
INSERT INTO agency.payroll (employee_id, tax_code_id, deduction_id, salary, net)
SELECT ee.employee_id, tc.tax_code_id, d.deduction_id, ee.employee_salary, (ee.employee_salary * (1-tc.deduction_rate) - d.amount)
FROM agency.deduction d
INNER JOIN agency.employee ee ON ee.employee_name = 'Tommy Vercetti'
INNER JOIN agency.tax_code tc ON tc.tax_code = 'R-PL'
LEFT JOIN agency.payroll p ON p.employee_id = ee.employee_id AND p.tax_code_id = tc.tax_code_id AND p.deduction_id = d.deduction_id
WHERE d.deduction_reason = 'HOLIDAY' AND p.employee_id IS NULL;

INSERT INTO agency.payroll (worker_id, tax_code_id, deduction_id, salary, net)
SELECT w.worker_id, tc.tax_code_id, d.deduction_id, w.worker_salary, (w.worker_salary * (1-tc.deduction_rate) - d.amount)
FROM agency.deduction d
INNER JOIN agency.worker w ON w.worker_name = 'Ryszard Kowalski'
INNER JOIN agency.tax_code tc ON tc.tax_code = 'S-PL'
LEFT JOIN agency.payroll p ON p.worker_id = w.worker_id AND p.tax_code_id = tc.tax_code_id AND p.deduction_id = d.deduction_id
WHERE d.deduction_reason = 'HOLIDAY' AND p.worker_id IS NULL;












-- Exercise 5: Add a column record_ts to each table using separate DDL scripts.

ALTER TABLE agency.branch
ADD COLUMN IF NOT EXISTS record_ts TIMESTAMP NOT NULL DEFAULT NOW();

ALTER TABLE agency.employee
ADD COLUMN IF NOT EXISTS record_ts TIMESTAMP NOT NULL DEFAULT NOW();

ALTER TABLE agency.customer  
ADD COLUMN IF NOT EXISTS record_ts TIMESTAMP NOT NULL DEFAULT NOW();

ALTER TABLE agency.deduction  
ADD COLUMN IF NOT EXISTS record_ts TIMESTAMP NOT NULL DEFAULT NOW();

ALTER TABLE agency.tax_code 
ADD COLUMN IF NOT EXISTS record_ts TIMESTAMP NOT NULL DEFAULT NOW();

ALTER TABLE agency.worker 
ADD COLUMN IF NOT EXISTS record_ts TIMESTAMP NOT NULL DEFAULT NOW();

ALTER TABLE agency.skill 
ADD COLUMN IF NOT EXISTS record_ts TIMESTAMP NOT NULL DEFAULT NOW();

ALTER TABLE agency.position 
ADD COLUMN IF NOT EXISTS record_ts TIMESTAMP NOT NULL DEFAULT NOW();

ALTER TABLE agency.education 
ADD COLUMN IF NOT EXISTS record_ts TIMESTAMP NOT NULL DEFAULT NOW();

ALTER TABLE agency.payroll  
ADD COLUMN IF NOT EXISTS record_ts TIMESTAMP NOT NULL DEFAULT NOW();

ALTER TABLE agency.worker_education  
ADD COLUMN IF NOT EXISTS record_ts TIMESTAMP NOT NULL DEFAULT NOW();

ALTER TABLE agency.requirements  
ADD COLUMN IF NOT EXISTS record_ts TIMESTAMP NOT NULL DEFAULT NOW();

ALTER TABLE agency.education_requirements  
ADD COLUMN IF NOT EXISTS record_ts TIMESTAMP NOT NULL DEFAULT NOW();



