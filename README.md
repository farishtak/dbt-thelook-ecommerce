### **The Look E-Commerce — dbt ELT Project (BigQuery + dbt Cloud)**



This project is an end-to-end ELT pipeline demo built in dbt Cloud using the public thelook\_ecommerce dataset hosted in BigQuery.

The goal is to simulate a modern analytics engineering workflow: sourcing raw data → staging → ODS (incremental) → downstream fact tables.



This project demonstrates:



* dbt project organization
* data modeling using staging → ODS → marts
* incremental models with partitioning \& clustering
* non null and unique tests
* foreign key relationship tests
* use of dbt’s Jinja templating
* use of the dbt Codegen package
* building a business-ready fact table



**Tech Stack**



* dbt Cloud (development + orchestration)
* BigQuery (warehouse)
* dbt-labs/codegen package (for auto-generating YAML)
* SQL + Jinja







##### 1\. Source Configuration



Using dbt Codegen, I generated a \_src\_thelook.yml file referencing tables in:



bigquery-public-data.thelook\_ecommerce



This includes:

* source declaration (db/schema/tables)
* freshness tests



##### 2\. Staging Layer (stg\_\*)



Created 3 staging models:



* stg\_thelook\_products
* stg\_thelook\_orders
* stg\_thelook\_orderitems



Each staging model includes:



* standardized column names
* consistent naming conventions
* data type casting
* surrogate keys (if needed)
* lightweight cleaning \& documentation



Tests on staging layer were applied in \_stg\_thelook.yml:

* unique
* not\_null



The purpose:



Create clean, analytics-friendly representations of raw tables.





##### 3\. ODS Layer (Incremental Models)



Created three ODS models, each built from its staging counterpart:



* ods\_thelook\_products
* ods\_thelook\_orders
* ods\_thelook\_orderitems



Techniques used:



* Incremental materialization to mimic an operational data store
* Partitioning + clustering in BigQuery for cost and performance optimization
* Jinja references (ref()) for modularity
* Tests applied in \_ods\_thelook.yml:
* unique + not\_null
* relationship tests to ensure FK → PK integrity (ex: ods\_thelook\_orderitems.product\_id → ods\_thelook\_products.product\_id)





##### 4\. Fact Table (fact\_thelook\_order\_items)



Downstream mart/fact table built to support analytics use cases.



This model:



* Joins two ODS tables
* Produces order counts by product and date
* Creates a grain at {product\_id, order\_date}
* Demonstrates basic fact modeling and aggregations
* Uses modular Jinja + references
* This is a business-ready analytical table that can directly feed BI dashboards.



!\[fact\_thelook\_order\_items lineage graph showing source to fact table](images/lineage_graph.png)





##### Project Goal



The goal of this project is to simulate a production-grade ELT pipeline using dbt Cloud:



* Extract raw data (BigQuery public dataset)
* Load into the warehouse
* Transform progressively through clear layers (STG → ODS → FACT)
* Apply data tests to ensure quality
* Use incremental modeling to mimic operational loading
* Produce analytics-ready tables for business stakeholders
* This mirrors the workflow of real-world analytics engineering and BI development.











**--------------------------------------------------------------------------------------**

**dbt Packages Used**



dbt-labs/codegen



Used to:



* auto-generate sources.yml
* quickly scaffold model YAML
* ensure consistent documentation and testing structure



Version:



packages:

&nbsp; - package: dbt-labs/codegen

&nbsp;   version: 0.13.1



**How to Run This Project:**



dbt deps

dbt build





**Or run individual layers:**



dbt run --select staging

dbt run --select ods

dbt run --select marts











