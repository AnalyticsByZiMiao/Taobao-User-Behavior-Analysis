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