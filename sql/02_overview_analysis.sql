# 整体情况概览

-- 查询PV、UV、平均访问深度
SELECT
	COUNT(DISTINCT User_ID) AS 'UV',
	COUNT(User_ID) AS 'PV',
	COUNT(Behavior_type)/COUNT(DISTINCT User_ID) AS 'PV/UV'
FROM UserBehavior WHERE Behavior_type = 'pv';

-- 查询日增新用户数及占比
SELECT
    fbv.first_browse_date AS 统计日期,
    COUNT(fbv.User_ID) AS 日增新用户数,
    dasv.daily_uv AS 日均UV,
    dasv.daily_uv - COUNT(fbv.User_ID) AS 差额人数,
    ROUND(COUNT(fbv.User_ID) / dasv.daily_uv * 100, 2) AS 日新用户占比百分比
FROM user_first_browse_view fbv
JOIN daily_activity_summary_view dasv ON dasv.activity_date = fbv.first_browse_date
GROUP BY fbv.first_browse_date, dasv.daily_uv
ORDER BY fbv.first_browse_date;

-- 计算跳失率

SELECT
	COUNT(a.behavior_num) AS '只浏览一次的访问总数',
	(SELECT count(Behavior_type) FROM UserBehavior WHERE Behavior_type = 'pv' ) AS '访问总数',
	concat(ROUND((COUNT(a.behavior_num)/(SELECT COUNT(Behavior_type) FROM UserBehavior WHERE Behavior_type = 'pv')) * 100,2),'%') AS '跳失率'
FROM
	(SELECT User_ID, COUNT(Behavior_type) AS behavior_num
	FROM UserBehavior WHERE Behavior_type = 'pv' GROUP BY User_ID HAVING COUNT(Behavior_type <= 1)) AS a;

-- 计算复购率

SELECT SUM(CASE WHEN 购物次数 > 1 THEN 1 ELSE 0 END)/COUNT(User_ID) AS '复购率' 
FROM user_purchase_count_view;

