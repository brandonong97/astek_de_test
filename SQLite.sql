WITH RECURSIVE step_order AS (
    -- Anchor member: start with steps that have no dependencies (STEP_DEP_ID = 0)
    SELECT STEP_SEQ_ID, STEP_DEP_ID, 1 AS seq_id
    FROM DEPENDENCY_RULES
    WHERE STEP_DEP_ID = 0

    UNION ALL

    -- Recursive member: get steps that depend on already processed steps
    SELECT s.STEP_SEQ_ID, s.STEP_DEP_ID, so.seq_id + 1
    FROM DEPENDENCY_RULES s
    JOIN step_order so ON s.STEP_DEP_ID = so.STEP_SEQ_ID
)
-- Select the ordered steps with their generated seq_id of each unique row
SELECT distinct a.STEP_SEQ_ID, b.STEP_PROG_NAME
FROM step_order AS a
LEFT join PROG_NAME as b
ON a.step_seq_id = b.STEP_SEQ_ID
ORDER BY a.seq_id, a.STEP_SEQ_ID;