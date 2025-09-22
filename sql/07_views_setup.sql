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

-- 创建视图4：用户行为总量的汇总视图
CREATE OR REPLACE VIEW user_behavior_totals_view AS
SELECT 
    SUM(CASE WHEN Behavior_type = 'pv' THEN 1 ELSE 0 END) AS total_pv,
    SUM(CASE WHEN Behavior_type = 'fav' THEN 1 ELSE 0 END) AS total_fav,
    SUM(CASE WHEN Behavior_type = 'cart' THEN 1 ELSE 0 END) AS total_cart,
    SUM(CASE WHEN Behavior_type = 'buy' THEN 1 ELSE 0 END) AS total_buy
FROM UserBehavior;

-- 创建视图5：用户路径分析视图-路径1：点击-加购-购买
CREATE OR REPLACE VIEW funnel_click_cart_purchase_view AS
SELECT 
    total_pv AS click_count,
    total_cart AS cart_count,
    total_buy AS purchase_count,
    ROUND(total_cart / total_pv * 100, 2) AS click_to_cart_rate,
    ROUND(total_buy / total_cart * 100, 2) AS cart_to_purchase_rate
FROM user_behavior_totals_view;


-- 创建视图6：用户路径分析视图-路径2：点击-收藏-购买
CREATE OR REPLACE VIEW funnel_click_fav_purchase_view AS
SELECT 
    total_pv AS click_count,
    total_fav AS fav_count,
    total_buy AS purchase_count,
    ROUND(total_fav / total_pv * 100, 2) AS click_to_fav_rate,
    ROUND(total_buy / total_fav * 100, 2) AS fav_to_purchase_rate
FROM user_behavior_totals_view;


-- 创建视图7：用户路径分析视图-路径3：点击-收藏+加购-购买
CREATE OR REPLACE VIEW funnel_click_engagement_purchase_view AS
SELECT 
    total_pv AS click_count,
    total_fav + total_cart AS engagement_count,
    total_buy AS purchase_count,
    ROUND((total_fav + total_cart) / total_pv * 100, 2) AS click_to_engagement_rate,
    ROUND(total_buy / (total_fav + total_cart) * 100, 2) AS engagement_to_purchase_rate
FROM user_behavior_totals_view;


-- 创建视图8：用户路径分析视图-路径4：点击-购买（直接购买）
CREATE OR REPLACE VIEW funnel_click_direct_purchase_view AS
SELECT 
    total_pv AS click_count,
    total_buy AS purchase_count,
    ROUND(total_buy / total_pv * 100, 2) AS click_to_purchase_rate
FROM user_behavior_totals_view;


-- 创建视图9：计算每个用户的RFM模型中的R（最近一次消费时间间隔）和F（消费次数）指标​​
CREATE OR REPLACE VIEW user_rf_analysis_view AS
SELECT
    User_ID,
    DATEDIFF('2017-12-03', MAX(datetime)) AS R,
    COUNT(*) AS F
FROM UserBehavior
WHERE Behavior_type = 'buy'
GROUP BY User_ID
ORDER BY R, F DESC;


-- 创建视图10：用户消费行为高低状态视图
CREATE OR REPLACE VIEW user_consumption_level_view AS
SELECT 
    User_ID,
    R,
    F,
    (CASE WHEN R < 2 THEN '高' ELSE '低' END) AS '消费时间间隔',
    (CASE WHEN F > 3.0437 THEN '高' ELSE '低' END) AS '消费频率'
FROM user_rf_analysis_view;