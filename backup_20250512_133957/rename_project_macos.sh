#!/bin/bash

# 脚本用于将项目中的"Arroyo"替换为"FlowMatrix"（macOS版本）
# 使用方法: ./rename_project_macos.sh

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

# 查找所有文本文件并替换内容 (macOS版本)
find . -type f -not -path "./node_modules/*" -not -path "./.git/*" -not -path "./$BACKUP_DIR/*" \
    -exec grep -l "Arroyo" {} \; | while read file; do
    echo "处理文件: $file"
    
    # 替换内容 (保持大小写) - macOS版本的sed需要空字符串作为-i参数
    sed -i '' 's/Arroyo/FlowMatrix/g' "$file"
    sed -i '' 's/arroyo/flowmatrix/g' "$file"
    sed -i '' 's/ARROYO/FLOWMATRIX/g' "$file"
    
    echo -e "${GREEN}已更新: $file${NC}"
done

echo -e "${GREEN}项目重命名完成!${NC}"
echo -e "${YELLOW}请检查更改是否符合预期。原始文件已备份到 $BACKUP_DIR 目录。${NC}"
