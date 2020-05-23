#!/bin/bash
#
# 参数格式: upload [扩展名] [操作]
# 扩展名:
# png、jpg、jped、zip、mp4等等，可以传 all 或者不传参数代表所有格式
# 操作:
# open: 上传完成后在浏览器中打开链接
#
# 常用命令示例:
# upload             上传所有可上传的文件
# upload all         上传所有可上传的文件
# upload all open    上传所有可上传的文件，并在浏览器中打开链接
# upload png         上传所有png的文件

# 文件个数
COUNT=0
# 参数表
PARAM1=$1
PARAM2=$2


function output() {
	printf "> [\033[32m${FILENAME}\033[0m] 已上传至:\n\033[32m${URL}\033[0m\n"
}

function upload() {
	echo "> 正在上传: ${FILENAME}"
	URL=`curl -s -F "name=@${FILENAME}" https://img.vim-cn.com/ 2>&1`
	case ${PARAM2} in
		'open') output && open ${URL} ;;
		*) output ;;
  esac
}

function check() {
	for FILENAME in *
	do
		if [ -d "$FILENAME" ]; then
			cd "${FILENAME}"
			check ${FILENAME}
			cd ..
		elif [ -r "$FILENAME" ]; then
			case $PARAM1 in
				''|'all')
				  # 不传参数/传all都代表上传所有文件
					let COUNT++
					upload &
				;;
				*)
				  # 否则就上传指定的文件
					if [ "${FILENAME##*.}"x = "${PARAM1}"x ];then
						let COUNT++
						upload &
					fi
				;;
			esac
	  fi
	done
}

function start() {
	case $PARAM1 in
		*)
			printf "\n> \033[34mSTART:\033[0m 开始上传......\n\n"
			check
			wait
			printf "\n> \033[34mEND:\033[0m 检测到的\033[32m\033[1m${COUNT}\033[0m个文件已全部上传完毕！\n\n"
		;;
  esac
}

start
