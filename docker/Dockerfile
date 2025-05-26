FROM ubuntu:24.04
LABEL author="liaokangning <lkangn.collin@gmail.com>"
LABEL describe="use for linux kernel"

# 设置时区
ENV TZ=Asia/Shanghai
RUN ln -snf /usr/share/zoneinfo/$TZ /etc/localtime && echo $TZ > /etc/timezone

# 修改下载源
RUN sed -i 's@//.*archive.ubuntu.com@//mirrors.ustc.edu.cn@g' /etc/apt/sources.list.d/ubuntu.sources; \
	sed -i 's/security.ubuntu.com/mirrors.ustc.edu.cn/g' /etc/apt/sources.list.d/ubuntu.sources;

RUN apt-get update && apt-get install ca-certificates --reinstall -y

# 使用 HTTPS 可以有效避免国内运营商的缓存劫持
RUN sed -i 's/http:/https:/g' /etc/apt/sources.list.d/ubuntu.sources

# 安装相关编译环境软件
RUN apt-get update && apt-get install -y \
	# 主机编译工具
	git \
	make \
	gcc \
	flex \
	bison \
	bc \
	libssl-dev \
	libncurses-dev \
	python3 \
	bzip2 \
	perl \
	# arm64 交叉编译工具链
	gcc-aarch64-linux-gnu \
	# 优化编译
	distcc \
	ccache \
	# 网络分析工具
	iproute2 \
	iputils-ping \
	# 调试工具
	remake \
&& apt-get clean

WORKDIR /

