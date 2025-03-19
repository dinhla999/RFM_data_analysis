# RFM_data_analysis
Tools: SQL, Tableau

From the dataset, I will query data sum of revenue by months, years, product categories, and Revenue Frequency Monetary analysis to identify high-value customers based on their purchasing behavior. 

# Overview my visualization on Tableau Public
https://public.tableau.com/app/profile/eleanor.la2696/viz/RFM_analysis_17414227492700/Dashboard1?publish=yes

- I will check the sales status listing. I see the status as shipped has completed sales, the others status has not completed contain revenue numbers as well.

![{CC4F1A90-CA7A-4A98-A301-657AB0D05F2A}](https://github.com/user-attachments/assets/22ad71b5-5494-4271-942d-dd6cf1f3bfbd)


Hence, I will eliminate 'Shipped' status when I sum up the sales amount.

- revenue by productline
  
![{8CC0C1ED-2E6C-4218-A474-BB7BD36BAECC}](https://github.com/user-attachments/assets/aaadab4d-1dd9-429b-9e02-a0e6b42a06a8)


- Revenue by year
  
![{82161854-8356-4BA9-B791-4BE74D178ED9}](https://github.com/user-attachments/assets/171ee36e-a803-4463-961f-ebefbe31c1fc)


- Revenue by month
  
![{FFF57161-76FB-4454-8D6F-FB9D886F120B}](https://github.com/user-attachments/assets/9e1b8d66-9df1-46fa-8f76-f63dd1900a94)


- Revenue by product size
  
![{794D34F8-BCDD-4A1B-808A-C103ACBD7BA3}](https://github.com/user-attachments/assets/4631948f-2786-4f74-9ecd-e96d860bd7d5)


- Most product category sales by year
  
![{0413B40D-3A61-4A5D-8D04-1D16308F3BD1}](https://github.com/user-attachments/assets/0be51959-9c79-4dd3-96cd-28cef0947d7e)


- Finally, I use CTE function to query customers who has last order date, count of purchased, and total amount has purchased.

![{30276FAF-F708-47E4-A7F8-59E182797E21}](https://github.com/user-attachments/assets/a734bbf8-a827-45a5-9aaa-6846dc4591a7)


