SELECT
    p.project_name,
    COUNT(t.task_id) AS open_task_count
FROM
    projects AS p
LEFT JOIN
    tasks AS t ON p.project_id = t.project_id
WHERE
    t.status = 'Open' OR t.status IS NULL -- This OR condition handles projects with no tasks at all correctly after a LEFT JOIN.
GROUP BY
    p.project_name
ORDER BY
    open_task_count DESC; -- Adding ORDER BY is good practice, it makes the report more useful.