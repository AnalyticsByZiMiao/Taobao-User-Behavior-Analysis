# 基于MySQL+Tablaeu的淘宝用户行为分析

---

## 一、项目背景

在当今激烈的电子商务竞争中，深入理解用户是构建竞争优势的核心。淘宝等平台每天产生数以亿计的用户交互数据，这些行为数据（浏览、收藏、加购、购买）是洞察用户偏好、优化产品策略、提升平台收益的宝贵资源。

然而，原始数据本身并不直接产生价值。唯有通过系统的数据清洗、深入的分析和直观的可视化，才能将庞大的数据转化为清晰的、可操作的​​商业洞察​​（Business Insights）。

本项目基于阿里巴巴提供的​​淘宝用户行为数据集​​（包含约1亿条真实匿名化的用户行为记录），旨在模拟电商行业数据分析师的完整工作流程：从原始数据获取开始，经历​​数据预处理、探索性分析、用户行为洞察到可视化展示​​的全过程，从而回答以下关键业务问题：

​​用户活跃规律​​：用户在哪天、哪个时间段最活跃？
​​用户行为转化​​：从“浏览”到“购买”的转化率如何？哪个环节流失最严重？
​​用户价值区分​​：如何根据用户价值进行分层（如RFM模型）？哪些是重要价值用户？
​​商品与品类表现​​：哪些商品和品类最受欢迎？

通过回答这些问题，本项目最终目标是​​构建一个全面的用户行为分析系统​​，为运营团队提供数据支持，以期在​​精准营销、优化用户体验、提升转化率​​等方面提供决策依据。

---

## 二、数据说明
### 1. 数据来源：
                https://tianchi.aliyun.com/dataset/649

### 2. 数据规模

**原始数据量**：​​约1亿条用户行为记录

**数据时间范围**：2017-11-25 至 2017-12-03（共9天）

**数据大小**：约3.5GB（CSV格式）


### 3. 字段说明
| 字段名 | 数据类型 | 说明 | 示例 |
| :--- | :--- | :--- | :--- |
| `user_id` | `BIGINT` | 匿名化处理的用户ID | `123456` |
| `item_id` | `BIGINT` | 匿名化处理的商品ID | `233845` |
| `category_id` | `BIGINT` | 匿名化处理的商品类目ID | `2520377` |
| `behavior_type` | `VARCHAR(10)` | 用户行为类型<br>- pv: 商品详情页浏览<br>- cart : 将商品加入购物车<br>- fav: 收藏商品<br>- buy: 购买商品 | `"pv"` |
| `timestamp` | `BIGINT` | 行为时间戳<br>(Unix时间戳，秒级) | `1512054127` |

---

## 三、项目目标

### (一) 构建业务问题

1. 总体运营情况如何，PV,UV和平均访问深度如何，日新增用户及占比如何，平台跳失率和复购率如何，有何存在需要改善或优化的地方；

2. 用户行为习惯如何，哪天用户最活跃、购买量最高，每天中用户哪个时段最活跃，各相对原因是什么，是否需要优化；

3. 用户商品偏好分析如何，哪种商品最受欢迎，用户的消费组成如何；

4. 各环节转化率如何，站内转化路径各环节是否存在可优化的地方；

5. 如何区分各用户群，哪些是核心用户，哪些是保持/发展/挽留客户，该怎么开展针对性营销活动。

### (二) 分析框架

<img src="../images/01 分析框架.png" alt="分析框架图" width="800" />

---

## 四、数据处理与分析
**工具**：MySQL 8.0，Navicat Premium Lite 17 ，Tableau 2024.3，Excel。

阿里天池的这个数据集解压出来3+G，数据条多达1亿条，Excel无法打开，直接通过Navicat导入MySQL速度极为缓慢，加上设备性能限制，故随机选取100W条数据导入Navicat。将数据进行预处理后，再编写SQL进行数据分析，并连接Tableau对检索结果进行可视化呈现。

## (一) 数据导入MySQL

### 1. 在navicat中创建表格UserBehavior，并命名字段

<img src="../images/01 创建表结构.png" alt="创建表结果" width="600" />

### 2. 开始导入数据

<img src="../images/02 导入向导1.png" alt="数据导入向导" width="600" />

### 3. 导入100W条数据

<img src="../images/03 导入向导2.png" alt="导入100w条数据" width="600" />

### 4. 打开导入数据后的表格

<img src="../images/08 查看表.png" alt="查看表" width="800" />

### 5. 查询数据的总行数

```sql

# 查询`UserBehavior`表总行数
SELECT COUNT(User_ID) as total_rows FROM ub;

```
<img src="../images/09 查询表总行数.png" alt="查看表总行数" width="500" />

可见，数据的总行数是1000000，导入完成。

