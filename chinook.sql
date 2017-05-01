-- CHINOOK exercises: https://github.com/nashville-software-school/bangazon-llc/blob/master/orientation/exercises/17_SQL_CHINOOK.md


/*1. non_usa_customers.sql: Provide a query showing Customers 
(just their full names, customer ID and country) who are not in the US. */
SELECT  firstName, lastName , customerId, country as "Non-US  country"
 FROM customer
 WHERE country != "USA";

/*2. brazil_customers.sql: Provide a query only showing the Customers from Brazil.*/
SELECT * 
 FROM Customer
 WHERE Country = "Brazil";

/* 3. brazil_customers_invoices.sql: Provide a query showing the Invoices
 of customers who are from Brazil. 
The resultant table should show the customer's full name, Invoice ID, 
Date of the invoice and billing country. */
SELECT Invoice.InvoiceId, Customer.FirstName || " " || Customer.LastName as "Customer Name",  Invoice.BillingCountry,  InvoiceDate
from Customer
LEFT JOIN Invoice
ON Customer.CustomerId = Invoice.CustomerId
where country = "Brazil"
ORDER BY InvoiceId;

/* 4 sales_agents.sql: Provide a query showing only the Employees 
who are Sales Agents.*/
SELECT FirstName || " " || LastName as "Sales Agent Name" FROM Employee WHERE Title = "Sales Support Agent"

/* 5. unique_invoice_countries.sql: Provide a query showing a unique/distinct 
list of billing countries from the Invoice table.*/
SELECT DISTINCT
 BillingCountry as "Billing Countries"
    from INVOICE
ORDER BY BillingCountry;

/* 6. sales_agent_invoices.sql: Provide a query that shows the invoices associated with each sales agent. 
The resultant table should include the Sales Agent's full name.*/
SELECT DISTINCT 
Employee.FirstName || " " || Employee.LastName as "Sales Agent Name"
FROM Employee
INNER JOIN Customer ON Employee.EmployeeId = Customer.SupportRepId
INNER JOIN Invoice on Customer.CustomerId = Invoice.CustomerId;

/* 7. invoice_totals.sql: Provide a query that shows the Invoice Total, Customer name, Country and Sale Agent name for all invoices and customers.*/
SELECT
  Invoice.Total as "Invoice Total",
  Customer.FirstName || " " || Customer.LastName as "Customer Name",
  Customer.Country,
  Employee.FirstName || " " || Employee.LastName as "Sales Agent"
FROM Invoice 
INNER JOIN Customer on Invoice.CustomerId = Customer.CustomerId
INNER JOIN Employee on Employee.EmployeeId = Customer.SupportRepId;


-- 8. total_invoices_{year}.sql: How many Invoices were there in 2009 and 2011?

/*2009*/
Select Count (Invoice.InvoiceId) as "Invoices in 2009" FROM Invoice
WHERE Invoice.InvoiceDate >= "2009-01-01" AND Invoice.InvoiceDate <= "2009-12-31"

/*2011*/
Select Count ( Invoice.InvoiceId) "invoices in 2011" FROM Invoice;
WHERE  Invoice.InvoiceDate >= "2011-01-01" AND Invoice.InvoiceDate <= "2011-12-31";
 

-- 9. total_sales_{year}.sql: What are the respective total sales for each of those years?

SELECT
  SUM(Total) AS "Sales Total",
  strftime('%Y', InvoiceDate) as "Invoice Year",
  COUNT(Total)
FROM Invoice 
WHERE strftime('%Y', InvoiceDate)
IN ('2009')
UNION
SELECT
  SUM(Total) AS "Sales Total",  
  strftime('%Y', InvoiceDate) as "Invoice Year",
  COUNT(Total)
FROM Invoice 
WHERE strftime('%Y', InvoiceDate)
IN ('2011')

 -- # of invoices in 2009:  83
 -- # of invoices in 2011:  83

 -- SUM Total from 2009:    449.46
 -- SUM Total from 2011:    469.58


 -- 10. invoice_37_line_item_count.sql: Looking at the InvoiceLine table,
 -- provide a query that COUNTs the number of line items 
 -- for Invoice ID 37.

SELECT COUNT(InvoiceLineId)
FROM InvoiceLine
WHERE InvoiceId = "37";
 -- returns that InvoiceLineId count = 4

