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
### (一) 数据来源：
                https://tianchi.aliyun.com/dataset/649

### (二) 数据规模

**原始数据量**：​​约1亿条用户行为记录

**数据时间范围**：2017-11-25 至 2017-12-03（共9天）

**数据大小**：约3.5GB（CSV格式）


### (三) 字段说明
| 字段名 | 数据类型 | 说明 | 示例 |
| :--- | :--- | :--- | :--- |
| `user_id` | `BIGINT` | 匿名化处理的用户ID | `123456` |
| `item_id` | `BIGINT` | 匿名化处理的商品ID | `233845` |
| `category_id` | `BIGINT` | 匿名化处理的商品类目ID | `2520377` |
| `behavior_type` | `VARCHAR(10)` | 用户行为类型<br>- pv: 商品详情页浏览<br>- cart : 将商品加入购物车<br>- fav: 收藏商品<br>- buy: 购买商品 | `"pv"` |
| `timestamp` | `BIGINT` | 行为时间戳<br>(Unix时间戳，秒级) | `1512054127` |

---

## 三、项目目标

### (一). 构建业务问题

1. 总体运营情况如何，PV,UV和平均访问深度如何，日新增用户及占比如何，平台跳失率和复购率如何，有何存在需要改善或优化的地方；

2. 用户行为习惯如何，哪天用户最活跃、购买量最高，每天中用户哪个时段最活跃，各相对原因是什么，是否需要优化；

3. 用户商品偏好分析如何，哪种商品最受欢迎，用户的消费组成如何；

4. 各环节转化率如何，站内转化路径各环节是否存在可优化的地方；

5. 如何区分各用户群，哪些是核心用户，哪些是保持/发展/挽留客户，该怎么开展针对性营销活动。

### (二). 分析框架

<img src="../images/01 分析框架.png" alt="分析框架图" width="800" />

---

## 四、数据处理与分析
**工具**：MySQL 8.0，Navicat Premium Lite 17 ，Tableau 2024.3，Excel。

阿里天池的这个数据集解压出来3+G，数据条多达1亿条，Excel无法打开，直接通过Navicat导入MySQL速度极为缓慢，加上设备性能限制，故随机选取100W条数据导入Navicat。将数据进行预处理后，再编写SQL进行数据分析，并连接Tableau对检索结果进行可视化呈现。

### (一) 数据导入MySQL

#### 1. 在navicat中创建表格UserBehavior，并命名字段

<img src="../images/01 创建表结构.png" alt="创建表结果" width="800" />

#### 2. 开始导入数据

<img src="../images/02 导入向导1.png" alt="数据导入向导" width="800" />

#### 3. 导入100W条数据

<img src="../images/03 导入向导2.png" alt="导入100w条数据" width="800" />

#### 4. 打开导入数据后的表格

<img src="../images/08 查看表.png" alt="查看表" width="800" />

#### 5. 查询数据的总行数

```sql

# 查询`UserBehavior`表总行数
SELECT COUNT(User_ID) as total_rows FROM ub;

```
<img src="../images/09 查询表总行数.png" alt="查看表总行数" width="800" />

可见，数据的总行数是1000000，导入完成。

### (二) 数据预处理阶段

#### 1. 处理重复值

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

<img src="../images/10 检查重复值.png" alt="检查重复值" width="800" />

可见，不存在重复值。

#### 2. 检查并处理缺失值，排除NULL值

``` sql

SELECT COUNT(User_ID),
       COUNT(Item_ID),
       COUNT(Category_ID),
       COUNT(Behavior_type),
       COUNT(Timestamp)
FROM userbehavior;

```
<img src="../images/10 查询缺失值.png" alt="查找缺失值" width="800" />

可见，所有列的计数计算结果都是100W，故不存在缺失值。

#### 3. 时间处理，将时间戳转化为正常日期和时间

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

<img src="../images/10 查询修改时间后的表数据.png" alt="查看表" width="800" />

查看结果可见，转换已完成。

删除 `timestamp` 字段

``` sql 

#删除timestamp字段
ALTER TABLE ub drop timestamp;

```

