
SELECT
    skills_dim.skills AS skill_name,
    skills_dim.type AS  skill_type,
    job_postings_fact.job_title_short
 FROM
    skills_dim
JOIN
    skills_job_dim
ON
    skills_job_dim.skill_id = skills_dim.skill_id
JOIN
    job_postings_fact
ON
    job_postings_fact.job_id = skills_job_dim.job_id
WHERE
    EXTRACT (quarter FROM job_postings_fact.job_posted_date) = 1 AND
    job_postings_fact.salary_year_avg>70000

UNION ALL

SELECT
    job_postings_fact.job_title_short,
    NULL AS skill_name,
    NULL AS skill_type
FROM
    job_postings_fact
JOIN
    skills_job_dim
ON
    skills_job_dim.job_id = job_postings_fact.job_id
WHERE
    EXTRACT (QUARTER FROM job_postings_fact.job_posted_date) = 1
    AND salary_year_avg>70000
    AND skills_job_dim.job_id IS NULL

    
SELECT COUNT(*)
FROM job_postings_fact j
LEFT JOIN skills_job_dim sj
  ON j.job_id = sj.job_id
WHERE sj.job_id IS NULL;
