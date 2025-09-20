# sql文件夹下的文件结构

## 📂 项目文件结构

```
Taobao-User-Behavior-Analysis/
├── data/                          # 数据目录
│   ├── raw/                       # 原始数据（通过.gitignore忽略）
│   └── processed/                 # 清洗后的数据
├── sql/                           # SQL查询与分析脚本
│   ├── 01_data_cleaning.sql      # 数据清洗
│   ├── 02_behavior_funnel_analysis.sql # 用户行为漏斗分析
│   ├── 03_time_series_analysis.sql     # 用户行为时间模式分析
│   ├── 04_user_retention_analysis.sql  # 用户留存分析
│   └── 05_rfm_user_segmentation.sql    # 用户价值分层（RFM模型）
├── tableau/                       # Tableau工作簿与资源
│   ├── Taobao_User_Behavior_Analysis.twbx
│   └── exports/                   # 导出的可视化报告
├── docs/                          # 项目文档
│   ├── README.md                  # 项目说明
│   ├── dataset_description.md     # 数据集说明
│   └── analysis_framework.md      # 分析框架
├── images/                        # README用到的图片、图表
└── .gitignore                     # 忽略文件配置
```

## 🗃️ SQL 目录结构 1

```
sql/
├── 0_data_preparation/           # 数据准备层
│   └── table_creation.sql        # 建表、数据导入脚本
├── 1_core_metrics/               # 核心指标层
│   ├── total_pv_uv.sql          # 总PV/UV、访问深度
│   ├── daily_new_users.sql       # 日增新用户及占比
│   ├── bounce_rate.sql           # 跳失率
│   └── repurchase_rate.sql       # 复购率
├── 2_behavior_analysis/          # 用户行为分析层
│   ├── daily_trend.sql           # 日均PV/UV趋势
│   └── hourly_trend.sql          # 分时PV/UV趋势
├── 3_product_analysis/           # 商品偏好分析层
│   ├── top_categories_click.sql
│   ├── top_categories_fav.sql
│   ├── top_categories_cart.sql
│   ├── top_categories_buy.sql
│   └── purchase_frequency.sql
├── 4_conversion_analysis/       # 转化路径分析层
│   └── conversion_funnel.sql    # 转化漏斗（4条路径）
├── 5_customer_value_analysis/   # 用户价值分析层
│   ├── rfm_calculation.sql      # 计算R、F原始值
│   ├── rfm_threshold.sql        # 计算R、F阈值
│   └── rfm_segmentation.sql     # 用户分群与统计
└── utils/                       # 公共工具层
    ├── view_ub_1.sql            # 视图：每日UV/PV
    ├── view_ub_2.sql            # 视图：用户首次访问
    ├── view_ub_3.sql            # 视图：行为汇总
    └── ...                      # 其他视图
```

## 🗃️ SQL 目录结构 2

```
sql/
├── 00_database_setup.sql      -- 数据库和表创建
├── 01_data_cleaning.sql       -- 数据清洗和预处理
├── 02_overview_analysis.sql   -- 整体情况概览
├── 03_behavior_analysis.sql   -- 用户行为习惯分析
├── 04_product_preference.sql  -- 用户商品偏好分析
├── 05_conversion_analysis.sql -- 用户行为转化分析
├── 06_rfm_analysis.sql       -- 用户价值分析(RFM模型)
└── 07_views_setup.sql         -- 所有视图创建
```