<img src="../images/10 删除 timestamp后的表.png" alt="查看表" width="800" />

查看结果可见，已删除 `timestamp`字段。

#### 4. 查找是否存在异常时间

``` sql

#查找是否存在异常时间
SELECT date 
FROM UserBehavior 
WHERE date IS NOT NULL 
ORDER BY date;  -- 顺序

```

<img src="../images/11 查找异常时间-顺序.png" alt="按时间顺序排序的表" width="800" />


``` sql

SELECT date 
FROM UserBehavior 
WHERE date IS NOT NULL 
ORDER BY date DESC;  -- 逆序

```

<img src="../images/12 查找异常时间-逆序.png" alt="按时间逆序排序的表" width="800" />

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

<img src="../images/12 查询备份是否成功.png" alt="按时间逆序排序的表" width="800" />

``` sql

#删除时间异常值
DELETE FROM UserBehavior
 WHERE datetime < '2017-11-25';

DELETE FROM UserBehavior 
WHERE datetime > '2017-12-04';

```

<img src="../images/13 删除时间异常的行.png" alt="删除时间异常的值" width="800" />

删除异常值后，查询剩余的行数

<img src="../images/14 删除时间异常值后剩余行数.png" alt="删除异常时间值后的总行数" width="800" />

至此，数据预处理完成

### (三) 数据分析阶段

#### 1. 整体情况概览

##### 1.1 总访问量PV,总访客数UV和平均访问深度PV/UV

```

-- PV(Page View)：总访问量，指用户访问页面的总数
-- UV(Unique Visitor)：访客数量，一个用户ID为一个访客数
-- 平均访问深度：也称平均访问量，指用户每次浏览页面的平均值，PV/UV

```

``` sql 

-- 查询PV、UV、平均访问深度
SELECT
	COUNT(DISTINCT User_ID) AS 'UV',
	COUNT(User_ID) AS 'PV',
	COUNT(Behavior_type)/COUNT(DISTINCT User_ID) AS 'PV/UV'
FROM UserBehavior WHERE Behavior_type = 'pv';

```

<img src="../images/15 查询PV UV 平均访问深度.png" alt="查询PV UV 平均访问时间" width="800" />

可见，在九天统计周期内，在这抽取的约一百万条数据里，淘宝的总访问量达到将近90万，访客数多达9700人左右，平均访问深度约为92，即一个人大概访问了92个页面，可见淘宝流量优势之巨大。

##### 1.2 日增新用户数及日增新用户占比

```

在此定义用户最小时间的点击为该天的新用户之一，将日新增新用户除以总用户数就是日新用户占比。

```

``` sql

-- 创建视图1：创建每日活动汇总视图
CREATE OR REPLACE VIEW daily_activity_summary_view AS
SELECT
    DATE(Datetime) AS activity_date,
    COUNT(DISTINCT User_ID) AS daily_uv,
    COUNT(*) AS daily_pv
FROM UserBahavior
WHERE Behavior_type = 'pv'
GROUP BY DATE(Datetime);

```

<img src="../images/16 创建视图1 每日活动汇总.png" alt="每日活动汇总" width="800" />

``` sql

-- 创建视图2：创建用户首次浏览行为视图
CREATE OR REPLACE VIEW user_first_browse_view AS 
SELECT
    User_ID,
    MIN(Datetime) AS first_browse_time,
    DATE(MIN(Datetime)) AS first_browse_date
FROM UserBehavior
WHERE Behavior_type = 'pv' 
GROUP BY User_ID;

```

<img src="../images/17 创建视图2  用户首次浏览行为.png" alt="用户首次浏览行为" width="800" />

``` sql

-- 查询日增新用户数及占比
SELECT
    fbv.first_browse_date AS 统计日期,
    COUNT(fbv.User_ID) AS 日增新用户数,
    dasv.daily_uv AS 日均UV,
    dasv.daily_uv - COUNT(fbv.User_ID) AS 差额人数,
    ROUND(COUNT(fbv.User_ID) / dasv.daily_uv * 100, 2) AS 日新用户占比百分比
FROM user_first_browse_view fbv
JOIN daily_activity_summary_view dasv ON dasv.activity_date = fbv.first_browse_date
GROUP BY fbv.first_browse_date, dasv.daily_uv
ORDER BY fbv.first_browse_date;

```

