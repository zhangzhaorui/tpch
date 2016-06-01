FROM registry.dataos.io/library/centos:6.6
MAINTAINER TPC-H-test zhangzr@maitewang.com
RUN sed  -i 's/mirrorlist/#mirrorlist/'  /etc/yum.repos.d/CentOS-Base.repo
RUN sed  -i 's/#baseurl/baseurl/'  /etc/yum.repos.d/CentOS-Base.repo 
RUN sed  -i 's/mirror.centos.org/mirrors.aliyun.com/'  /etc/yum.repos.d/CentOS-Base.repo
RUN yum -y install wget make gcc gcc-c++ postgresql tar time
ADD tpch /tpch
#WORKDIR /
RUN cd ./tpch/dbgen/ && \
       make &&  \
       /tpch/dbgen/dbgen -s 0.1 -f && \
       cd /tpch/dbgen/ && \
       for i in `ls *.tbl`; do sed 's/|$//' $i > ${i/tbl/csv}; done && \
       chmod 777 *.csv && \
       ln -s `pwd` /tmp/dss-data

RUN chown -R root:root /tpch
CMD ["tail", "-f", "/dev/null"]
