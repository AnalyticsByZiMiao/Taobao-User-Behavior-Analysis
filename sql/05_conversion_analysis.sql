# 用户行为转化分析

-- 用户行为转化路径1：点击-加购-购买

SELECT 
    '点击' AS 行为阶段,
    click_count AS 数量,
    NULL AS 转化率
FROM funnel_click_cart_purchase_view
UNION ALL
SELECT 
    '加购' AS 行为阶段,
    cart_count AS 数量,
    click_to_cart_rate AS 转化率
FROM funnel_click_cart_purchase_view
UNION ALL
SELECT 
    '购买' AS 行为阶段,
    purchase_count AS 数量,
    cart_to_purchase_rate AS 转化率
FROM funnel_click_cart_purchase_view;

-- 用户行为转化路径2：点击-收藏-购买

SELECT 
    '点击' AS 行为阶段,
    click_count AS 数量,
    NULL AS 转化率
FROM funnel_click_fav_purchase_view
UNION ALL
SELECT 
    '收藏' AS 行为阶段,
    fav_count AS 数量,
    click_to_fav_rate AS 转化率
FROM funnel_click_fav_purchase_view
UNION ALL
SELECT 
    '购买' AS 行为阶段,
    purchase_count AS 数量,
    fav_to_purchase_rate AS 转化率
FROM funnel_click_fav_purchase_view;

-- 用户行为转化路径3：点击-收藏+加购-购买
SELECT 
    '点击' AS 行为阶段,
    click_count AS 数量,
    NULL AS 转化率
FROM funnel_click_engagement_purchase_view
UNION ALL
SELECT 
    '互动' AS 行为阶段,
    engagement_count AS 数量,
    click_to_engagement_rate AS 转化率
FROM funnel_click_engagement_purchase_view
UNION ALL
SELECT 
    '购买' AS 行为阶段,
    purchase_count AS 数量,
    engagement_to_purchase_rate AS 转化率
FROM funnel_click_engagement_purchase_view;

-- 用户行为转化路径4：点击-直接购买

SELECT 
    '点击' AS 行为阶段,
    click_count AS 数量,
    NULL AS 转化率
FROM funnel_click_direct_purchase_view
UNION ALL
SELECT 
    '购买' AS 行为阶段,
    purchase_count AS 数量,
    click_to_purchase_rate AS 转化率
FROM funnel_click_direct_purchase_view;
