SELECT programmer_name
FROM programmer_skills
GROUP BY programmer_name
HAVING array_agg(skill_name) @> ARRAY(SELECT skill_name FROM desired_skills);
