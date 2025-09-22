# 用户价值分析(RFM模型)

-- 查询R和F
SELECT *
FROM user_rf_analysis_view;

-- 求出R和F的均值
SELECT 
    AVG(R) AS AVG_R,
    AVG( F) AS AVG_F 
FROM user_rf_analysis_view;