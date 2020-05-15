FROM quay.io/ci-container-images/terraform-bundle:v1.0.0

ADD ./terraform-bundle.hcl  /tmp/
RUN cd /tmp  && \
    mkdir -p ./plugins && \
    curl -L -o ./plugins/terraform-provider-minio_v1.1.0  https://github.com/aminueza/terraform-provider-minio/releases/download/v1.1.0/terraform-provider-minio_v1.1.0_linux_amd64 && \
    chmod +x ./plugins/terraform-provider-minio_v1.1.0 && \
    terraform-bundle package terraform-bundle.hcl  && \
    mkdir terraform-bundle && \
    unzip terraform*.zip   -d ./terraform-bundle


FROM registry.access.redhat.com/ubi8/ubi:8.2
ENV TZ="Europe/Moscow"
ENV OCP_RELEASE="4.3.3"
ADD ./centos-apps.repo  /etc/yum.repos.d/
RUN mkdir /terraform && ln -s /terraform/terraform /bin/terraform && \
    yum -y install git-core
#Install minio s3 client
RUN curl -L  -o /usr/local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc && \
    chmod +x /usr/local/bin/mc
#Install openshift-install
RUN cd /tmp && \
    curl -L -O   https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OCP_RELEASE}/openshift-install-linux-${OCP_RELEASE}.tar.gz && \
    tar -xzf openshift-install-linux-${OCP_RELEASE}.tar.gz && \
    chmod +x openshift-install && \
    mv ./openshift-install /usr/local/bin/

#Install xorriso tools from centos repository http://mirror.centos.org/centos/8/AppStream/x86_64/os/
RUN  yum -y install  xorriso && \
     yum clean all

RUN mkdir /terraform-workspace
COPY --from=0 /tmp/terraform-bundle/  /terraform/

WORKDIR /terraform-workspace
CMD ["/bin/bash"]

