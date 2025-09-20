# 整体情况概览

-- 查询PV、UV、平均访问深度
SELECT
	COUNT(DISTINCT User_ID) AS 'UV',
	COUNT(User_ID) AS 'PV',
	COUNT(Behavior_type)/COUNT(DISTINCT User_ID) AS 'PV/UV'
FROM UserBehavior WHERE Behavior_type = 'pv';

