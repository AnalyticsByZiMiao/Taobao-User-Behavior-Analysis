# sql文件夹下的文件结构

sql/
├── 00_database_setup.sql      -- 数据库和表创建
├── 01_data_cleaning.sql       -- 数据清洗和预处理
├── 02_overview_analysis.sql   -- 整体情况概览
├── 03_behavior_analysis.sql   -- 用户行为习惯分析
├── 04_product_preference.sql  -- 用户商品偏好分析
├── 05_conversion_analysis.sql -- 用户行为转化分析
├── 06_rfm_analysis.sql       -- 用户价值分析(RFM模型)
└── 07_views_setup.sql         -- 所有视图创建

sql/
├── 0_data_preparation/    # 数据准备层 (可选)
│   └── table_creation.sql # 建表、数据导入脚本
├── 1_core_metrics/        # 核心指标层
│   ├── total_pv_uv.sql    # 总PV/UV、访问深度
│   ├── daily_new_users.sql # 日增新用户及占比
│   ├── bounce_rate.sql    # 跳失率
│   └── repurchase_rate.sql # 复购率
├── 2_behavior_analysis/   # 用户行为分析层
│   ├── daily_trend.sql    # 日均PV/UV趋势
│   └── hourly_trend.sql   # 分时PV/UV趋势
├── 3_product_analysis/    # 商品偏好分析层
│   ├── top_categories_click.sql
│   ├── top_categories_fav.sql
│   ├── top_categories_cart.sql
│   ├── top_categories_buy.sql
│   └── purchase_frequency.sql
├── 4_conversion_analysis/ # 转化路径分析层
│   └── conversion_funnel.sql # 转化漏斗（4条路径）
├── 5_customer_value_analysis/ # 用户价值分析层
│   ├── rfm_calculation.sql   # 计算R、F原始值
│   ├── rfm_threshold.sql     # 计算R、F阈值（均值/中位数）
│   └── rfm_segmentation.sql  # 用户分群与统计
├── utils/                   # 公共工具层（至关重要！）
│   ├── view_ub_1.sql        # 创建视图：每日UV/PV
│   ├── view_ub_2.sql        # 创建视图：用户首次访问
│   ├── view_ub_3.sql        # 创建视图：行为汇总
│   └── ...                  # 其他视图
└── README.md               # 项目说明文档

Taobao-User-Behavior-Analysis/ # 项目根目录
├── data/ # 存放数据文件
│   ├── raw/ # 原始数据（.gitignore 忽略，避免上传大文件）
│   └── processed/ # 清洗后的数据（可存放小样本或元数据）
├── sql/ # SQL 查询与分析脚本
│   ├── 01_data_cleaning.sql # 数据清洗
│   ├── 02_behavior_funnel_analysis.sql # 用户行为漏斗分析
│   ├── 03_time_series_analysis.sql # 用户行为时间模式分析
│   ├── 04_user_retention_analysis.sql # 用户留存分析
│   └── 05_rfm_user_segmentation.sql # 用户价值分层（RFM模型）
├── tableau/ # Tableau 工作簿与资源
│   ├── Taobao_User_Behavior_Analysis.twbx # Tableau 打包工作簿
│   └── exports/ # 导出的可视化图片或 PDF 报告
├── docs/ # 项目文档
│   ├── README.md # 项目说明（最重要的文档！）
│   ├── dataset_description.md # 数据集字段详细说明
│   └── analysis_framework.md # 分析框架与思路
├── images/ # 存放 README 中使用的图片、图表
└── .gitignore # 指定忽略上传的文件（如大容量原始数据）