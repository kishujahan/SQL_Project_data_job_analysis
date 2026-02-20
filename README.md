# SQL Project – Job Postings Analysis

## 📌 Project Overview
This project is a SQL-based data analysis project inspired by the tutorial from [Luke Barousse](https://youtu.be/7mz73uXD9DA?si=fCw8jLE0HWVsFkUr)

While I followed the overall structure of the guided project, I independently wrote and validated the queries to ensure I understood each concept.

Instead of copying the exact filters used in the video (e.g., Work From Home roles and salary filters), I customized the queries to analyze job postings for Chennai, India. Since certain filters returned no results for this region, I adjusted the conditions accordingly while maintaining correct output logic.

These modifications helped me build practical problem-solving skills and improve my SQL understanding beyond just following the tutorial.

Check out the SQL queries here: 
1. [project_sql folder](/project_sql/) 
2. [my_queries_proj file](/advanced_sql/my_queries_proj.sql)

## 📂 Dataset Description

The dataset used for this project contains job postings from 2023. It includes information such as Job title, Salary details (average yearly salary), Required skills, Company name, Location and more.

The dataset consists of the following tables:

job_postings_fact

skills_job_dim

skills_dim


## 🎯 Objectives

- What are the top paying data analyst jobs?
- What skills are required for these top paying jobs?
- What skills are most in demand for data analysts?
- Which skills are associated with higher salaries?
- What are the most optimal skills to learn?

## 🛠️ Concepts Used

- SELECT, WHERE, GROUP BY, ORDER BY

- JOINs (Left Join, Inner Join)

- Subqueries & Common Table Expressions (CTEs)

- Aggregate Functions (COUNT, AVG)

- Filtering & conditional logic

### 📚 Additional Concepts Learned

- CASE statements
- UNION and UNION ALL
- Date functoins

## 📊 Data Analyst Job Market Analysis - Chennai

**1. Top Paying Jobs**

To identify the highest paying roles, I filtered Data Analyst postions by location. And listed them in descending order of salary to pinpoint the most rewarding postings in the job market.
```sql
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
```
💡 **Insight**

A significant number of postings did not disclose salary information and were excluded from this ranking. However, among the roles with available salary data, companies such as **Poshmark, Freshworks, Arcadia, and Appian** appear among the higher-paying listings.

**2. Skills required for the Top Paying Jobs**

To identify the skills that are associated with the highest-paying Data Analyst jobs in Chennai, I first created the top_paying_jobs query as CTE and then joined with the skills tables (skills_job_dim and skills_dim) to identify the skills that are required for the jobs.
```sql
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
    AND salary_year_avg IS NOT NULL
ORDER BY
    salary_year_avg DESC)
SELECT
    top_paying_jobs.*,
    skills
FROM top_paying_jobs
INNER JOIN
    skills_job_dim
ON
    top_paying_jobs.job_id = skills_job_dim.job_id
INNER JOIN
    skills_dim
ON
    skills_job_dim.skill_id = skills_dim.skill_id
ORDER BY salary_year_avg DESC
```
💡 **Insight**

The analysis shows that high-paying Data Analyst roles in Chennai commonly require skills such as **SQL, Python, Excel, Tableau, Power BI.** Advanced tools such as **Spark** and BI platforms like **Looker** can also be seen in some of the high paying roles.

**3. In-Demand Skills for Data Analysts**

This query identifies the top five most frequently requested skills for Data Analyst roles in Chennai. It joins the job postings fact table with the skills tables, filters for Chennai based Data Analyst positions, groups by skill name, and counts how often each skill appears. The results are ordered by demand in descending order to highlight the most sought-after skills.
```SQL
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
```
💡 **Insight**

The results show that **SQL is the most in-demand skill, followed by Python, Excel, and Tableau**, which indicates, strong database querying skills are essential for Data Analyst roles. Additionally, programming (Python) and data visualization tools are also highly valued.

**4. Top Paying Skills**

```sql
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
```
💡 **Insight**

The results show that skills such as **Spark, SQL, Python, and cloud-related technologies** command higher average salaries compared to traditional tools like Excel or Power BI. This suggests that while foundational skills (SQL, Excel) are essential, advanced skills and big data technologies significantly increase earning potential.

**5. Optimal Skills**

This query identifies which skills are in-demand and are also high-paying.
```SQL
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
```
💡 **Insight**

The results show that **Python and R** command higher pay despite slightly lower demand than SQL. This suggests that programming and statistical skills provide a salary advantage, even if they are not the most frequently requested. Additionally, tools like Tableau and Excel remain consistently relevant, indicating that data visualization and reporting skills are essential alongside technical querying abilities.


