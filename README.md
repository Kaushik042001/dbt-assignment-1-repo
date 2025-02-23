# Welcome to Your New dbt Project!

This README provides a structured overview of your dbt project, including setup instructions, directory structure, configuration details, exposures, macros, and best practices.

---

## **Resources**

To learn more about dbt, explore the following links:

- [dbt Documentation](https://docs.getdbt.com/docs/introduction)
- [dbt Discourse](https://discourse.getdbt.com/)
- [dbt Community](https://getdbt.com/community)
- [dbt Events](https://events.getdbt.com)
- [dbt Blog](https://blog.getdbt.com/)

---

## **Setup Instructions**

### **Step 1: Log in to dbt Cloud**
1. Navigate to [dbt Cloud](https://cloud.getdbt.com/login/).
2. Log in using your credentials or create an account if needed.

### **Step 2: Create a New dbt Cloud Project**
1. Go to the **Projects** page.
2. Click **New Project** and give it a meaningful name (e.g., `ecommerce_project`).
3. Follow the setup wizard to create the project.

### **Step 3: Add a Snowflake Connection**
1. Navigate to **Settings → Database Connections**.
2. Click **New Connection** and select **Snowflake**.
3. Provide necessary connection details:
   - Account: `<your-snowflake-account>`
   - User: `<your-username>`
   - Password: `<your-password>`
   - Role: `<your-snowflake-role>`
   - Warehouse: `<your-snowflake-warehouse>`
   - Database: `<your-snowflake-database>`
   - Schema: `<your-snowflake-schema>`
4. Test and save the connection.

### **Step 4: Create a Development Environment**
1. Navigate to **Settings → Environments**.
2. Click **New Environment**, name it `Development`, and select the connection.
3. Set the target schema (e.g., `dev_schema_<your_name>`) and save it.

### **Step 5: Clone the Project Repository**
```sh
  git clone <repository-url>
```

### **Step 6: Initial Commit**
```sh
  git add .
  git commit -m "Initial commit"
  git push origin main
```

### **Step 7: Create a Separate Branch for Development**
```sh
  git checkout -b <branch_name>
  git push origin <branch_name>
```

### **Step 8: Create a Deployment Environment**
1. Go to **Environments** in dbt Cloud and click **New Environment**.
2. Name it `Deployment`, set the schema (e.g., `prod_schema`), and link it to the `main` branch.

### **Step 9: Running dbt Commands**
```sh
  dbt run    # Run all models
  dbt test   # Run tests
  dbt snapshot   # Run snapshots
  dbt docs generate   # Generate documentation
```

### **Step 10: Scheduling Runs (Optional)**
1. Go to the `Deployment` environment in dbt Cloud.
2. Click **Schedule Run** and set a periodic schedule.

---

## **dbt Project Directory Structure**

```plaintext
dbt-assignment-1-repo/
├── analyses/
├── macros/
├── models/
│   ├── ecommerce/
│   │   ├── analytics/
│   │   ├── cleaning/
│   │   ├── exposures/
│   │   ├── staging/
├── seeds/
├── snapshots/
├── tests/
├── .gitignore
├── README.md
└── dbt_project.yml
```

---

## **dbt_project.yml Configuration**

```yaml
name: 'ecommerce'
version: '1.0.0'
config-version: 2
profile: 'default'
model-paths: ["models"]
analysis-paths: ["analyses"]
test-paths: ["tests"]
seed-paths: ["seeds"]
macro-paths: ["macros"]
snapshot-paths: ["snapshots"]
target-path: "target"
clean-targets: ["target", "dbt_packages"]
models:
  ecommerce:
    staging:
      materialized: "view"
    cleaning:
      materialized: "table"
    analytics:
      materialized: "table"
```

---

## **Exposures in dbt**

### **Customer Purchases Exposure**
- **Type**: `dashboard`
- **Owner**: Kaushik Chari
- **Description**: Displays top customer purchases based on revenue.
- **Depends On**: `customer_purchases`
- **Dashboard URL**: [Customer Purchases Dashboard](https://lookerstudio.google.com/reporting/f02919e6-bb44-4cf5-be1a-a48c13619482)

### **RFM Segment Exposure**
- **Type**: `dashboard`
- **Owner**: Kaushik Chari
- **Description**: Segments customers based on RFM analysis.
- **Depends On**: `rfm_segment`
- **Dashboard URL**: [RFM Segment Dashboard](https://lookerstudio.google.com/reporting/f02919e6-bb44-4cf5-be1a-a48c13619482)

---

## **Macros**

### **filter_conditions Macro**
Filters records based on specific conditions.
```sql
{% macro filter_conditions(customer_id_null_filter=true, min_quantity=1) %}
    {% if customer_id_null_filter %}
        AND customerid IS NOT NULL
    {% endif %}
    {% if min_quantity > 0 %}
        AND quantity > {{ min_quantity }}
    {% endif %}
{% endmacro %}
```

### **incremental_config Macro**
Defines incremental configurations.
```sql
{% macro incremental_config(unique_key) %}
  {{
    config(
      materialized='incremental',
      unique_key=unique_key,
      incremental_strategy='merge'
    )
  }}
{% endmacro %}
```

### **get_total_revenue Macro**
Calculates total revenue dynamically.
```sql
{% macro get_total_revenue(quantity_col, price_col) %}
    {{ quantity_col }} * {{ price_col }}
{% endmacro %}
```

---

## **Best Practices**
- **Commit Often**: Regularly commit and push changes.
- **Code Review**: Ensure all code changes are reviewed before merging.
- **Testing**: Run tests frequently to catch issues early.
- **Performance Monitoring**: Optimize models and monitor Snowflake queries.

---

## **Troubleshooting**
- **Connection Issues**: Check Snowflake credentials and `profiles.yml`.
- **Model Errors**: Ensure dependencies are installed (`dbt deps`).
- **Schema Issues**: Verify the target schema in `dbt_project.yml`.

---

This README provides a comprehensive guide to setting up and using your dbt project effectively. 🚀

