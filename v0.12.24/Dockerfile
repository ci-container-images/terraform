FROM registry.access.redhat.com/ubi8/ubi:8.1-277
ENV TZ="Europe/Moscow"
WORKDIR /tmp
RUN yum -y install unzip && \
    cd /tmp && \
    curl -O  https://releases.hashicorp.com/terraform/0.12.24/terraform_0.12.24_linux_amd64.zip && \
    unzip  ./terraform*.zip && \
    mv /tmp/terraform /usr/local/bin/


WORKDIR /terraform
CMD ["/bin/bash"]

