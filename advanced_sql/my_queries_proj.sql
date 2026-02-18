
-- top paying jobs

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
ORDER BY
    salary_year_avg DESC

-- skills required for the top paying jobs

WITH top_paying_jobs AS (
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
    ORDER BY
        salary_year_avg DESC
),

skill_to_job AS(
    SELECT
        top_paying_jobs.*,
        skills
    FROM 
        top_paying_jobs
    INNER JOIN
        skills_job_dim
    ON
        top_paying_jobs.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim
    ON
        skills_job_dim.skill_id = skills_dim.skill_id
    ORDER BY 
        salary_year_avg DESC)

-- count of the top skills (in demand skills)

SELECT
    skills,
    count(*) AS skill_count
FROM
    skill_to_job
GROUP BY
    skills
ORDER BY
    skill_count DESC
LIMIT 5

--in demand skills with salary
--For the 5 most in-demand Data Analyst skills overall, what is their average salary

WITH top_skills_count AS (
    SELECT
        skills,
        count(skills_job_dim.job_id) AS demand_count
    FROM 
        job_postings_fact
    INNER JOIN
        skills_job_dim
    ON
        job_postings_fact.job_id = skills_job_dim.job_id
    INNER JOIN
        skills_dim
    ON
        skills_job_dim.skill_id = skills_dim.skill_id
    WHERE
        job_title_short = 'Data Analyst' AND
        job_location LIKE 'Chennai, %'
    GROUP BY
        skills
    ORDER BY
        demand_count DESC
    LIMIT 5
)

SELECT
    top_skills_count.*,
    ROUND(avg(salary_year_avg),0) AS avg_salary
FROM
    top_skills_count
JOIN skills_dim ON skills_dim.skills = top_skills_count.skills
JOIN skills_job_dim ON skills_job_dim.skill_id = skills_dim.skill_id
JOIN job_postings_fact ON skills_job_dim.job_id = job_postings_fact.job_id
WHERE 
    salary_year_avg IS NOT NULL
GROUP BY
    top_skills_count.skills,
    top_skills_count.demand_count
ORDER BY
    avg_salary DESC

-- top paying skills (irrespective of demand) with salary

SELECT 
    skills,
    ROUND(AVG(salary_year_avg), 0) AS avg_salary
FROM 
    job_postings_fact
INNER JOIN
    skills_job_dim
ON
    job_postings_fact.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
ON
    skills_job_dim.skill_id = skills_dim.skill_id
WHERE
    job_title_short = 'Data Analyst' AND
    job_location LIKE 'Chennai, %' AND
    salary_year_avg IS NOT NULL
GROUP BY
    skills
ORDER BY
    avg_salary DESC
LIMIT 25