# 水温水位在线监测系统

## 项目简介

这是一个基于 Flutter 开发的水温水位在线监测系统移动应用。该系统允许用户管理设备、查看实时和历史数据、生成报表以及处理报警信息。

## 项目结构

```
lib/
├── main.dart
└── pages/
    ├── login_page.dart
    ├── register_page.dart
    ├── dashboard_page.dart
    ├── device_management_page.dart
    ├── data_management_page.dart
    ├── data_update_page.dart
    ├── alarm_management_page.dart
    └── report_generation_page.dart
```

## 文件说明

### main.dart

这是应用的入口文件，负责初始化应用并设置主题。

主要功能：

- 设置应用标题
- 配置应用主题
- 设置初始路由为登录页面


### pages/login_page.dart

登录页面，允许用户输入用户名和密码进行身份验证。

主要功能：

- 用户登录表单
- 登录验证逻辑
- 导航到注册页面


### pages/register_page.dart

注册页面，允许新用户创建账户。

主要功能：

- 用户注册表单
- 注册验证逻辑

### pages/dashboard_page.dart

仪表盘页面，显示系统概览和快速操作。

主要功能：

- 显示设备统计信息
- 实时数据图表
- 快速操作按钮


### pages/device_management_page.dart

设备管理页面，允许用户添加、编辑和删除设备。

主要功能：

- 设备列表显示
- 添加新设备
- 编辑设备信息
- 删除设备
- 设置设备阈值


### pages/data_management_page.dart

数据管理页面，用于查看和分析设备数据。

主要功能：

- 实时数据显示
- 历史数据查询
- 数据可视化


### pages/data_update_page.dart

数据更新页面，允许用户手动更新设备数据。

主要功能：

- 手动数据输入表单
- 数据更新日志


### pages/alarm_management_page.dart

报警管理页面，用于查看和处理设备报警信息。

主要功能：

- 报警列表显示
- 报警详情查看
- 报警处理

### pages/report_generation_page.dart

报表生成页面，允许用户生成自定义报表。

主要功能：

- 报表参数设置
- 报表生成
- 报表导出

## API文档

### 基础URL

所有API的基础URL为: `http://47.116.66.208:8080/api`

### 用户管理API

#### 1. 用户注册

- **URL**: `/users/register`

- **方法**: POST

- **描述**: 注册新用户

- **请求体**:

  ```json
  {
    "username": "string",
    "password": "string"
  }
  ```

- **成功响应**: 

  - 状态码: 200

  - 响应体:

    ```json
    {
      "id": "integer",
      "username": "string"
    }
    ```

- **错误响应**:

  - 状态码: 400

  - 响应体: 

    ```json
    {
      "error": "string"
    }
    ```

**测试用例**:

1. 正常注册:

   ```
   POST /api/users/register
   Content-Type: application/json
   
   {
     "username": "testuser",
     "password": "testpassword"
   }
   ```

   预期结果: 状态码200,返回用户ID和用户名

2. 重复用户名:

   ```
   POST /api/users/register
   Content-Type: application/json
   
   {
     "username": "existinguser",
     "password": "testpassword"
   }
   ```

   预期结果: 状态码400,返回错误信息

#### 2. 用户登录

- **URL**: `/users/login`

- **方法**: POST

- **描述**: 用户登录

- **请求体**:

  ```json
  {
    "username": "string",
    "password": "string"
  }
  ```

- **成功响应**: 

  - 状态码: 200

  - 响应体:

    ```json
    {
      "token": "string"
    }
    ```

- **错误响应**:

  - 状态码: 401

  - 响应体: 

    ```json
    {
      "error": "string"
    }
    ```

**测试用例**:

1. 正常登录:

   ```
   POST /api/users/login
   Content-Type: application/json
   
   {
     "username": "testuser",
     "password": "testpassword"
   }
   ```

   预期结果: 状态码200,返回token

2. 错误密码:

   ```
   POST /api/users/login
   Content-Type: application/json
   
   {
     "username": "testuser",
     "password": "wrongpassword"
   }
   ```

   预期结果: 状态码401,返回错误信息

### 设备管理API

#### 1. 获取所有设备

- **URL**: `/devices`

- **方法**: GET

- **描述**: 获取所有设备列表

- **查询参数**:

  - `page`: 页码 (默认: 0)
  - `size`: 每页数量 (默认: 10)

