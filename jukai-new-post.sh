#!/bin/sh

# JUKAI.SITE ~ 快速创建新文章
# POSIX sh 版本，可在 Linux / macOS 等环境中运行。

# 如果输出到终端，设置终端标题和颜色。
if [ -t 1 ]; then
    printf '\033]0;JUKAI.SITE ~ 快速创建新文章\007'
    CYAN='\033[36m'
    RED='\033[31m'
    RESET='\033[0m'
else
    CYAN=''
    RED=''
    RESET=''
fi

printf '%b\n' "${CYAN}==================================================${RESET}"
printf '%b\n' "${CYAN}            JUKAI.SITE 新建文章向导${RESET}"
printf '%b\n' "${CYAN}==================================================${RESET}"
printf '当前工作目录：%s\n' "$(pwd)"
printf '注意：请确保在 Hugo 站点的根目录下运行此脚本。\n\n'

while :; do
    printf '请输入文章的英数路径 (只用小写字母、数字和中划线): '

    if ! IFS= read -r slug; then
        printf '\n'
        exit 1
    fi

    if [ -z "$slug" ]; then
        printf '%b\n\n' "${RED}[错误] 路径不能为空，请重新输入。${RESET}"
        continue
    fi

    case "$slug" in
        *[!a-z0-9-]*)
            printf '%b\n' "${RED}[错误] 路径只能包含小写字母、数字和中划线 (-)。${RESET}"
            printf '请重新输入。\n\n'
            continue
            ;;
    esac

    if [ -e "content/posts/$slug" ]; then
        printf '%b\n' "${RED}[错误] 目录 \"content/posts/$slug\" 已存在。${RESET}"
        printf '请重新输入一个不同的路径。\n\n'
        continue
    fi

    break
done

printf '\n正在生成页面包: content/posts/%s/ ...\n\n' "$slug"

if ! command -v hugo >/dev/null 2>&1; then
    printf '%b\n' "${RED}[错误] 未找到 hugo 命令，请确认 Hugo 已安装并位于 PATH 中。${RESET}" >&2
    exit 127
fi

hugo new "posts/$slug/index.md"
