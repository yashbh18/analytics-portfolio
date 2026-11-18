-- Q4. Is growth coming from more banks or deeper use? Banks live vs volume per bank, every March
SELECT month, banks_live, volume_mn, volume_per_bank_mn,
       ROUND(100.0*(banks_live*1.0/LAG(banks_live) OVER (ORDER BY month) - 1),1) AS banks_growth_pct,
       ROUND(100.0*(volume_per_bank_mn/LAG(volume_per_bank_mn) OVER (ORDER BY month) - 1),1) AS per_bank_growth_pct
FROM upi WHERE mon = 3 AND yr >= 2018 ORDER BY month;
