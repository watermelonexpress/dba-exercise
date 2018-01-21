SELECT name, count(*) AS count_for_non_unique
FROM users
GROUP BY name
HAVING count(*) > 1
;