- **成功响应**: 

  - 状态码: 200

  - 响应体:

    ```json
    {
      "content": [
        {
          "id": "integer",
          "name": "string",
          "macAddress": "string",
          "communicationChannel": "string",
          "threshold": "number",
          "isOn": "boolean"
        }
      ],
      "totalPages": "integer",
      "totalElements": "integer",
      "last": "boolean",
      "size": "integer",
      "number": "integer",
      "sort": {
        "empty": "boolean",
        "sorted": "boolean",
        "unsorted": "boolean"
      },
      "numberOfElements": "integer",
      "first": "boolean",
      "empty": "boolean"
    }
    ```

**测试用例**:

1. 获取第一页设备:

   ```
   GET /api/devices?page=0&size=10
   ```

   预期结果: 状态码200,返回设备列表和分页信息

2. 获取第二页设备:

   ```
   GET /api/devices?page=1&size=10
   ```

   预期结果: 状态码200,返回设备列表和分页信息

#### 2. 添加新设备

- **URL**: `/devices`

- **方法**: POST

- **描述**: 添加新设备

- **请求体**:

  ```json
  {
    "name": "string",
    "macAddress": "string",
    "communicationChannel": "string"
  }
  ```

- **成功响应**: 

  - 状态码: 200

  - 响应体:

    ```json
    {
      "id": "integer",
      "name": "string",
      "macAddress": "string",
      "communicationChannel": "string",
      "threshold": "number",
      "isOn": "boolean"
    }
    ```

- **错误响应**:

  - 状态码: 400

  - 响应体: 

    ```json
    {
      "error": "string"
    }
    ```

**测试用例**:

1. 添加新设备:

   ```
   POST /api/devices
   Content-Type: application/json
   
   {
     "name": "TestDevice",
     "macAddress": "00:11:22:33:44:55",
     "communicationChannel": "WiFi"
   }
   ```

   预期结果: 状态码200,返回新添加的设备信息

2. 添加重复MAC地址的设备:

   ```
   POST /api/devices
   Content-Type: application/json
   
   {
     "name": "DuplicateDevice",
     "macAddress": "00:11:22:33:44:55",
     "communicationChannel": "Bluetooth"
   }
   ```

   预期结果: 状态码400,返回错误信息

#### 3. 删除设备

- **URL**: `/devices/{id}`

- **方法**: DELETE

- **描述**: 删除指定ID的设备

- **路径参数**:

  - `id`: 设备ID

- **成功响应**: 

  - 状态码: 200

- **错误响应**:

  - 状态码: 404

  - 响应体: 

    ```json
    {
      "error": "string"
    }
    ```

**测试用例**:

1. 删除存在的设备:

   ```
   DELETE /api/devices/1
   ```

   预期结果: 状态码200

2. 删除不存在的设备:

   ```
   DELETE /api/devices/999
   ```

   预期结果: 状态码404,返回错误信息

#### 4. 设置设备阈值

- **URL**: `/devices/{id}/threshold`

- **方法**: PUT

- **描述**: 设置指定ID设备的阈值

- **路径参数**:

  - `id`: 设备ID

- **查询参数**:

  - `threshold`: 新的阈值

- **成功响应**: 

  - 状态码: 200

  - 响应体:

    ```json
    {
      "id": "integer",
      "name": "string",
      "macAddress": "string",
      "communicationChannel": "string",
      "threshold": "number",
      "isOn": "boolean"
    }
    ```

- **错误响应**:

  - 状态码: 404

  - 响应体: 

    ```json
    {
      "error": "string"
    }
    ```

**测试用例**:

1. 设置存在设备的阈值:

   ```
   PUT /api/devices/1/threshold?threshold=50.5
   ```

   预期结果: 状态码200,返回更新后的设备信息

2. 设置不存在设备的阈值:

   ```
   PUT /api/devices/999/threshold?threshold=30.0
   ```

   预期结果: 状态码404,返回错误信息

#### 5. 切换设备状态

- **URL**: `/devices/{id}/toggle`

- **方法**: PUT

- **描述**: 切换指定ID设备的开关状态

- **路径参数**:

  - `id`: 设备ID

- **成功响应**: 

  - 状态码: 200

  - 响应体:

    ```json
    {
      "id": "integer",
      "name": "string",
      "macAddress": "string",
      "communicationChannel": "string",
      "threshold": "number",
      "isOn": "boolean"
    }
    ```

- **错误响应**:

  - 状态码: 404

  - 响应体: 

    ```json
    {
      "error": "string"
    }
    ```

**测试用例**:

1. 切换存在设备的状态:

   ```
   PUT /api/devices/1/toggle
   ```

   预期结果: 状态码200,返回更新后的设备信息

