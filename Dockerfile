# Stage 1: Node.jsを使ってビルド
FROM node:20-alpine AS builder

WORKDIR /app

# package.jsonとpackage-lock.jsonをコピーして依存関係をインストール
COPY package.json package-lock.json ./
RUN npm install --frozen-lockfile

# ソースコードをコピーしてビルド
COPY . .
RUN npm run build

# Stage 2: Nginxを使って配信
FROM nginx:1.25-alpine

# Nginxのデフォルト設定を削除してカスタム設定を追加
COPY default.conf /etc/nginx/conf.d/default.conf

# ビルド成果物をnginxの配信ディレクトリにコピー
COPY --from=builder /app/dist /usr/share/nginx/html

# コンテナ起動時にnginxを実行
CMD ["nginx", "-g", "daemon off;"]