<img src="../images/18 日增新用户数及其占比.png" alt="用户首次浏览行为" width="800" />


<img src="../images/19 日新增用户及其占比图.png" alt="用户首次浏览行为" width="800" />

由图可知，日增新用户占比在次日急剧下降，推测因为没有用户首次登录数据，将统计期的首日当作登录日显然是不准确的，但这也可以看出日增新用户占比是不断下降的，说明统计期内绝大部分用户都来自留存用户。

##### 1.3 跳失率

``` 

跳失率 = 只浏览了一个页面就离开的访问次数/该页面的全部访问次数

```

``` sql

-- 计算浏览次数、访问次数、跳失率

SELECT
	COUNT(a.behavior_num) AS '只浏览一次的访问总数',
	(SELECT count(Behavior_type) FROM UserBehavior WHERE Behavior_type = 'pv' ) AS '访问总数',
	concat(ROUND((COUNT(a.behavior_num)/(SELECT COUNT(Behavior_type) FROM UserBehavior WHERE Behavior_type = 'pv')) * 100,2),'%') AS '跳失率'
FROM
	(SELECT User_ID, COUNT(Behavior_type) AS behavior_num
	FROM UserBehavior WHERE Behavior_type = 'pv' GROUP BY User_ID HAVING COUNT(Behavior_type <= 1)) AS a;

```

<img src="../images/20 跳失率.png" alt="跳失率" width="800" />

##### 1.4 用户复购率

``` 

复购率 = 购买2次及以上 / 购买了1次的总人数

```

``` sql

CREATE OR REPLACE VIEW user_purchase_count_view AS
SELECT 
    User_ID,
    COUNT(*) AS '购物次数'
    -- 移除了其他非聚合列，如 Item_ID, Category_ID 等
FROM UserBehavior
WHERE Behavior_type = 'buy' 
GROUP BY User_ID;

```

<img src="../images/21 创建计算用户购物数的视图.png" alt="用户购买" width="800" />

``` sql

-- 计算复购率

SELECT SUM(CASE WHEN 购物次数 > 1 THEN 1 ELSE 0 END)/COUNT(User_ID) AS '复购率' 
FROM user_purchase_count_view;

```

<img src="../images/22 计算复购率.png" alt="复购率" width="800" />

由上结果可见，在这8天统计时间内，用户总体**复购率**达到了**66.21%**，而**跳失率**仅为**1.08%**，说明淘宝拥有足够的吸引力保留客户且客户忠诚度较高。可以进一步加大对客户忠诚度的培养，鼓励客户加大消费频率，比如推出如活动红包之类的措施。

#### 2. 用户行为习惯分析

##### 2.1 日均PV和日均UV

``` sql

-- 创建视图1：创建每日活动汇总视图
CREATE OR REPLACE VIEW daily_activity_summary_view AS
SELECT
    DATE(Datetime) AS activity_date,
    COUNT(DISTINCT User_ID) AS daily_uv,
    COUNT(*) AS daily_pv
FROM UserBehavior
WHERE Behavior_type = 'pv'
GROUP BY DATE(Datetime);

```

``` sql

-- 查询日UV、PV
SELECT activity_date AS date,
       daily_uv AS '日均UV',
       daily_pv AS '日均PV'
FROM daily_activity_summary_view;

```

<img src="../images/23 日均UV和日均PV.png" alt="日均UV和日均PV" width="800" />

<img src="../images/24 日均UV PV趋势图.png" alt="日均UV和日均PV趋势图" width="800" />

从上图可见，日均指标PV和UV的变动趋势几近一致，在2017年11月25日到2017年12月01日都处在预期、平稳的范围里波动，但在统计时间的最后2天，PV和UV都较大幅度上升，推测是得益于双十二预热宣传活动，吸引了不少老顾客。

##### 2.2 以小时为单位的访问数PV和访客数UV

