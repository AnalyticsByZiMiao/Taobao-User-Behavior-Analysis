# 所有视图创建

-- 创建视图1：创建每日活动汇总视图
CREATE OR REPLACE VIEW daily_activity_summary_view AS
SELECT
    DATE(Datetime) AS activity_date,
    COUNT(DISTINCT User_ID) AS daily_uv,
    COUNT(*) AS daily_pv
FROM ub
WHERE Behavior_type = 'pv'
GROUP BY DATE(Datetime);

-- 创建视图2：创建用户首次浏览行为视图
CREATE OR REPLACE VIEW user_first_browse_view AS 
SELECT
    User_ID,
    MIN(Datetime) AS first_browse_time,
    DATE(MIN(Datetime)) AS first_browse_date
FROM ub 
WHERE Behavior_type = 'pv' 
GROUP BY User_ID;

-- 查询日增新用户数及占比
SELECT
    fbv.first_browse_date AS 统计日期,
    COUNT(*) AS 日增新用户数,
    dasv.daily_uv AS 日均活跃用户数,
    ROUND(COUNT(*) / dasv.daily_uv * 100, 2) AS 日新用户占比百分比
FROM user_first_browse_view fbv
INNER JOIN daily_activity_summary_view dasv ON dasv.activity_date = fbv.first_browse_date
GROUP BY fbv.first_browse_date;