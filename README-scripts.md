# WeRead Challenge 执行脚本说明

本项目提供了多个便捷的执行脚本，帮助您在Windows环境下轻松运行WeRead Challenge。

## 脚本列表

### 1. run-local.bat - 主要执行脚本
**用途**: 在本地Windows环境下运行WeRead Challenge
**功能**:
- 自动检查Node.js和npm环境
- 自动安装依赖（如果需要）
- 设置所有必要的环境变量
- 运行主程序

**使用方法**:
```bash
双击运行 run-local.bat
```

**配置参数**:
- 阅读时长: 10分钟
- 邮件通知: 已启用
- SMTP服务器: smtp.whut.edu.cn
- 邮箱: 322422@whut.edu.cn

### 2. install-deps.bat - 依赖安装脚本
**用途**: 单独安装项目依赖
**功能**:
- 检查Node.js和npm环境
- 安装或重新安装项目依赖
- 提供详细的安装信息

**使用方法**:
```bash
双击运行 install-deps.bat
```

### 3. clean-data.bat - 数据清理脚本
**用途**: 清理程序运行产生的数据
**功能**:
- 删除登录状态文件 (cookies.json)
- 删除截图文件 (*.png)
- 删除日志文件 (output.log)
- 删除二维码文件 (login.png)

**使用方法**:
```bash
双击运行 clean-data.bat
```

## 使用步骤

### 首次使用
1. 确保已安装Node.js (https://nodejs.org/)
2. 确保已安装Chrome浏览器
3. 双击运行 `install-deps.bat` 安装依赖
4. 双击运行 `run-local.bat` 启动程序
5. 使用微信扫码登录

### 日常使用
1. 双击运行 `run-local.bat`
2. 程序会自动使用保存的登录状态

### 重新登录
1. 双击运行 `clean-data.bat` 清理登录状态
2. 双击运行 `run-local.bat` 重新登录

## 环境要求

### 必需软件
- **Node.js**: 建议安装LTS版本 (https://nodejs.org/)
- **Chrome浏览器**: 用于Selenium自动化
- **Windows 10/11**: 支持UTF-8编码

### 网络要求
- 能够访问微信读书网站
- 能够连接SMTP邮件服务器 (smtp.whut.edu.cn:587)

## 故障排除

### 常见问题

**1. "Node.js 未安装"错误**
- 解决方案: 访问 https://nodejs.org/ 下载并安装Node.js LTS版本

**2. "依赖安装失败"错误**
- 解决方案1: 检查网络连接
- 解决方案2: 使用国内镜像源
  ```bash
  npm config set registry https://registry.npmmirror.com/
  ```
- 解决方案3: 以管理员身份运行脚本

**3. "Chrome浏览器未找到"错误**
- 解决方案: 安装Chrome浏览器或确保Chrome在系统PATH中

**4. 邮件发送失败**
- 检查邮箱配置是否正确
- 检查网络是否能访问SMTP服务器
- 确认邮箱密码是否正确

### 日志查看
程序运行日志保存在 `data/output.log` 文件中，可以通过以下方式查看：
```bash
type data\output.log
```

## 注意事项

1. **首次运行**: 需要微信扫码登录
2. **登录状态**: 会自动保存，下次运行无需重新登录
3. **数据安全**: 登录信息仅保存在本地，不会上传到服务器
4. **程序停止**: 按 Ctrl+C 可以随时停止程序
5. **邮件通知**: 程序开始和结束时会发送邮件通知

## 技术支持

如果遇到问题，请：
1. 查看 `data/output.log` 日志文件
2. 确认环境要求是否满足
3. 尝试重新安装依赖
4. 清理数据后重新登录
