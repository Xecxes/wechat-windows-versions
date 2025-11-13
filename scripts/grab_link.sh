#!/bin/bash

# --- 配置 ---
TARGET_URL="https://pc.weixin.qq.com/"
# CSS 选择器：精确匹配 a 标签，同时具备 class="download-button" 和 id="downloadButton" 属性
CSS_SELECTOR="a.download-button#downloadButton"
# --- 配置结束 ---

# 1. 检查 pup 命令是否可用
if ! command -v pup &> /dev/null
then
    echo "❌ 错误：未找到 'pup' 命令。请确保 pup 已安装并配置在 \$PATH 中。"
    exit 1
fi

# 2. 使用 curl 下载网页，通过 pup 和 CSS 选择器精确提取链接的 href 属性
GRABBED_LINK=$(
    curl -s "$TARGET_URL" | \
    pup "$CSS_SELECTOR" attr{href} | \
    head -n 1
)

# --- 3. 输出结果 ---
if [ -z "$GRABBED_LINK" ]; then
    echo "❌ 错误：未能找到匹配选择器 '$CSS_SELECTOR' 的超链接。"
    echo "⚠️ 警告：此失败很可能因为目标网站（${TARGET_URL}）的内容是动态加载的，纯静态解析工具（如 pup）无法抓取。"
else
    echo "✅ 成功抓取到的超链接："
    # 补上协议头
    if [[ "$GRABBED_LINK" == //* ]]; then
        FULL_LINK="https:$GRABBED_LINK"
    else
        FULL_LINK="$GRABBED_LINK"
    fi
    echo "$FULL_LINK"
fi
