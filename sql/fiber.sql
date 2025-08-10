/*
This query calculates the total route miles of owned fiber in Georgia
that are considered "commercially active" by virtue of being part of at least
one active customer circuit and are allocated to the BEAD program.
*/

WITH
-- Step 1: Identify all unique fiber cables in Georgia that our company owns.
ga_owned_cables AS (
    SELECT DISTINCT
        fc.cable_id,
        fc.route_miles
    FROM
        fiber_cables AS fc
    JOIN
        cable_segments AS cs ON fc.cable_id = cs.cable_id
    WHERE
        fc.ownership_type = 'OWNED'
        AND cs.state = 'GA'
),

-- Step 2: Identify which of those cables are part of the BEAD program.
bead_program_cables AS (
    SELECT
        pa.cable_id
    FROM
        program_allocations AS pa
    WHERE
        pa.program_name = 'BEAD_GRANT_2025'
),

-- Step 3: Identify which cables are "commercially active" by having at least one active circuit provisioned on them.
commercially_active_cables AS (
    SELECT DISTINCT
        ctc.cable_id
    FROM
        circuits AS c
    JOIN
        circuit_to_cable_map AS ctc ON c.circuit_id = ctc.circuit_id
    WHERE
        c.status = 'ACTIVE'
)

-- Final Step: Join these sets and sum the route miles.
-- We select cables that appear in ALL THREE of our defined sets.
SELECT
    SUM(goc.route_miles) AS total_active_bead_route_miles_in_ga
FROM
    ga_owned_cables AS goc
-- Ensure the cable is part of the BEAD program
JOIN
    bead_program_cables AS bpc ON goc.cable_id = bpc.cable_id
-- Ensure the cable has at least one active commercial circuit
JOIN
    commercially_active_cables AS cac ON goc.cable_id = cac.cable_id;