``` sql

-- 查询小时均PV和UV

SELECT Hour,
COUNT(DISTINCT User_ID) AS '各小时访客数',
SUM(case when Behavior_type = 'pv' THEN 1 ELSE 0 END) AS '各小时访问量'
FROM UserBehavior
GROUP BY hour 
ORDER BY Hour;

```

<img src="../images/25 小时为单位的UV PV趋势图.png" alt="日均UV和日均PV" width="800" />

由上图可见，一天中最为活跃的时段在19时-22时，最顶峰出现再21时，此时PV为75030，UV为6709，当然这仅仅是在一亿条数据里抽样100W条的结果。中午时段和下午时段10时-18时总体流量稳定，处于较高水平。早上1时-6时流量微弱，符合国人作息时间。

由此可以洞察到，一天中的黄金宣传时间时在19时-22时左右，在此时段加大力度宣传，或者推出营销促销活动，或者开展直播宣传活动，都是不错的运营决策。

#### 3. 用户商品偏好分析

点击量、收藏量、加购量和购买量前10的商类目

##### 3.1 点击量前10的类目

``` sql

-- 查询点击量前10的商类目

SELECT 
    Category_ID,
    COUNT(*) as pv_category 
FROM UserBehavior 
WHERE Behavior_type='pv' 
GROUP BY category_ID 
ORDER BY pv_category DESC 
limit 10;

```

<img src="../images/26 浏览量top10商品品类.png" alt="浏览量top10商品品类" width="800" />

由上图可见，商品类目ID为4756105、4145813、2355072的商品点击量分别是47770、30659、30422，属于热搜商品。此些商品浏览量较高，推测是由于是日常高频使用产品吸引了用户，但不知后续销量如何，还待分析。

**流量高度集中于头部品类**​​：

排名第一的品类 ​​4756105​​ 的浏览量（47,770）远超第二名 ​​4145813​​（30,659），呈现出显著的“头部效应”。

**结论**：平台流量分布不均衡，少数几个头部品类吸引了绝大部分用户注意力。

**存在明显的“第二梯队”**：

品类 ​​4145813​​（30,659）、​​2355072​​（30,422）和 ​​3607361​​（29,297）的浏览量非常接近，共同构成了流量的第二梯队。

**结论**​​：这些品类同样极具竞争力，是平台流量的重要支柱，与头部品类差距不大，有冲击头部的潜力。

​**​长尾效应初步显现**​​：

从第5名 ​​4801426​​（18,616）开始，后续品类的浏览量出现明显断层，与前列差距较大。

​**​结论**​​：虽然Top 10都是热门品类，但流量主要集中在最前面的4-5个品类中。

##### 3.2 收藏量前10的类目

``` sql

-- 查询收藏量前10的商类目

SELECT 
    Category_ID,COUNT(*) as fav_category 
FROM UserBehavior
WHERE Behavior_type='fav' 
GROUP BY category_ID
ORDER BY fav_category DESC 
limit 10;

```

<img src="../images/27 收藏量top10商品品类.png" alt="收藏量top10商品品类" width="800" />

由上图可见，商品类目收藏量前3的分别为4756105、4145813、982926及对应收藏量分别是1594、1202、869，对比点击量，只有ID为982926商品类目不在点击量TOP3内。

**头部效应显著​**​：

类目 ​​982926​​ 以 12,850次收藏量位居第一，占Top 10总量的 ​​24.1%​​。

前3名类目（982926, 4145813, 4801426）占总收藏量 ​​53.7%​​，集中度超半数。

​**​梯队断层明显​**​：

第一梯队（>10,000）：982926（12,850）

第二梯队（5,000-10,000）：4145813（9,422）、4801426（8,637）

长尾梯队（<5,000）：其余7个类目均低于5,000，最小仅2,109

​**​品类竞争格局**​​：

第2名（4145813）与第3名（4801426）差距仅 ​​785​​（8.3%），存在激烈卡位。

第4名 ​​1320293​​（4,885）濒临第二梯队门槛（5,000）。


##### 3.3 加购量前10的商类目