## (二) 数据预处理

### 1. 处理重复值

``` sql

# 检查是否存在重复值，返回的结果就是重复值
SELECT * ,
       COUNT(*)
FROM userbehavior
GROUP BY User_ID,
         Item_ID,
         Category_ID,
         Behavior_type,
         Timestamp
HAVING COUNT(*) > 1;

```

<img src="../images/10 检查重复值.png" alt="检查重复值" width="500" />

可见，不存在重复值。

### 2. 检查并处理缺失值，排除NULL值

``` sql

SELECT COUNT(User_ID),
       COUNT(Item_ID),
       COUNT(Category_ID),
       COUNT(Behavior_type),
       COUNT(Timestamp)
FROM userbehavior;

```
<img src="../images/10 查询缺失值.png" alt="查找缺失值" width="700" />

可见，所有列的计数计算结果都是100W，故不存在缺失值。

### 3. 时间处理，将时间戳转化为正常日期和时间

时间戳Timestamp无法直接进行分析，需要利用from_unixtime()函数将时间戳转化成3列：日期和时间，日期，小时。

``` sql

# 将Timestamp转化为正常的时间

-- 在UserBehavior表中添加3个字段：Datetime, Date, Hour
ALTER TABLE UserBehavior 
ADD Datetime VARCHAR(20);

ALTER TABLE UserBehavior 
ADD Date VARCHAR(15);

ALTER TABLE UserBehavior 
ADD Hour INT(5);

#将时间戳转换成日常形式
UPDATE userBehavior 
SET `datetime` = DATE_FORMAT(FROM_UNIXTIME(`timestamp`), '%Y-%m-%d %H:%i:%s');

#将时间戳转换成日期格式
UPDATE UserBehavior 
SET date = DATE(from_unixtime(TIMESTAMP));

#将时间戳转换成小时格式
UPDATE UserBehavior 
SET hour = HOUR(from_unixtime(TIMESTAMP));

```

查询表数据

``` sql

# 查询实现时间转化后的表数据
SELECT * FROM UserBehavior

```

<img src="../images/10 查询修改时间后的表数据.png" alt="查看表" width="700" />

查看结果可见，转换已完成。

删除 `timestamp` 字段

``` sql 

#删除timestamp字段
ALTER TABLE ub drop timestamp;

```

<img src="../images/10 删除 timestamp后的表.png" alt="查看表" width="700" />

查看结果可见，已删除 `timestamp`字段。

### 4. 查找是否存在异常时间

``` sql

#查找是否存在异常时间
SELECT date 
FROM UserBehavior 
WHERE date IS NOT NULL 
ORDER BY date;  -- 顺序

```

<img src="../images/11 查找异常时间-顺序.png" alt="按时间顺序排序的表" width="700" />


``` sql

SELECT date 
FROM UserBehavior 
WHERE date IS NOT NULL 
ORDER BY date DESC;  -- 逆序

```

<img src="../images/12 查找异常时间-逆序.png" alt="按时间逆序排序的表" width="700" />

数据时间范围应在2017-11-25和2017-12-03之间，可见存在不少在2017-11-25之前，或者在2017-12-03之后的时间，属于异常值，需要删除：

``` sql

#删除字段之前先来个备份
CREATE TABLE UserBehavior_origin 
SELECT * 
FROM UserBehavior;

```

``` sql

#检验备份是否成功
SELECT * 
FROM UserBehavior_origin 
LIMIT 20;

```

<img src="../images/12 查询备份是否成功.png" alt="按时间逆序排序的表" width="700" />

``` sql

#删除时间异常值
DELETE FROM UserBehavior
 WHERE datetime < '2017-11-25';

DELETE FROM UserBehavior 
WHERE datetime > '2017-12-04';

```

<img src="../images/13 删除时间异常的行.png" alt="删除时间异常的值" width="500" />

删除异常值后，查询剩余的行数

<img src="../images/14 删除时间异常值后剩余行数.png" alt="删除时间异常的值" width="400" />

至此，数据预处理完成

## (三) 数据分析阶段

### 1. 整体情况概览

**业务指标**：总访问量PV,总访客数UV和平均访问深度PV/UV

```

-- PV(Page View)：总访问量，指用户访问页面的总数
-- UV(Unique Visitor)：访客数量，一个用户ID为一个访客数
-- 平均访问深度：也称平均访问量，指用户每次浏览页面的平均值，PV/UV

```

``` sql 

SELECT
	COUNT(DISTINCT User_ID) AS 'UV',
	COUNT(User_ID) AS 'PV',
	COUNT(Behavior_type)/COUNT(DISTINCT User_ID) AS 'PV/UV'
FROM UserBehavior WHERE Behavior_type = 'pv';

```

