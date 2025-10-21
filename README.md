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

### Key Insights
- Technology and Office Supplies are the most profitable categories. Furniture generates a lot of revenue but contributes very little to profit. I would recomend analyzing costs or pricing strategy.
- Tables (Furniture), Bookcases (Furniture), and Supplies (Office Supplies) generate negative profit. I recommend reviewing their pricing or supplier costs, or considering discontinuing these products.
- Based on the Pareto chart, around 20% of the products sold (Copiers, Phones, and Accessories) generate nearly 80% of the company’s overall profit. However, when comparing these products with the Profit Margin chart, they are not the most efficient in terms of profitability. I recommend negotiating better costs to increase their margins.
- Products such as Labels and Envelopes have excellent profit margins but lower sales volumes. Consider marketing these more aggressively or bundling them with popular items to increase their total contribution.
- Discounts beyond 20% destroy Profit Margin.
- High-revenue customers don't always generate high profit (Sean Miller, Ken Londsdale, Sanjit Engle, Christopher Conant).Consider launching a loyalty program or targeted promotions to reward the most profitable customers and strengthen long-term relationships.
- Loss-making customers represent 18,07%. It's recommended to optimise discount policies to reduce negative margins.
- The company generates $2.30M in revenue with a profit margin of 12.49%, showing solid but uneven regional performance. West and East drive most of the company's profit led by California and New York. Consider to analyze the cost structure, particularly logistic and distribution expenses in states with low or negative profit margins.





