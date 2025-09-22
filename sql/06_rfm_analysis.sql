# 用户价值分析(RFM模型)

-- 查询R和F
SELECT *
FROM user_rf_analysis_view;

-- 求出R和F的均值
SELECT 
    AVG(R) AS AVG_R,
    AVG( F) AS AVG_F 
FROM user_rf_analysis_view;

-- 查询不同R值对应人数及其占比 user_r_value_distribution
SELECT
    R,
    COUNT(*) AS R值对应人数,
    COUNT(*) / (SELECT COUNT(*) FROM user_rf_analysis_view) AS 占比,
    SUM(COUNT(*)) OVER (ORDER BY R) / (SELECT COUNT(*) FROM user_rf_analysis_view) AS 累计占比
FROM user_rf_analysis_view
GROUP BY R
ORDER BY R;

-- 查询不同F值对应人数及其占比 
SELECT 
SELECT
    F,
    COUNT(*) AS F值对应人数,
    COUNT(*) / (SELECT COUNT(*) FROM user_rf_analysis_view) AS 占比,
    SUM(COUNT(*)) OVER (ORDER BY F) / (SELECT COUNT(*) FROM user_rf_analysis_view) AS 累计占比
FROM user_rf_analysis_view
GROUP BY F
ORDER BY F;

-- 查询用户消费行为高低状态
SELECT *
FROM user_consumption_level_view;

-- 用户价值判定
SELECT 
    User_ID,
    消费时间间隔,
    消费频率,
    (
        case 
        when 消费时间间隔='高' and 消费频率='高' then '价值用户'
        when 消费时间间隔='高' and 消费频率='低' then '发展用户'
        when 消费时间间隔='低' and 消费频率='高' then '保持用户'
        when 消费时间间隔='低' and 消费频率='低' then '挽留用户'
        END
    ) as '用户类型'
FROM user_consumption_level_view;

-- 计算各用户群人数
SELECT 
    SUM(case WHEN 消费时间间隔='高' and 消费频率='高' then '1' END) as '价值用户数量',
    SUM(case WHEN 消费时间间隔='高' and 消费频率='低' then '1' END) as '发展用户数量',
    SUM(case WHEN 消费时间间隔='低' and 消费频率='高' then '1' END) as '保持用户数量',
    SUM(case WHEN 消费时间间隔='低' and 消费频率='低' then '1' END) as '挽留用户数量'
FROM user_consumption_level_view

-- 计算各用户群人数及所占比例
SELECT 
    用户价值,
    用户数量,
    CONCAT(ROUND(用户数量 * 100.0 / total_users, 2), '%') AS 用户占比
FROM (
    SELECT 
        '价值用户' AS 用户价值,
        COUNT(CASE WHEN 消费时间间隔='高' AND 消费频率='高' THEN 1 END) AS 用户数量
    FROM user_consumption_level_view
    
    UNION ALL
    
    SELECT 
        '发展用户' AS 用户价值,
        COUNT(CASE WHEN 消费时间间隔='高' AND 消费频率='低' THEN 1 END) AS 用户数量
    FROM user_consumption_level_view
    
    UNION ALL
    
    SELECT 
        '保持用户' AS 用户价值,
        COUNT(CASE WHEN 消费时间间隔='低' AND 消费频率='高' THEN 1 END) AS 用户数量
    FROM user_consumption_level_view
    
    UNION ALL
    
    SELECT 
        '挽留用户' AS 用户价值,
        COUNT(CASE WHEN 消费时间间隔='低' AND 消费频率='低' THEN 1 END) AS 用户数量
    FROM user_consumption_level_view
) AS segments
CROSS JOIN (
    SELECT COUNT(*) AS total_users FROM user_consumption_level_view
) AS total;