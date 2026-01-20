# Hospital Information Management System (HIMS)

## Project Overview
This project is an end-to-end data analytics case study built on a Hospital Information Management System (HIMS) database.  
It simulates real-world hospital operations such as OPD visits, IPD admissions, billing, bed management, doctor services, and revenue flow, and extracts business-critical insights using SQL.

The objective is to demonstrate data modeling, SQL analytics, and business problem-solving in a healthcare domain.

---

## Objectives
- Design and populate a relational hospital database with realistic data
- Analyze patient flow, department performance, doctor activity, and revenue
- Answer business-driven healthcare questions using SQL
- Prepare the dataset for further analysis and dashboarding (Excel / BI tools)

---

## Database Design
The database is designed using normalized relational tables with proper primary keys and foreign key constraints.

### Core Entities
- Patient, Visit (OPD), Admission (IPD)
- Doctor, Department, Unit
- Ward, Room, Bed
- Service, Service Category, Service Type
- Charge, Bill, Discharge
- Insurance Company, Patient Category

### Key Design Highlights
- Separate handling of OPD (Outpatient) and IPD (Inpatient) workflows
- One patient can have multiple visits and admissions
- Services categorized by OPD, IPD-General, and IPD-Special
- Billing supports concessions, advances, balances, and settlements
- Bed allocation supports ward-level and room-level hierarchy

---

## Data Scale (Simulated)
The project uses large, realistic datasets to mimic real hospital operations.

- 50,000+ patients
- 10,000+ OPD visits
- 1,000+ IPD admissions
- Tens of thousands of billing and charge records
- Doctors across multiple clinical departments

This scale ensures the analysis reflects real-world complexity.

---

## Business Questions Addressed
The project answers 18 high-impact business questions, including:

- OPD vs IPD patient distribution and trends
- Department-wise patient volume and growth
- Doctor-wise workload and service utilization
- Length of Stay (LOS) analysis by department
- Revenue contribution by OPD vs IPD services
- Discount and concession impact on revenue
- Bed occupancy and utilization efficiency
- Monthly and yearly patient inflow trends

Each question is answered using clear and optimized SQL queries.

---

## Technologies Used
- Database: PostgreSQL
- Language: SQL
- Environment: pgAdmin 4
- Analysis-ready output: Excel / CSV

---


## Key Skills Demonstrated
- Relational database design
- Handling complex foreign key relationships
- Writing analytical SQL queries (JOINs, GROUP BY, aggregates, date functions)
- Translating business problems into data questions
- Healthcare domain understanding (OPD/IPD, billing, LOS, utilization)

---

## How to Use This Project
1. Create a PostgreSQL database
2. Run `sql_project(hims table create).sql`
3. Run `sql_project(hims data insert).sql`
4. Explore business questions using `sql_project(queries).sql`
5. Export query results to Excel for visualization and reporting

---

## Future Enhancements
- Interactive dashboards (Excel, Power BI, Tableau)
- KPI tracking (Average LOS, Revenue per Patient, Bed Occupancy Rate)
- Doctor revenue-share analysis
- Department profitability analysis

---

## Author
Tanisha Agarwal  

