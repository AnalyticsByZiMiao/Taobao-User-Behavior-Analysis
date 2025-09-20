# 数据库和表创建

-- 创建数据库
CREATE DATABASE IF NOT EXISTS taobao_user_behavior;
USE taobao_user_behavior;

-- 创建主表结构
CREATE TABLE user_behavior (
    user_id BIGINT,
    item_id BIGINT,
    category_id BIGINT,
    behavior_type VARCHAR(10),
    timestamp BIGINT
);