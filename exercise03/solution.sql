SELECT name, count(id)
FROM users
GROUP BY name
HAVING count(id) > 1;
