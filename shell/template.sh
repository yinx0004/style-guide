#!/usr/bin/env bash
#===============================================================================
# Bash Script Template
# Author: Sherry Yin
# Version: 1.0
# Function: 
#===============================================================================

# Enable strict mode
set -euo pipefail
IFS=$'\n\t'

# 变量定义
SCRIPT_NAME=$(basename "$0")
LOG_FILE="/var/log/${SCRIPT_NAME%.sh}.log"

# Display color
RED="\e[31m"
GREEN="\e[32m"
YELLOW="\e[33m"
RESET="\e[0m"

# 日志函数
log_info()    { echo -e "[INFO]  $(date '+%Y-%m-%d %H:%M:%S') $*" | tee -a "$LOG_FILE"; }
log_warning() { echo -e "[WARN]  $(date '+%Y-%m-%d %H:%M:%S') ${YELLOW}$*${RESET}" | tee -a "$LOG_FILE"; }
log_error()   { echo -e "[ERROR] $(date '+%Y-%m-%d %H:%M:%S') ${RED}$*${RESET}" | tee -a "$LOG_FILE" >&2; }

# 捕获错误
trap 'log_error "脚本遇到错误，退出！"' ERR

# 帮助信息
usage() {
    cat <<EOF
使用方法: $SCRIPT_NAME [选项]

选项:
  -f <文件>   指定要处理的文件
  -d <目录>   指定要处理的目录
  -h          显示帮助信息

示例:
  $SCRIPT_NAME -f data.txt
EOF
}

# 解析参数
FILE=""
DIR=""

while getopts "f:d:h" opt; do
    case ${opt} in
        f) FILE="$OPTARG" ;;
        d) DIR="$OPTARG" ;;
        h) usage; exit 0 ;;
        *) usage; exit 1 ;;
    esac
done

# 校验输入参数
if [[ -z "$FILE" && -z "$DIR" ]]; then
    log_error "必须指定 -f <文件> 或 -d <目录>"
    usage
    exit 1
fi

# 主要功能函数
process_file() {
    local file="$1"
    if [[ -f "$file" ]]; then
        log_info "正在处理文件: $file"
        # 这里可以添加你的业务逻辑
    else
        log_error "文件 $file 不存在"
        exit 1
    fi
}

process_dir() {
    local dir="$1"
    if [[ -d "$dir" ]]; then
        log_info "正在处理目录: $dir"
        # 这里可以添加你的业务逻辑
    else
        log_error "目录 $dir 不存在"
        exit 1
    fi
}

# 执行逻辑
if [[ -n "$FILE" ]]; then
    process_file "$FILE"
fi

if [[ -n "$DIR" ]]; then
    process_dir "$DIR"
fi

log_info "脚本执行完成！"
