# 使用轻量级 Nginx 镜像
FROM nginx:alpine

# 设置工作目录（可选，但好习惯）
WORKDIR /usr/share/nginx/html

# 1. 移除 Nginx 默认的 html 文件
RUN rm -rf ./*

# 2. 复制构建产物
# 注意：这里的 dist 是 GitHub Actions 在 Docker 构建前跑 npm run build 生成的
COPY dist .

# 3. 复制自定义 Nginx 配置
# 假设你的根目录下有一个 nginx.conf
COPY nginx.conf /etc/nginx/nginx.conf

# 4. 【权限保险】
# 虽然在 Linux Action 上构建通常没问题，但为了防止 Nginx 报 403 Forbidden，
# 我们递归给所有文件赋予 755 (所有者读写执行，其他人读执行)
RUN chmod -R 755 /usr/share/nginx/html

# 暴露端口
EXPOSE 80

# 启动 Nginx
CMD ["nginx", "-g", "daemon off;"]