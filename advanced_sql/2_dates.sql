SELECT 
   DISTINCT company.name
FROM
    job_postings_fact jobs
JOIN
    company_dim company
ON
    jobs.company_id=company.company_id
WHERE
    jobs.job_health_insurance=TRUE  
    and EXTRACT(YEAR FROM job_posted_date)=2023
    and EXTRACT(quarter FROM job_posted_date)=2