# 该sql文件存储数据清洗阶段代码

# 01 查询表的总行数
SELECT COUNT(User_ID) AS total_rows 
FROM UserBehavior;
/*总行数为1000000*/

# 02 检查重复值
SELECT * ,
       COUNT(*)
FROM userbehavior
GROUP BY User_ID,
         Item_ID,
         Category_ID,
         Behavior_type,
         Timestamp
HAVING COUNT(*) > 1;
/*返回结果为空，表示没有重复值*/

# 03 处理缺失值
SELECT COUNT(User_ID),
       COUNT(Item_ID),
       COUNT(Category_ID),
       COUNT(Behavior_type),
       COUNT(Timestamp)
FROM userbehavior;
/*5个计数值均为1000000，表示没有缺失值*/

# 04 一致化处理
-- 时间戳Timestamp无法直接进行分析，需要利用from_unixtime()函数将其转化成3列：日期和时间，日期，小时

# 将Timestamp转化为正常的时间

-- 在UserBehavior表中添加3个字段：Datetime, Date, Hour
ALTER TABLE UserBehavior ADD Datetime VARCHAR(20);
ALTER TABLE UserBehavior ADD Date VARCHAR(15);
ALTER TABLE UserBehavior ADD Hour INT(5);

#将时间戳转换成日常形式
UPDATE userBehavior SET `datetime` = DATE_FORMAT(FROM_UNIXTIME(`timestamp`), '%Y-%m-%d %H:%i:%s');

#将时间戳转换成日期格式
UPDATE UserBehavior SET date = DATE(from_unixtime(TIMESTAMP));

#将时间戳转换成小时格式
UPDATE UserBehavior SET hour = HOUR(from_unixtime(TIMESTAMP));


