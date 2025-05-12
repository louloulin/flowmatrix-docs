#!/bin/bash

# 脚本用于将项目中的"Arroyo"替换为"FlowMatrix"
# 使用方法: ./rename_project.sh

# 设置颜色输出
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
RED='\033[0;31m'
NC='\033[0m' # No Color

echo -e "${YELLOW}开始将项目名称从 'Arroyo' 更改为 'FlowMatrix'...${NC}"

# 创建备份目录
BACKUP_DIR="backup_$(date +%Y%m%d_%H%M%S)"
mkdir -p "$BACKUP_DIR"
echo -e "${GREEN}创建备份目录: $BACKUP_DIR${NC}"

# 复制所有文件到备份目录
echo -e "${YELLOW}正在备份文件...${NC}"
cp -r * "$BACKUP_DIR"
echo -e "${GREEN}文件已备份到 $BACKUP_DIR${NC}"

# 替换文件内容
echo -e "${YELLOW}正在替换文件内容...${NC}"

# 查找所有文本文件并替换内容
find . -type f -not -path "./node_modules/*" -not -path "./.git/*" -not -path "./$BACKUP_DIR/*" \
    -exec grep -l -i "arroyo" {} \; | while read file; do
    echo "处理文件: $file"
    # 创建临时文件
    cp "$file" "$file.tmp"

    # 替换内容 (保持大小写)
    if [[ "$OSTYPE" == "darwin"* ]]; then
        # macOS版本
        sed -i '' 's/Arroyo/FlowMatrix/g' "$file.tmp"
        sed -i '' 's/arroyo/flowmatrix/g' "$file.tmp"
        sed -i '' 's/ARROYO/FLOWMATRIX/g' "$file.tmp"
    else
        # Linux版本
        sed -i 's/Arroyo/FlowMatrix/g' "$file.tmp"
        sed -i 's/arroyo/flowmatrix/g' "$file.tmp"
        sed -i 's/ARROYO/FLOWMATRIX/g' "$file.tmp"
    fi

    # 如果文件有变化，则替换原文件
    if ! cmp -s "$file" "$file.tmp"; then
        mv "$file.tmp" "$file"
        echo -e "${GREEN}已更新: $file${NC}"
    else
        rm "$file.tmp"
        echo -e "${YELLOW}无变化: $file${NC}"
    fi
done

# 替换文件名
echo -e "${YELLOW}正在替换文件名...${NC}"
find . -type f -not -path "./node_modules/*" -not -path "./.git/*" -not -path "./$BACKUP_DIR/*" -name "*arroyo*" | while read file; do
    new_file=$(echo "$file" | sed 's/arroyo/flowmatrix/g')
    if [ "$file" != "$new_file" ]; then
        dir=$(dirname "$new_file")
        mkdir -p "$dir"
        mv "$file" "$new_file"
        echo -e "${GREEN}重命名: $file -> $new_file${NC}"
    fi
done

# 替换目录名
echo -e "${YELLOW}正在替换目录名...${NC}"
find . -type d -not -path "./node_modules/*" -not -path "./.git/*" -not -path "./$BACKUP_DIR/*" -name "*arroyo*" | sort -r | while read dir; do
    new_dir=$(echo "$dir" | sed 's/arroyo/flowmatrix/g')
    if [ "$dir" != "$new_dir" ]; then
        parent_dir=$(dirname "$new_dir")
        mkdir -p "$parent_dir"
        # 只有当目录不为空时才移动
        if [ "$(ls -A "$dir" 2>/dev/null)" ]; then
            mv "$dir"/* "$new_dir"/ 2>/dev/null || true
        fi
        rmdir "$dir" 2>/dev/null || true
        echo -e "${GREEN}重命名目录: $dir -> $new_dir${NC}"
    fi
done

echo -e "${GREEN}项目重命名完成!${NC}"
echo -e "${YELLOW}请检查更改是否符合预期。原始文件已备份到 $BACKUP_DIR 目录。${NC}"