2. 切换不存在设备的状态:

   ```
   PUT /api/devices/999/toggle
   ```

   预期结果: 状态码404,返回错误信息

### 数据管理API

#### 1. 获取设备数据

- **URL**: `/devices/{id}/data`

- **方法**: GET

- **描述**: 获取指定ID设备的数据

- **路径参数**:

  - `id`: 设备ID

- **查询参数**:

  - `page`: 页码 (默认: 0)
  - `size`: 每页数量 (默认: 10)
  - `startTime`: 开始时间 (格式: yyyy-MM-dd HH:mm:ss)
  - `endTime`: 结束时间 (格式: yyyy-MM-dd HH:mm:ss)

- **成功响应**: 

  - 状态码: 200

  - 响应体:

    ```json
    {
      "content": [
        {
          "id": "integer",
          "value": "number",
          "recordTime": "long"
        }
      ],
      "totalPages": "integer",
      "totalElements": "integer",
      "last": "boolean",
      "size": "integer",
      "number": "integer",
      "sort": {
        "empty": "boolean",
        "sorted": "boolean",
        "unsorted": "boolean"
      },
      "numberOfElements": "integer",
      "first": "boolean",
      "empty": "boolean"
    }
    ```

- **错误响应**:

  - 状态码: 404

  - 响应体: 

    ```json
    {
      "error": "string"
    }
    ```

**测试用例**:

1. 获取设备数据:

   ```
   GET /api/devices/1/data?page=0&size=10&startTime=2023-05-01 00:00:00&endTime=2023-05-31 23:59:59
   ```

   预期结果: 状态码200,返回设备数据列表和分页信息

2. 获取不存在设备的数据:

   ```
   GET /api/devices/999/data?page=0&size=10&startTime=2023-05-01 00:00:00&endTime=2023-05-31 23:59:59
   ```

   预期结果: 状态码404,返回错误信息

#### 2. 获取超过阈值的数据

- **URL**: `/devices/{id}/data/above-threshold`

- **方法**: GET

- **描述**: 获取指定ID设备超过阈值的数据

- **路径参数**:

  - `id`: 设备ID

- **查询参数**:

  - `page`: 页码 (默认: 0)
  - `size`: 每页数量 (默认: 10)

- **成功响应**: 

  - 状态码: 200

  - 响应体:

    ```json
    {
      "content": [
        {
          "id": "integer",
          "value": "number",
          "recordTime": "long",
          "device": {
            "id": "integer",
            "name": "string",
            "macAddress": "string",
            "communicationChannel": "string",
            "threshold": "number",
            "isOn": "boolean"
          }
        }
      ],
      "totalPages": "integer",
      "totalElements": "integer",
      "last": "boolean",
      "size": "integer",
      "number": "integer",
      "sort": {
        "empty": "boolean",
        "sorted": "boolean",
        "unsorted": "boolean"
      },
      "numberOfElements": "integer",
      "first": "boolean",
      "empty": "boolean"
    }
    ```

- **错误响应**:

  - 状态码: 404

  - 响应体: 

    ```json
    {
      "error": "string"
    }
    ```

**测试用例**:

1. 获取设备超过阈值的数据:

   ```
   GET /api/devices/1/data/above-threshold?page=0&size=10
   ```

   预期结果: 状态码200,返回超过阈值的数据列表和分页信息

2. 获取不存在设备的超过阈值数据:

   ```
   GET /api/devices/999/data/above-threshold?page=0&size=10
   ```

   预期结果: 状态码404,返回错误信息

## 如何运行项目

1. 确保已安装 Flutter 开发环境。
2. 克隆项目到本地。
3. 在项目根目录运行 `flutter pub get` 安装依赖。
4. 连接模拟器或真机设备。
5. 运行 `flutter run` 启动应用。

## 学习建议

1. 从 `main.dart` 开始，了解应用的整体结构和主题设置。
2. 研究 `login_page.dart` 和 `register_page.dart`，学习用户认证的实现方式。
3. 深入研究 `dashboard_page.dart`，了解如何构建复杂的 UI 布局和数据展示。
4. 学习 `device_management_page.dart` 中的 CRUD 操作实现。
5. 研究 `data_management_page.dart` 中的数据查询和可视化技术。
6. 了解 `data_update_page.dart` 中的表单处理和数据更新逻辑。
7. 学习 `alarm_management_page.dart` 中的列表展示和状态管理。
8. 研究 `report_generation_page.dart` 中的自定义报表生成逻辑。

通过逐步学习这些文件，你将能够全面了解这个水温水位在线监测系统的实现，并掌握 Flutter 应用开发的各种技巧和最佳实践。