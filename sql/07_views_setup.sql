# 所有视图创建

-- 创建视图1：创建每日活动汇总视图
CREATE OR REPLACE VIEW daily_activity_summary_view AS
SELECT
    DATE(Datetime) AS activity_date,
    COUNT(DISTINCT User_ID) AS daily_uv,
    COUNT(*) AS daily_pv
FROM UserBehavior
WHERE Behavior_type = 'pv'
GROUP BY DATE(Datetime);

-- 创建视图2：创建用户首次浏览行为视图
CREATE OR REPLACE VIEW user_first_browse_view AS 
SELECT
    User_ID,
    MIN(Datetime) AS first_browse_time,
    DATE(MIN(Datetime)) AS first_browse_date
FROM UserBehavior
WHERE Behavior_type = 'pv' 
GROUP BY User_ID;


-- 创建视图3：关于用户购买次数的视图

CREATE OR REPLACE VIEW user_purchase_count_view AS
SELECT 
    User_ID,
    COUNT(*) AS '购物次数'
    -- 移除了其他非聚合列，如 Item_ID, Category_ID 等
FROM UserBehavior
WHERE Behavior_type = 'buy' 
GROUP BY User_ID;