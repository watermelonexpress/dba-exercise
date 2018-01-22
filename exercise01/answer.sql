--Given the tables and records defined setup.sql. Select the names of the programmers who have every desired skill.

SELECT a.programmer_name
FROM programmer_skills a
INNER JOIN desired_skills b
ON a.skill_name = b.skill_name
GROUP BY a.programmer_name
HAVING count(*) = (SELECT count(*) FROM desired_skills)
;