``` sql

-- 查询加购量前10的商类目

SELECT 
    Category_ID,COUNT(*) as cart_category 
FROM UserBehavior
WHERE Behavior_type='cart' 
GROUP BY category_ID 
ORDER BY cart_category DESC 
limit 10;

```

<img src="../images/28 加购量top10商品品类.png" alt="加购量top10商品品类" width="800" />

由上图可见，商品类目加购量前3的分别为4756105、4145813、982926及对应加购量分别是2236、1642、1625，收藏量TOP3和加购量TOP3的商品类目一致，不过对应加购量大于收藏量。这从侧面说明了站内转化路径不一定是“点击-收藏-加购-购买”。

**头部集中效应​​**：

前3类目加购量 ​​35,289​​，占总量 ​​63.4%​​

第1名加购量 > 第8-10名总和（​​15,820​​ vs ​​5,886​​）

​**​梯队分布特征​​**：

第一梯队（>10,000）：4756105, 4145813

第二梯队（5,000-10,000）：1320293, 4801426

长尾梯队（<5,000）：其余6个类目

**​​断层现象​​**：

第1名与第2名差距 ​​4,518​​（差值率28.6%），

第4名与第5名差距 ​​1,587​​（差值率26.9%）。

##### 3.4 购买量前10的商类目

``` sql

-- 查询购买量前10的商类目

SELECT 
    Category_ID,COUNT(*) as buy_category 
FROM UserBehavior
WHERE Behavior_type='buy' 
GROUP BY category_ID 
ORDER BY buy_category DESC 
limit 10;

```

<img src="../images/29 购买量top10商品品类.png" alt="购买量top10商品品类" width="800" />

由上图可见，商品类目购买量前3的分别为2735466、1464116、4145813及对应购买量分别是363、352、326，只有ID为4145813的商品类目保持在这4图的TOP3之列，说明在点击、收藏、加购环节并未很好地转化为实际销量。

**绝对头部效应​​**：

类目 ​​4756105​​ 购买量占比 ​​31.2%​​，超过第2-5名总和（8,420 vs 8,005）

Top 3类目贡献 ​​62.5%​​ 交易量（4756105+4145813+1320293=16,889）

​**​梯队断层特征​​**：

超头部层：4756105（>8,000）

核心层：4145813/1320293（3,000-6,000）

长尾层：其余7类目（均<2,500）

​**​尾部竞争格局​​**：

第7-10名购买量差值仅 ​​352​​（1,284-932）

类目 ​​3765674​​（1,145）与 ​​2735466​​（1,009）差距 ​​136​​（13.5%）

<img src="../images/30 top 商品品类.png" alt="top商品品类" width="800" />

由上图可见，点击、收藏、加购与购买量均在TOP10的商品有4756105、4145813、982926、4801426和1320293这5种商品类目，说明站内转化路径拥有较强的联系，且此5种商品可优先推广，但各环节间的转化率还待后续分析。


##### 3.5 商品购买数量 (按购买次数分组)

``` sql

-- 查询每个用户的购买次数及对应商品数量
SELECT 
    purchase_count,
    COUNT(User_ID) AS user_count,
    SUM(purchase_count) AS total_items_purchased
FROM (
    SELECT 
        User_ID,
        COUNT(*) AS purchase_count
    FROM UserBehavior
    WHERE Behavior_type = 'buy'
    GROUP BY User_ID
) user_purchases
GROUP BY purchase_count

```

<img src="../images/31 商品购买次数.png" alt="商品购买次数" width="800" />

由上图可见，购买次数在1、2、3、4的购买行为占据绝对的地位，占比多达80%，可见商品售卖并非单纯只依靠爆款商品的带动，很大部分依赖商品销量的长尾效应，头尾整合兼顾，这比较符合淘宝电商的销售模式。

```

长尾效应强调的是那些数量占绝大多数的个体的商业价值，它们单个的值虽然极低，但是这个长长的尾巴，总和不可小觑。
而长尾之所以常常与互联网、电子商公司放在一起，主要是因为互联网与IT技术的发展使产品与服务的信息到达用户的平均成本降到了极低的值。

```

