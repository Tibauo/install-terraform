FROM centos
#FROM debian
COPY install.tar.gz /opt/
RUN yum update -y \
# apt update -y \
  && cd /opt \
  && tar -xzvf install.tar.gz 
RUN cd /opt/install \
  && ./install.sh

