/* =======================
   CLIENTS TABLE
======================= */
CREATE TABLE clients (
    client_id   NUMBER PRIMARY KEY,
    client_name VARCHAR2(50) NOT NULL,
    mobile      VARCHAR2(15) NOT NULL,
    address     VARCHAR2(30),
    nid         VARCHAR2(20)
);

INSERT INTO clients VALUES (1, 'Ahmed Omar',  '0124798987', 'Cairo', NULL);
INSERT INTO clients VALUES (2, 'Marwa Hashem','0106549878', 'Alex',  NULL);
INSERT INTO clients VALUES (3, 'Tarek Shawky','0124659798', 'Cairo', NULL);


/* =======================
   CONTRACTS TABLE
======================= */
CREATE TABLE contracts (
    contract_id            NUMBER PRIMARY KEY,
    contract_startdate     DATE NOT NULL,
    contract_enddate       DATE NOT NULL,
    contract_total_fees    NUMBER(10,2) NOT NULL,
    contract_deposit_fees  NUMBER(10,2),
    client_id              NUMBER NOT NULL,
    contract_payment_type  VARCHAR2(20) NOT NULL,
    notes                  VARCHAR2(200),
    CONSTRAINT fk_contracts_client
        FOREIGN KEY (client_id)
        REFERENCES clients(client_id)
);

INSERT INTO contracts VALUES
(101, DATE '2021-01-01', DATE '2023-01-01',  500000,  NULL,    1, 'ANNUAL',       NULL);

INSERT INTO contracts VALUES
(102, DATE '2021-03-01', DATE '2024-03-01',  600000,  10000,   3, 'QUARTER',      NULL);

INSERT INTO contracts VALUES
(103, DATE '2021-05-01', DATE '2023-05-01',  400000,  50000,   3, 'QUARTER',      NULL);

INSERT INTO contracts VALUES
(104, DATE '2021-03-01', DATE '2024-03-01',  700000,  NULL,    2, 'MONTHLY',      NULL);

INSERT INTO contracts VALUES
(105, DATE '2021-04-01', DATE '2026-04-01',  900000,  300000,  1, 'ANNUAL',       NULL);

INSERT INTO contracts VALUES
(106, DATE '2021-01-01', DATE '2026-01-01', 1000000,  200000,  2, 'HALF_ANNUAL',  NULL);


/* =======================
   INSTALLMENTS TABLE
======================= */
CREATE TABLE installments (
    installment_id     NUMBER PRIMARY KEY,
    contract_id        NUMBER NOT NULL,
    installment_date   DATE NOT NULL,
    installment_amount NUMBER(10,2) NOT NULL,
    CONSTRAINT fk_installments_contract
        FOREIGN KEY (contract_id)
        REFERENCES contracts(contract_id)
);