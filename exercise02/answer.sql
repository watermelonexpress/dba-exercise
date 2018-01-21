--let me start this answer by saying that my usual fix for deadlocks is:
--select * from pg_stat_activity
--check if my process has (wait_event_type like '%Lock')
--then kill anything that has a query that might be interfering with the deadlock I am noticing using select pg_terminate_backend(pid)
--and if that doesn't fix it, reboot the RDS (which is likely not a valid option for BenchPrep solution)

--i havent used 9.6 before, but apparently there is a new function which has improved speed/accuracy over the typical pg_locks self-joins:
--NOTE: SYNTAX NOT TESTED YET
SELECT a.*, b.query AS blocker_query
FROM (
      SELECT pid AS blocked_pid, query AS blocked_query, unnest(pg_blocking_pids(pid)) AS blocked_by
      FROM pg_stat_activity WHERE pg_blocking_pids(pid) IS NOT NULL
      ) a
LEFT JOIN pg_stat_activity b
ON a.blocked_pid = b.pid
ORDER BY a.blocked_pid, b.pid
;

--Prior to 9.6, I would have had to think through something that detects deadlocks reliably instead of reactively.
--Reactively, I would use something like this:
--https://wiki.postgresql.org/wiki/Lock_Monitoring
--NOTE: SYNTAX NOT TESTED YET

  SELECT blocked_locks.pid     AS blocked_pid,
         blocked_activity.usename  AS blocked_user,
         blocking_locks.pid     AS blocking_pid,
         blocking_activity.usename AS blocking_user,
         blocked_activity.query    AS blocked_statement,
         blocking_activity.query   AS current_statement_in_blocking_process
   FROM  pg_catalog.pg_locks         blocked_locks
    JOIN pg_catalog.pg_stat_activity blocked_activity  ON blocked_activity.pid = blocked_locks.pid
    JOIN pg_catalog.pg_locks         blocking_locks 
        ON blocking_locks.locktype = blocked_locks.locktype
        AND blocking_locks.DATABASE IS NOT DISTINCT FROM blocked_locks.DATABASE
        AND blocking_locks.relation IS NOT DISTINCT FROM blocked_locks.relation
        AND blocking_locks.page IS NOT DISTINCT FROM blocked_locks.page
        AND blocking_locks.tuple IS NOT DISTINCT FROM blocked_locks.tuple
        AND blocking_locks.virtualxid IS NOT DISTINCT FROM blocked_locks.virtualxid
        AND blocking_locks.transactionid IS NOT DISTINCT FROM blocked_locks.transactionid
        AND blocking_locks.classid IS NOT DISTINCT FROM blocked_locks.classid
        AND blocking_locks.objid IS NOT DISTINCT FROM blocked_locks.objid
        AND blocking_locks.objsubid IS NOT DISTINCT FROM blocked_locks.objsubid
        AND blocking_locks.pid != blocked_locks.pid
 
    JOIN pg_catalog.pg_stat_activity blocking_activity ON blocking_activity.pid = blocking_locks.pid
   WHERE NOT blocked_locks.GRANTED;