-- 11. line_items_per_invoice.sql: Looking at the InvoiceLine table, provide a query 
-- that COUNTs the number of line items for each Invoice. HINT: GROUP BY

SELECT COUNT(InvoiceLineId)
FROM InvoiceLine
GROUP BY (InvoiceId)

-- 12. line_item_track.sql: Provide a query that includes the track name
--     with each invoice line item.

SELECT InvoiceLine.InvoiceLineId, Track.Name 
FROM InvoicseLine
INNER JOIN Track ON InVoiceLine.TrackId = Track.TrackId
ORDER BY InvoiceLineId;

-- 13. line_item_track_artist.sql : Provide a query that includes 
-- the purchased track name AND artist name with each invoice line item.

SELECT a.InvoiceLineId, b.Name, d.Name
FROM InvoiceLine a
    JOIN Track b
    ON a.TrackId = b.TrackId
    JOIN Album c 
    ON b.AlbumId = c.AlbumId
    JOIN Artist d
    ON c.ArtistId = d.ArtistId
    ORDER BY a.InvoiceLineId;

-- 14. country_invoices.sql: Provide a query that 
--     shows the # of invoices per country. HINT: GROUP BY

SELECT BillingCountry, COUNT(InvoiceID) as "# of invoices per country"
    FROM Invoice
    GROUP BY BillingCountry;

-- 15. playlists_track_count.sql: Provide a query that shows
-- the total number of tracks in each playlist. The Playlist name
-- should be included on the resulant table.

SELECT pl.Name, Count(plt.PlaylistId)
    FROM Playlist pl
     JOIN PlaylistTrack plt
    ON pl.PlaylistId = plt.PlaylistId
    GROUP BY pl.PlaylistId Playlist pl
    LEFT JOIN PlaylistTrack plt
    ON pl.PlaylistId = plt.PlaylistId
    GROUP BY pl.PlaylistId;

-- 16. tracks_no_id.sql: Provide a query that shows all the Tracks, 
-- but displays no IDs. The result should include the Album name,
--  Media type and Genre.

SELECT t.Name "Track Name", a.Title as "Album Name" , m.Name as "Media Type" , g.name as "Genre"
    FROM Track t
    LEFT JOIN Album a
    ON t.AlbumId = a.AlbumId
    LEFT JOIN MediaType m 
    ON t.MediaTypeId = m.MediaTypeId
    LEFT JOIN Genre g
    ON t.GenreId = g.GenreId
    GROUP BY t.Name;


-- 17. invoices_line_item_count.sql: Provide a query that shows
 -- all Invoices but includes the # of invoice line items.

 

 -- 18. sales_agent_total_sales.sql: Provide a query that shows total sales 
 --     made by each sales agent. 
SELECT  e.EmployeeId, COUNT(c.SupportRepId) as "Total Sales Made", e.FirstName || " " || e.LastName as "Sales Agent Name"
  FROM Employee e
  JOIN Customer c
  ON e.EmployeeId = c.SupportRepId
  Group by e.employeeId;

 -- 19. top_2009_agent.sql: Which sales agent made the most in sales in 2009? 
 -- Hint: Use the MAX function on a subquery.  


 -- 20. top_agent.sql: Which sales agent made the most in sales over all? 
SELECT  e.FirstName || " " || e.LastName as "Sales Rep Name", ROUND(Sum(Total)) as "total amount in Sales", count(e.employeeId) as "number of sales made"
From Invoice i
join customer c
on i.CustomerId = c.CustomerId
join employee e
on c.SupportRepId = e.employeeId
group by "Sales Rep Name"


 -- 21. sales_agent_customer_count.sql: Provide a query that shows the count 
 -- of customers assigned to each sales agent. 
SELECT e.FirstName , e.LastName, COUNT(c.CustomerId) as "Agent's Number of Customers" 
  From Customer c
  Join Employee e
  On c.SupportRepId = e.Employee
  GROUP BY EmployeeId
  ORDER BY COUNT(c.CustomerId);

 -- 22. sales_per_country.sql: Provide a query that shows the total sales per country. 




 -- 23. top_country.sql: Which country's customers spent the most 





 -- 24 top_5_tracks.sql: Provide a query that shows the top 5 most purchased tracks over all.  




 -- 25 top_3_artists.sql: Provide a query that shows the top 3 best selling artists. 




 -- 26. top_media_type.sql: Provide a query that shows the most purchased Media Type. 

 

