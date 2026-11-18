-- Q3. Average ticket size by calendar year: is UPI shifting to small everyday payments?
SELECT yr, ROUND(SUM(value_cr)*10.0/SUM(volume_mn)) AS avg_ticket_inr,
       ROUND(MIN(avg_ticket_inr)) AS min_month_ticket, ROUND(MAX(avg_ticket_inr)) AS max_month_ticket
FROM upi WHERE yr BETWEEN 2018 AND 2026 GROUP BY yr ORDER BY yr;
