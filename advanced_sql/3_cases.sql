SELECT
    job_id,
    job_title_short,
    salary_year_avg,
CASE
    WHEN salary_year_avg < 330000.0 THEN 'LOW'
    WHEN salary_year_avg BETWEEN 330001.0 AND 645000.0 THEN 'STANDARD'
    WHEN salary_year_avg > 645000.0 THEN 'HIGH'
    ELSE 'NOT SPECIFIED'
END AS salary_category         
FROM
    job_postings_fact
WHERE
    job_title_short = 'Data Analyst'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC    
