# PL/SQL Finance Manager

Welcome to the **PL/SQL Finance Manager** project! This repository contains a fully-fledged Oracle PL/SQL solution for handling client contracts and automatically generating installment payment schedules based on varying payment terms.

## 🎥 Project Walkthrough

Watch the full project explanation and walkthrough in this [video demonstration](https://drive.google.com/file/d/1e2pXxNFg_lgp-9kXuweI9Sfn7QOgD2Gx/view?usp=sharing).

## 📌 Project Overview

The core feature of this project is an automated financial engine that calculates and registers individual payment installments whenever a new contract is created or on-demand for existing ones. It seamlessly supports multiple payment intervals:
- **Monthly**
- **Quarterly**
- **Half-Annual**
- **Annual**

### ✨ Key Features

- **Relational Schema**: Well-structured tables for `Clients`, `Contracts`, and `Installments`.
- **Automated Installment Generation**: PL/SQL package encapsulating the logic to compute precise payment dates, the number of installments, and due amounts after accounting for initial deposits.
- **Compound Triggers**: A high-performance compound trigger that automatically catches new contract inserts and creates corresponding installments without encountering the mutating table error.
- **Modular Design**: Complete separation of concerns between DDL/DML, package specifications, package bodies, and triggers.

## 🗂️ Project Structure

The project is structured into the following SQL scripts:

| File | Description |
| ---- | ----------- |
| **`Init_tables.sql`** | Contains the DDL to create the database tables (`clients`, `contracts`, `installments`) and initial DML queries to populate sample data. |
| **`PKG_Specs.sql`** | The specification for the `pkg_finance_manager` package. It exposes the two main public procedures to external callers. |
| **`PKG_Body.sql`** | The body of the `pkg_finance_manager` package. Contains internal functions for date and fee calculations and the full procedural logic to generate installments. |
| **`Tigger.sql`** | Contains `trg_after_insert_contract`, a specialized Compound Trigger used to automate installment creation immediately upon contract insertion. |
| **`Run.sql`** | An example PL/SQL block demonstrating how to manually invoke the package procedures. |

## 🛠️ Setup and Execution

To deploy this project to your Oracle Database, execute the scripts in the following order:

1. **Initialize the Schema**:
   Run `Init_tables.sql` to create the required tables and insert test data.
   ```sql
   @Init_tables.sql
   ```

2. **Compile the Package Specification**:
   Compile the interface for the finance manager package.
   ```sql
   @PKG_Specs.sql
   ```

3. **Compile the Package Body**:
   Compile the business logic.
   ```sql
   @PKG_Body.sql
   ```

4. **Create the Trigger**:
   Attach the automated installment trigger to the `contracts` table.
   ```sql
   @Tigger.sql
   ```

## 🚀 Usage

### Automatic Generation
With the trigger enabled, any new `INSERT` into the `contracts` table will automatically generate corresponding installments. Just insert a contract with a valid `contract_payment_type` (`MONTHLY`, `QUARTER`, `HALF_ANNUAL`, `ANNUAL`) and the system handles the rest.

### Manual Generation
You can also generate installments manually using the provided package procedures. Here is an example of what is found in `Run.sql`:

```sql
BEGIN
    -- 1. Generate installments for a specific existing contract ID
    pkg_finance_manager.prc_generate_installments(101);
    
    -- 2. Bulk generate installments for all contracts that haven't been processed yet
    pkg_finance_manager.prc_generate_all_pending;
END;
/
```

## 📊 Database Schema Details

- **`clients`**: Stores client information (`client_id`, `client_name`, `mobile`, `address`, `nid`).
- **`contracts`**: Stores contract details including start/end dates, total fees, deposit fees, and the payment interval (`contract_payment_type`). Links to `clients` via `client_id`.
- **`installments`**: Automatically generated table storing individual payment dues, specific dates, and amounts. Links to `contracts` via `contract_id`.

## 🤝 Contributing

Contributions, issues, and feature requests are welcome! Feel free to review the schema and provide enhancements.
