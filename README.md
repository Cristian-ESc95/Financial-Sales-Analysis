# Financial-Sales-Analysis 

## Project Overview
This project analyzes Sales Performance (MoM & YoY), Profitability, Discounts, Customer Behavior, Logistic Performance, and Financial Performance by Region and Product using SQL for data cleaning and KPI calculations, and Power BI for validation and visualization.
The goal is to uncover insights that support better decision-making in Sales, Discount Strategies, Regional and Product Performance, Operations, and Customer Segmentation.

---

## Tech Stack 
- SQL Server Managment - Data cleaning and KPI calculation.
- Power BI - Revalidation and Visualization.
- Excel/CSV - Source Dataset.

## Dataset Description

The dataset contains sales data for a retail store: 

| **Column Name** | **Description** |
|------------------|-----------------|
| `Order ID` | Unique identifier for each order |
| `Order Date` | Date the order was placed |
| `Ship Date` | Date the order was shipped |
| `Ship Mode` | Shipping category (Standard, Second Class, etc.) |
| `Customer ID` | Unique ID for customers |
| `Customer Name` | Name of the customer |
| `Segment` | Customer type (Consumer, Corporate, Home Office) |
| `Country / Region / City / State / Postal Code` | Location data |
| `Product ID` | Unique identifier for products |
| `Category` | Product category |
| `Sub-Category` | Product subcategory |
| `Product Name` | Name of the product |
| `Sales` | Monetary value of sales |
| `Quantity` | Units sold |
| `Discount` | Discount percentage applied |
| `Profit` | Profit earned per sale |

##  Key Steps

### 1) Data Preparation (SQL)
- Create dataset (sales analysis)
- Cleaned raw data (superstoreBI table)
    - Removed Nulls
    - Removed Duplicates
    - Checked inconsitencies
- Created view with cleaned data (vw_CleanSuperstoreBI)
### 2) KPI Analysis
  - Finance and Profitability
  - Discount
  - Customers
  - Products
  - Regions
  - Time/Trends
  - Operations
### 3) Power BI Dashboards   
  - Sales & Profit over time
  - Regional and state-level profitability
  - Customer segmentation
  - Discount impact visualization
  - Interactive filters for category, region, and time
  - Operations and Products Performance

  






