I don't know that it is necessarily possible, or at least not advisable, to actively query for deadlock scenarios.  Because Postgres will automatically terminate one of the involved transactions within the configured deadlock_timeout period, there is a very small window (default 1s) under which this scenario would even be detectable.

While approaches like the following example ([source](https://wiki.postgresql.org/wiki/Lock_Monitoring)) are common, this query will not only reflect true "deadlock" conditions but also includes the typical lock waiting that is expected to some degree:

```
SELECT 
       blocked_locks.pid	 AS blocked_pid,
       blocked_activity.usename  AS blocked_user,
       blocking_locks.pid     	 AS blocking_pid,
       blocking_activity.usename AS blocking_user,
       blocked_activity.query    AS blocked_statement,
       blocking_activity.query   AS current_statement_in_blocking_process
FROM  pg_catalog.pg_locks        blocked_locks
JOIN pg_catalog.pg_stat_activity blocked_activity ON blocked_activity.pid = blocked_locks.pid
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
```

Additionally, approaches like the above have been criticized as insufficient; determing whether a process is truly blocked by another also involves inspecting the lock mode and how the lock modes affect each other, which would need to be codified into the query to achieve a more accurate result.  Basically, it is a pretty complex determination which led to the introduction of the `pg_blocking_pids` function in PostgreSQL 9.6.

It may be possible to achieve a more accurate result using `pg_blocking_pids` in conjunction with other data from the `pg_locks` and `pg_stat_activity` tables.  However, given the notes in the function documentation regarding potential performance degradation with frequent use, I would be hesitant to use this approach for any kind of "active" lock monitoring.

In general, I think that it is best to let Postgres handle deadlocks as it has been designed to, and it seems like methods that attempt to proactively detect these conditions are either potentially unreliable or have negative performance implications.

About a year ago, I wrote a blog post about my approach to [investigating deadlock issues at Shiftgig](https://medium.com/@clairesimmonds/postgresql-decoding-deadlocks-183e6a792fd3).

Otherwise, I wrote the following query that my team could use to check for other types of lock issues.  We were specifically having problems with locks that were being held for an unreasonable amount of time in idle transactions.  We were able to use this query to identify that the owning application processes were, in some cases, being abnormally terminated, which did not release the associated Postgres connection.

```
SELECT
    pgl.pid,
    pgl.mode,
    pgl.granted,
    psa.usename,
    psa.backend_start,
    psa.xact_start,
    psa.state,
    current_timestamp - psa.xact_start as delta,
    psa.query
FROM pg_locks pgl
JOIN pg_stat_activity psa ON psa.pid = pgl.pid
WHERE (current_timestamp - psa.xact_start) > '1 hour';
```
