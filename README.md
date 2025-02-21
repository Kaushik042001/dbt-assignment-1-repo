Welcome to your new dbt project!


### Resources:
- Learn more about dbt [in the docs](https://docs.getdbt.com/docs/introduction)
- Check out [Discourse](https://discourse.getdbt.com/) for commonly asked questions and answers
- Join the [dbt community](https://getdbt.com/community) to learn from other analytics engineers
- Find [dbt events](https://events.getdbt.com) near you
- Check out [the blog](https://blog.getdbt.com/) for the latest news on dbt's development and best practices

# Setup Instructions

# Step 1: Log in to DBT Cloud
1. Navigate to [DBT Cloud](https://cloud.getdbt.com/login/).
2. Log in using your credentials or create an account if you don’t have one.


# Step 2: Create a New DBT Cloud Project
1. Once logged in, go to the Projects page.
2. Click "New Project" and give it a meaningful name (e.g., ecommerce_project).
3. Follow the on-screen instructions to create the project.


# Step 3: Add a Snowflake Connection
1. Under the new project, navigate to Settings → Database Connections.
2. Click "New Connection" and select "Snowflake."
3. Provide the following details:
   - Account: <your-snowflake-account>
   - User: <your-username>
   - Password: <your-password>
   - Role: <your-snowflake-role>
   - Warehouse: <your-snowflake-warehouse>
   - Database: <your-snowflake-database>
   - Schema: <your-snowflake-schema>
4. Test the connection to ensure it is working properly.
5. Save the connection.



# Step 4: Create a Development Environment
1. Under Settings → Environments, click "New Environment."
2. Name the environment (e.g., Development).
3. Select the database connection you just created.
4. Set the target schema (e.g., dev_schema_<your_name>).
5. Save the environment.


# Step 5: Clone the Project Repository
1. In DBT Cloud, navigate to Settings → Repository.
2. Connect your Git provider (e.g., GitHub, GitLab).
3. Clone the project repository that has already been created:
   - Repository URL: <repository-url>


# Step 6: Initial Commit
1. Open the DBT IDE or use your local development environment.
2. Ensure all necessary files are present in the project.
3. Make an initial commit to the main branch:
   git add .
   git commit -m "Initial commit"
   git push origin main


# Step 7: Create a Separate Branch for Development and Deployment
# For development:
1. Create a new branch for development (replace <branch_name> with your preferred name):
   - git checkout -b <branch_name>
2. Work on the branch and push changes as needed:
   - git push origin <branch_name>

# For deployment:
- Ensure the main branch is used for deployment.


# Step 8: Create a Deployment Environment
1. Go to Environments in DBT Cloud and click "New Environment."
2. Name it Deployment.
3. Set the target schema for deployment (e.g., prod_schema).
4. Link it to the main branch.
5. Save the environment.



# Step 9: Running DBT Commands
# Run All Models:
dbt run

# Test Models:
dbt test

# Run Snapshots:
dbt snapshot

# Generate Documentation:
dbt docs generate



# Step 10: Scheduling Runs (Optional)
1. Go to the Deployment environment in DBT Cloud.
2. Click "Schedule Run."
3. Set up a periodic schedule (e.g., daily at midnight).
4. Save the schedule.


# Step 11: Review DBT Artifacts
- Check DBT run logs and artifacts to monitor performance and errors.
- Use the dbt docs serve command to view model lineage and documentation.


# Step 12: Best Practices
- Commit Often: Regularly commit and push changes to the development branch.
- Code Review: Ensure all code changes are reviewed before merging to the main branch.
- Testing: Run tests frequently to catch issues early.
- Performance Monitoring: Monitor Snowflake query performance and optimize models if needed.


# Step 13: Troubleshooting
- Connection Issues: Double-check your Snowflake credentials and profiles.yml.
- Model Errors: Ensure dependencies are installed (dbt deps).
- Schema Issues: Verify the target schema matches expectations.


```yaml
# dbt_project.yml Configuration

# Name your project! Project names should contain only lowercase characters
# and underscores. A good package name should reflect your organization's
# name or the intended use of these models
name: 'ecommerce'
version: '1.0.0'
config-version: 2

# This setting configures which "profile" dbt uses for this project.
profile: 'default'

# These configurations specify where dbt should look for different types of files.
# The `model-paths` config, for example, states that models in this project can be
# found in the "models/" directory. You probably won't need to change these!
model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]

target-path: "target"  # directory which will store compiled SQL files
clean-targets:         # directories to be removed by `dbt clean`
  - "target"
  - "dbt_packages"

# Configuring models
models:
  ecommerce:
    staging:
      materialized: "view"  # Keeps staging as views
    cleaning:
      materialized: "table"  # Keeps cleaning as tables
    analytics:
      materialized: "table"  # Keeps analytics models as tables
```

# Analytics Models Descriptions

This document describes the analytics models and their columns defined in the `analytics.yml` file for the `ecommerce` project. Below are the models with their respective descriptions, columns, and tests.

### 1. `customer_purchases`
Summary of transactions done by customers.

**Columns:**
- `customer_id`: Customer ID of the customer who purchased the stock. (Test: `not_null`)
- `invoice_no`: Unique identifier for the quantity of stocks purchased. (Tests: `unique`, `not_null`)
- `total_quantity`: Total quantity of stocks purchased by a customer. (Test: `not_null`)
- `total_price`: Total price of each stock. (Test: `not_null`)
- `avg_order_value`: Average of orders by a customer. (Test: `not_null`)
- `total_revenue`: Sum total revenue generated (`total_quantity` × `total_price`). (Test: `not_null`)

---

### 2. `daily_sales`
Total sales per day.

**Columns:**
- `sales_date`: Date on a particular day. (Test: `not_null`)
- `daily_sales`: Total sales value on a particular day. (Test: `not_null`)

---

### 3. `sales_with_growth`
Gives the daily sales growth by comparing it with the previous day.

**Columns:**
- `sales_date`: Date on which sales growth is calculated. (Test: `not_null`)
- `daily_sales`: Total sales value on a particular day. (Test: `not_null`)
- `previous_day_sales`: Returns sales of the previous day.
- `sales_growth`: Calculates sales growth.

---

### 4. `customer_segments`
Tags customers based on their purchases.

**Columns:**
- `customer_id`: Unique identifier for customers. (Test: `not_null`)
- `total_quantity`: Total quantity ordered by customers (referenced from the `customer_purchases` model). (Test: `not_null`)
- `total_revenue`: Total revenue generated (referenced from the `customer_purchases` model). (Test: `not_null`)
- `avg_order_value`: Average of orders by customers. (Test: `not_null`)
- `customer_segment`: Tags customers based on their purchase revenue. (Tests: `not_null`, `accepted_values`: `['High Value', 'Frequent Buyer', 'Low Value']`)

---

### 5. `rfm_base`
Base model for RFM analysis.

**Columns:**
- `customer_id`: Customer ID of the customers. (Test: `not_null`)
- `total_orders`: Total orders placed by a customer. (Test: `not_null`)
- `total_monetary_value`: Total revenue generated from a customer. (Test: `not_null`)
- `first_purchase_date`: Date of the customer's first order. (Test: `not_null`)
- `last_purchase_date`: Date of the customer's latest order. (Test: `not_null`)
- `total_days`: Total days between a customer's first and latest order. (Test: `not_null`)
- `purchase_frequency_per_day`: Frequency of orders placed per day. (Test: `not_null`)

---

### 6. `rfm_scores`
Gives scores to customers based on their purchases.

**Columns:**
- `customer_id`: Unique identifier for the customer. (Test: `not_null`)
- `recency`: Days passed since the latest purchase date. (Test: `not_null`)
- `purchase_frequency_per_day`: Frequency of orders per day. (Test: `not_null`)
- `total_monetary_value`: Total revenue generated from the customer (referenced from `rfm_base`). (Test: `not_null`)
- `recency_score`: Scores the customer based on recency. (Test: `not_null`)
- `frequency_score`: Scores the customer based on order frequency. (Test: `not_null`)
- `monetary_score`: Scores the customer based on their total revenue. (Test: `not_null`)

---

### 7. `rfm_segment`
Categorizes customers based on their RFM score.

**Columns:**
- `rfm_score`: Sum of `recency_score + frequency_score + monetary_score` (referenced from `rfm_scores`). (Test: `not_null`)
- `rfm_segment`: Categories of customers based on their RFM score. (Tests: `not_null`, `accepted_values`: `['Top Customers', 'At-Risk Customers', 'Average Customers']`)


# Snapshot Documentation: `raw_retail_data_snapshot`

This snapshot captures historical versions of the `raw_retail_data` table for tracking changes over time. Below is a detailed explanation of the configuration and the logic used.

### Snapshot Name: `raw_retail_data_snapshot`

This snapshot is configured as follows:

- **`target_database`**: `assignment_db`  
  The database where the snapshot will be stored.
  
- **`target_schema`**: `ecommerce_snapshots`  
  The schema in which the snapshot is saved.

- **`unique_key`**: `unique_key`  
  A unique identifier to ensure deduplication of records in the snapshot.

- **`strategy`**: `timestamp`  
  The snapshot tracks changes over time using a timestamp-based strategy.

- **`updated_at`**: `invoice_date`  
  The field used to determine when a record was last updated.

# Snapshot SQL Logic:

The snapshot selects data from the `ecommerce.raw_retail_data` source with the following columns:

- **`invoice_no`**: Invoice number for the transaction.
- **`stock_code`**: Stock code for the item.
- **`description`**: Item description.
- **`quantity`**: Quantity of the item purchased.
- **`invoice_date`**: Date and time of the invoice.
- **`unit_price`**: Price per unit of the item.
- **`customer_id`**: Unique identifier for the customer.
- **`country`**: Country of the customer.

Additionally, a **`unique_key`** is generated using the following logic:

```sql
row_number() over (
    order by invoice_date, customer_id, invoiceno, stockcode
)
```


## Exposures in dbt

Exposures in dbt allow us to document and track downstream uses of the data models, such as dashboards, reports, and external data consumers. This helps with lineage tracking and provides visibility into which data models are used by specific reports or dashboards.

### Exposures Defined:

#### 1. `customer_purchases_exposure`

- **Type**: `dashboard`
- **Owner**: 
  - **Name**: Kaushik Chari
  - **Email**: [kaushikchari1404@gmail.com](mailto:kaushikchari1404@gmail.com)
- **Description**: 
  - This dashboard displays the top customer purchases based on total revenue. It leverages customer and sales data from the `clean retail data` model.
- **Depends On**: 
  - The `customer_purchases` model. This ensures dbt tracks any changes in the `customer_purchases` model and their potential impact on the dashboard.
- **Dashboard URL**: [Customer Purchases Dashboard](https://lookerstudio.google.com/reporting/f02919e6-bb44-4cf5-be1a-a48c13619482)

#### 2. `rfm_segment_exposure`

- **Type**: `dashboard`
- **Owner**: 
  - **Name**: Kaushik Chari
  - **Email**: [kaushikchari1404@gmail.com](mailto:kaushikchari1404@gmail.com)
- **Description**: 
  - This dashboard displays customer segments based on the RFM (Recency, Frequency, Monetary) model. It helps visualize and categorize customers based on their purchase behavior.
- **Depends On**: 
  - The `rfm_segment` model. dbt tracks any changes to the `rfm_segment` model and its impact on this dashboard.
- **Dashboard URL**: [RFM Segment Dashboard](https://lookerstudio.google.com/reporting/f02919e6-bb44-4cf5-be1a-a48c13619482)

### Benefits of Using Exposures:

1. **Lineage Tracking**: Ensures all downstream dependencies of dbt models are visible and documented.
2. **Change Impact Analysis**: dbt can identify and notify stakeholders of changes to upstream models that may impact dashboards or reports.
3. **Centralized Documentation**: Provides a single place to document the purpose and ownership of critical dashboards and reports.

