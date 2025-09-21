# 用户商品偏好分析

-- 查询点击量前10的商类目

SELECT 
    Category_ID,
    COUNT(*) as pv_category 
FROM UserBehavior 
WHERE Behavior_type='pv' 
GROUP BY category_ID 
ORDER BY pv_category DESC 
limit 10;

-- 查询收藏量前10的商类目

SELECT 
    Category_ID,COUNT(*) as fav_category 
FROM UserBehavior
WHERE Behavior_type='fav' 
GROUP BY category_ID
ORDER BY fav_category DESC 
limit 10;

-- 查询加购量前10的商类目

SELECT 
    Category_ID,COUNT(*) as cart_category 
FROM UserBehavior
WHERE Behavior_type='cart' 
GROUP BY category_ID 
ORDER BY cart_category DESC 
limit 10;

-- 查询购买量前10的商类目

SELECT 
    Category_ID,COUNT(*) as buy_category 
FROM UserBehavior
WHERE Behavior_type='buy' 
GROUP BY category_ID 
ORDER BY buy_category DESC 
limit 10;
