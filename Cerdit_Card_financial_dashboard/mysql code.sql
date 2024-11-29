-- 0. Create a new database for the credit card data
CREATE DATABASE credit_card_db;
USE credit_card_db;

-- 1. Define the table for credit card transaction details
CREATE TABLE credit_card_transactions (
    client_id INT,
    card_type VARCHAR(20),
    annual_fee INT,
    activation_within_30_days INT,
    acquisition_cost INT,
    week_start_date DATE,
    week_number VARCHAR(20),
    quarter VARCHAR(10),
    year INT,
    credit_limit DECIMAL(10,2),
    total_balance INT,
    total_amount_spent INT,
    transaction_count INT,
    average_utilization_ratio DECIMAL(10,3),
    chip_enabled VARCHAR(10),
    expense_type VARCHAR(50),
    interest_earned DECIMAL(10,3),
    delinquent_account VARCHAR(5)
);

-- 2. Load data from CSV into the 'credit_card_transactions' table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/credit_card.csv'
INTO TABLE credit_card_transactions
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

-- Check the content of the table after loading data
SELECT * FROM credit_card_transactions;

-- 3. Define the table for customer details
CREATE TABLE customer_details (
    client_id INT,
    age INT,
    gender VARCHAR(5),
    dependents INT,
    education_level VARCHAR(50),
    marital_status VARCHAR(20),
    state_code VARCHAR(50),
    zipcode VARCHAR(20),
    car_owner VARCHAR(5),
    house_owner VARCHAR(5),
    personal_loan VARCHAR(5),
    contact_info VARCHAR(50),
    job_title VARCHAR(50),
    annual_income INT,
    satisfaction_score INT
);

-- 4. Load customer details data from a CSV file into the 'customer_details' table
LOAD DATA INFILE 'C:/ProgramData/MySQL/MySQL Server 8.0/Uploads/customer_data.csv'
INTO TABLE customer_details
FIELDS TERMINATED BY ',' 
ENCLOSED BY '"' 
LINES TERMINATED BY '\n' 
IGNORE 1 ROWS;

-- View the data loaded into customer_details
SELECT * FROM customer_details;
