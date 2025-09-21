# 用户行为习惯分析

-- 查询日均UV、PV
SELECT activity_date AS date,
       daily_uv AS '日均UV',
       daily_pv AS '日均PV'
FROM daily_activity_summary_view;

-- 查询小时均PV和UV

SELECT Hour,
COUNT(DISTINCT User_ID) AS '各小时访客数',
SUM(case when Behavior_type = 'pv' THEN 1 ELSE 0 END) AS '各小时访问量'
FROM UserBehavior
GROUP BY hour 
ORDER BY Hour;