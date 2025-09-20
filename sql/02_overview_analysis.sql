# 整体情况概览

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