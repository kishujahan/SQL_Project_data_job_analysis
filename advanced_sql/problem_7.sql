
WITH remote_job_skills AS (
    SELECT
        skill_id,
        count(*) AS skill_count
    FROM
        skills_job_dim sjd
    INNER JOIN
        job_postings_fact jpf
    ON
        jpf.job_id = sjd.job_id
    WHERE
        jpf.job_work_from_home= TRUE AND
        jpf.job_title_short = 'Data Analyst'
    GROUP BY
        skill_id)

SELECT
    skills.skill_id,
    skills AS skill_name,
    skill_count
FROM
    remote_job_skills
INNER JOIN
    skills_dim AS skills
ON
    skills.skill_id = remote_job_skills.skill_id
ORDER BY
    skill_count DESC
LIMIT 5