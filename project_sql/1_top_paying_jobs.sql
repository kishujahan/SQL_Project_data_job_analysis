
SELECT
    job_id,
    job_title_short,
    job_location,
    salary_year_avg,
    name as company_name 
FROM 
    job_postings_fact
LEFT JOIN
    company_dim
ON
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_work_from_home = TRUE
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC
LIMIT 10

-- top paying jobs in chennai

SELECT
    job_id,
    job_title_short,
    job_location,
    job_schedule_type,
    salary_year_avg,
    name as company_name 
FROM
    job_postings_fact
LEFT JOIN
    company_dim
ON
    job_postings_fact.company_id = company_dim.company_id
WHERE
    job_title_short = 'Data Analyst'
    AND job_location like 'Chennai, %'
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC