---
name: vpn-server-cli
description: 在 Linux 服务器上通过纯命令行完成 Shadowsocks 部署、防火墙放行和 Nginx 订阅发布的可重复操作流程。适用于新机快速搭建或迁移节点。
---

# 服务器端自建 VPN（CLI 纯操作版）

## 何时使用

- 你需要在 Linux 服务器快速部署可用的 Shadowsocks 节点
- 你希望只用终端完成部署与验证
- 你希望通过 Nginx 发布可访问的订阅文件

## 前置条件

- Ubuntu/Debian 系 Linux 服务器（root 或 sudo 权限）
- 已开放服务器安全组入站：`22/tcp`、`80/tcp`、`8388/tcp`、`8388/udp`

## 变量（先替换）

- `YOUR_PASSWORD`：Shadowsocks 密码
- `YOUR_IP`：服务器公网 IP

## 标准流程

### Step 1：初始化系统

```bash
apt update
apt upgrade -y
```

### Step 2：更换 apt 源（避免卡住）

```bash
sed -i 's/archive.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
sed -i 's/security.ubuntu.com/mirrors.aliyun.com/g' /etc/apt/sources.list
apt update
```

### Step 3：安装 Docker

```bash
apt install -y docker.io
systemctl enable docker
systemctl start docker
```

### Step 4：启动 Shadowsocks

```bash
docker run -d \
  --name ssserver \
  --restart always \
  -p 8388:8388/tcp \
  -p 8388:8388/udp \
  ghcr.io/shadowsocks/ssserver-rust:latest \
  ssserver \
  -s 0.0.0.0:8388 \
  -m aes-256-gcm \
  -k 'YOUR_PASSWORD'
```

### Step 5：配置防火墙

```bash
apt install -y ufw
ufw allow 8388/tcp
ufw allow 8388/udp
ufw allow 22/tcp
ufw enable
```

### Step 6：验证服务

```bash
docker ps
ss -lntup | grep 8388
ufw status
```

### Step 7：安装 Nginx（用于订阅）

```bash
apt install -y nginx
systemctl enable nginx
systemctl start nginx
ufw allow 80/tcp
```

### Step 8：创建订阅文件

```bash
cat > /root/clash.yaml <<'YAML'
proxies:
  - name: "cn2-node"
    type: ss
    server: YOUR_IP
    port: 8388
    cipher: aes-256-gcm
    password: "YOUR_PASSWORD"
    udp: true
proxy-groups:
  - name: "Auto"
    type: select
    proxies:
      - cn2-node
rules:
  - MATCH,Auto
YAML
```

### Step 9：发布订阅

```bash
mv /root/clash.yaml /var/www/html/sub
```

### Step 10：验证订阅

```bash
curl http://127.0.0.1/sub
```

## 常用维护命令

```bash
# 查看容器
docker ps

# 重启 Shadowsocks
docker restart ssserver

# 查看日志
docker logs ssserver

# 停止容器
docker stop ssserver

# 删除容器
docker rm ssserver

# 查看端口
ss -lntup | grep 8388

# 防火墙状态
ufw status
```

## 最小完成标志

- `docker ps` 可见 `ssserver`
- `8388` 端口处于监听状态
- `ufw` 已放行对应端口
- `nginx` 正常运行
- `curl http://127.0.0.1/sub` 返回 YAML
