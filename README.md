# Taobao-User-Behavior-Analysis
A data analysis project on Taobao user behavior using SQL and Tableau.

## 🚀 快速开始

如何设置环境并复现本分析：

1.  **环境准备**：确保安装有 MySQL (8.0+)、Tableau（可选，用于可视化）、Navicat（或其它 MySQL 客户端）。

2.  **获取数据**：从 [阿里天池](https://tianchi.aliyun.com/dataset/dataDetail?dataId=649) 下载 `UserBehavior.csv` 数据集。

3.  **导入数据**：
    - 在 MySQL 中创建名为 `taobao_user_behavior` 的数据库。
    - 使用提供的 `sql/01_data_cleaning.sql` 脚本中的 `CREATE TABLE` 语句建表。
    - **推荐使用命令行导入**（适用于大文件）：
    ```bash
    mysql -u root -p --local-infile=1 taobao_user_behavior -e "LOAD DATA LOCAL INFILE '/你的路径/UserBehavior.csv' INTO TABLE user_behavior FIELDS TERMINATED BY ',' ENCLOSED BY '"' LINES TERMINATED BY '\n';"
    ```

4.  **执行分析**：按顺序运行 `sql/` 目录下的 SQL 脚本。

5.  **可视化**：打开 `tableau/` 目录下的 Tableau 工作簿，连接至数据库或导出的 CSV 结果文件即可查看仪表板。