#### 4. 用户行为转化路径分析

因为用户收藏和加购行为并无严格的先后顺序，故可以由以下4条路径分析用户行为转化：

```

用户站内路径1：点击-加购-购买
用户站内路径2：点击-收藏-购买
用户站内路径3：点击-收藏+加购-购买
用户站内路径4：点击-购买

```

``` sql

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

-- 创建视图6：用户路径分析视图-路径3：点击-收藏+加购-购买
CREATE OR REPLACE VIEW funnel_click_engagement_purchase_view AS
SELECT 
    total_pv AS click_count,
    total_fav + total_cart AS engagement_count,
    total_buy AS purchase_count,
    ROUND((total_fav + total_cart) / total_pv * 100, 2) AS click_to_engagement_rate,
    ROUND(total_buy / (total_fav + total_cart) * 100, 2) AS engagement_to_purchase_rate
FROM user_behavior_totals_view;

-- 创建视图6：用户路径分析视图-路径4：点击-购买（直接购买）
CREATE OR REPLACE VIEW funnel_click_direct_purchase_view AS
SELECT 
    total_pv AS click_count,
    total_buy AS purchase_count,
    ROUND(total_buy / total_pv * 100, 2) AS click_to_purchase_rate
FROM user_behavior_totals_view;

```
##### 4.1 用户行为转化路径1：点击-加购-购买

``` sql
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

``` 

<img src="../images/32 用户行为转化路径1：点击-加购-购买.png" alt="点击-加购-购买" width="800" />

##### 4.2 用户行为转化路径2：点击-收藏-购买

``` sql 

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

```

<img src="../images/33 用户行为转化路径2：点击-收藏-购买.png" alt="点击-收藏-购买" width="800" />


##### 4.3 用户行为转化路径3：点击-收藏+加购-购买

```  sql

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

```

<img src="../images/34 用户行为转化路径3：点击-收藏+加购-购买.png" alt="点击-收藏+加购-购买" width="800" />

##### 4.4 用户行为转化路径4：点击-直接购买

``` sql

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

```
<img src="../images/35 用户行为转化路径4：点击-购买.png" alt="点击--购买" width="800" />

由以上4图来看，大量用户在访问-收藏/加购环节流失，即使把加购和收藏行为归结为一个环节，依旧只有9.3%的用户在点击页面后留存。点击-收藏&加购环节作为流失最为严重的一环，需要找到相关原因进而找到问题所在，改善转化率。

#### 5. 用户价值分析

通过 RFM 模型进行用户价值分析

``` 

R：(Recency) 最近一次消费时间间隔，定义为在此统计周期内，即用户最近一次消费距离2017/12/03有多少天
F：(Frequency) 消费次数，定义为在此统计周期内用户购买次数

R值越小，最近一次消费时间间隔越近，用户价值越大
F值越大，购买频率越高，用户价值越高

```
##### 5.1 原始R、F值
``` sql

-- 创建视图7：计算每个用户的RFM模型中的R（最近一次消费时间间隔）和F（消费次数）指标​​
CREATE OR REPLACE VIEW user_rf_analysis_view AS
SELECT
    User_ID,
    DATEDIFF('2017-12-03', MAX(datetime)) AS R,
    COUNT(*) AS F
FROM UserBehavior
WHERE Behavior_type = 'buy'
GROUP BY User_ID
ORDER BY R, F DESC;

```

``` sql

-- 查询R和F

SELECT *
FROM user_rf_analysis_view;

```


<img src="../images/36 每个用户的R和F.png" alt="R和F" width="800" />

##### 5.2 R、F的均值

``` sql

-- 求出R和F的均值

SELECT 
    AVG(R) AS AVG_R,
    AVG( F) AS AVG_F 
FROM user_rf_analysis_view;

```
<img src="../images/37 R和F的均值.png" alt="R和F的均值" width="800" />

由上图可知：
R 值平均值为 2.5241，R<2.5241 判定为R高，反之R低；
F 值平均值为 3.0437，F>3.0437 判定为F高，反之F低。

