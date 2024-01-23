<h2>1. Business Problem</h2>
Adventure Works, a fictional leading provider of wholesale and retail products for hiking and adventure enthusiasts, is gearing up for an enhanced analytical approach. With a focus on creating a dimensional model, the company aims to analyze sales data efficiently. The objective is to derive valuable insights from historical data using **SQL Server** and **SQL Server Integrated Services** for the ETL process and dimensional model creation.

<h2>2. Business Assumptions</h2>
The data used for the construction of the dimensional model is publicly available on the **Microsoft Website**:
https://learn.microsoft.com/en-us/sql/samples/adventureworks-install-configure?view=sql-server-ver16&tabs=ssms

<h4>2.1 Technical Assumptions:**
<h4>2.1.1** Non-essential columns with over 50% of null values will be disregarded.
<h4>2.1.2** Dimensions with less information (e.g., product categories and subcategories) will be grouped into a single dimension.

<h2>3. Solution Strategy</h2>
<h4>3.1</h4> Download data from **Microsoft Website**;
<h4>3.2</h4> Exploratory analysis of data and data dictionary;
<h4>3.3</h4> Creation of Select Queries, Dimensions, and Fact;
<h4>3.4</h4> Creation of **SSIS Packages**;
<h4>3.6</h4> Structure of Dimensional Model

<h2>4. Business Requirements</h2>
<h4>4.1</h4> A **DataMart** must be delivered to support analyses of sales order data (**SalesOrder**);
<h4>4.2</h4> The granularity of the fact should be the smallest possible granularity available in the OLTP, where each row of the fact will represent a sales order with its details;
<h4>4.3</h4> The dimensions should be analyzed by the candidate, examining the available data from the OLTP and the ER model (The more dimensions identified, the better the dimensional model will be);
<h4>4.4</h4> The **Stage** and **Data Mart** tables must be loaded into **SQL Server** using **SSIS** to perform the ETL process;
<h4>4.5</h4> The dimensions must comply with **Type 1** slowly changing dimensions (SCD);
<h4>4.6</h4> Data extraction from the OLTP must follow the **OrderDate** (Order Date);
<h4>4.7</h4> A video must be submitted by the candidate recording the screen, presenting the entire solution and its details;
<h4>4.8</h4> The project must also be sent (**SSIS Project**, **DDLs**, **DMLs**) to people@dataside.com.br.

<h2>5. Business Insights</h2>
<h4>5.1</h4> The table **Store.BusinessEntity**, as described in the data dictionary, does not exist in the database sample. Additionally, the connection between the **Person.BusinessEntity** table (BusinessEntityID) and the **Sales.Store** table (StoreID) is irregular, thus resulting in misaligned data. The joining of tables was achieved through the **PERSON.BUSINESSENTITY**, **PERSON.PERSON**, and **SALES.STORE** tables.
<h4>5.2</h4> There are many columns that could contribute to the product specification but contain numerous null values, making analyses on these features impractical. It would be advisable to improve the standardization in product registration or consider re-registering some products to ensure that the characteristics align with the analyses.

<h2>6. Conclusion</h2>
A satisfactory dimensional model has been successfully structured, enabling detailed analysis of various relevant characteristics within a sales analysis context. The **Business Intelligence** model provides efficient support for the business team.
