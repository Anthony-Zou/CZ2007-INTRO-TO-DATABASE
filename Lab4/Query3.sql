-- Return the descriptions of all the 2nd level product types. The product types with no parent will be regarded as 1st level product types and their direct child product types will be regarded as 2nd level.


-- 1st table: all product types, 2nd table: only 1st level product types
-- from 1st table, select all records whose id is IN 2nd table

SELECT PT2.description                 ---2. find those whose parent_id are in 1st level product type then they are 2nd level
FROM PRODUCT_TYPE PT2
WHERE PT2.Parent_id IN (
    SELECT PT1.Id             ---1. find the 1st level product type (who doesn't have parent type)
    FROM PRODUCT_TYPE PT1
    WHERE PT1.Parent_id is NULL
);

-- --if consider product lvl 3 is relative as second lvl from lvl 2
-- SELECT PT2.description                 ---2. find those whose parent_id are in 1st level product type then they are 2nd level
-- FROM PRODUCT_TYPE PT2
-- WHERE PT2.Id IN (
--     SELECT PT1.Id             ---1. find the 1st level product type (who doesn't have parent type)
--     FROM PRODUCT_TYPE PT1
--     WHERE PT1.Parent_id is not NULL
-- );