##### 5.3 二八法则下的R值/F值，以及R值/F值的中位数

###### 不同R/F值对应人数及其占比

``` sql

-- 查询不同R值对应人数及其占比

SELECT
    R,
    COUNT(*) AS R值对应人数,
    COUNT(*) / (SELECT COUNT(*) FROM user_rf_analysis_view) AS 占比,
    SUM(COUNT(*)) OVER (ORDER BY R) / (SELECT COUNT(*) FROM user_rf_analysis_view) AS 累计占比
FROM user_rf_analysis_view
GROUP BY R
ORDER BY R;

```

<img src="../images/38 不同R值对应的人数及其占比.png" alt="不同R值对应的人数及其占比" width="800" />

创建最近消费间隔 R 值的帕累托图：

<img src="../images/40 不同R值对应的人数及其占比图.png" alt="不同R值对应的人数及其占比图" width="800" />

由二八法则得，20% 的用户贡献 80% 的价值，R值 = 0 的用户人数占比超过20%，取R值取0，所有消费间隔大于0的判定R低，反之R高。

而根据中位数，R值中位数=2，故当R值<2，判定R高，反之R低。

``` sql

-- 查询不同F值对应人数及其占比 

SELECT
    F,
    COUNT(*) AS F值对应人数,
    COUNT(*) / (SELECT COUNT(*) FROM user_rf_analysis_view) AS 占比,
    SUM(COUNT(*)) OVER (ORDER BY F) / (SELECT COUNT(*) FROM user_rf_analysis_view) AS 累计占比
FROM user_rf_analysis_view
GROUP BY F
ORDER BY F;

```

<img src="../images/39 不同F值对应的人数及其占比.png" alt="不同F值对应的人数及其占比" width="800" />

创建消费频率 F 值的帕累托图：

<img src="../images/41 不同F值对应的人数及其占比图.png" alt="不同F值对应的人数及其占比图" width="800" />

根据二八法则得，F值定位在4，消费频率大于4的用户占比接近20%，故当F值>4，判定F高，反之F低。

而根据中位数，F值中位数=2，故当F值>2，判定F高，反之F低。

##### 5.4 确定R、F的临界值

综上考虑，最终确定两个临界值分别是：R = 2 (中位数),F = 3.0437 (平均值)。

故确定，当 R < 2 ，R高，反之R低；当 F > 3.0437，F高，反之F低。

##### 5.5 判定用户的R值和F值高低

``` sql

-- 创建用户消费行为高低状态视图

CREATE OR REPLACE VIEW user_consumption_level_view AS
SELECT 
    User_ID,
    R,
    F,
    (CASE WHEN R < 2 THEN '高' ELSE '低' END) AS '消费时间间隔',
    (CASE WHEN F > 3.0437 THEN '高' ELSE '低' END) AS '消费频率'
FROM user_rf_analysis_view;

```


``` sql

-- 查询用户消费行为高低状态
SELECT *
FROM user_consumption_level_view;

```

<img src="../images/42 用户消费行为高低状态.png" alt="用户消费行为高低" width="800" />

##### 5.6 构建RFM模型

用户价值判定方法：

| 用户价值判定方法 | R高 | R低 |
|----------------|-----|-----|
| **F高**        | 价值用户 | 保持用户 |
| **F低**        | 发展用户 | 挽留用户 |

``` sql

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

```

<img src="../images/43 用户分层：RFM模型.png" alt="用户分层RFM模型" width="800" />

根据用户价值判定结果，计算各用户群人数及所占比例：

``` sql

-- 计算各用户群人数及所占比例

SELECT 
    SUM(case WHEN 消费时间间隔='高' and 消费频率='高' then '1' END) as '价值用户数量',
    SUM(case WHEN 消费时间间隔='高' and 消费频率='低' then '1' END) as '发展用户数量',
    SUM(case WHEN 消费时间间隔='低' and 消费频率='高' then '1' END) as '保持用户数量',
    SUM(case WHEN 消费时间间隔='低' and 消费频率='低' then '1' END) as '挽留用户数量'
FROM user_consumption_level_view;

```

