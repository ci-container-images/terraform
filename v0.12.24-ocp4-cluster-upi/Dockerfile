FROM quay.io/ci-container-images/terraform-bundle:v1.0.0
ENV OCP_RELEASE="4.3.3"

ADD ./terraform-bundle.hcl  /tmp/
RUN cd /tmp  && \
    terraform-bundle package terraform-bundle.hcl  && \
    mkdir terraform-bundle && \
    unzip terraform*.zip   -d ./terraform-bundle


FROM registry.access.redhat.com/ubi8/ubi:8.1-277
ENV TZ="Europe/Moscow"
RUN mkdir /terraform && ln -s /terraform/terraform /bin/terraform && \
    yum -y install git-core
#Install minio s3 client
RUN curl -L  -o /usr/local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc && \
    chmod +x /usr/local/bin/mc
#Install openshift-install
RUN cd /tmp && \
    curl -L -O /usr/local/bin/openshift-install  https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OCP_RELEASE}/openshift-install-linux-${OCP_RELEASE}.tar.gz
    tar -xzf openshift-install-linux-${OCP_RELEASE}.tar.gz && \
    chmod +x openshift-install && \
    mv ./openshift-install /usr/local/bin/

COPY --from=0 /tmp/terraform-bundle/  /terraform/

WORKDIR /terraform
CMD ["/bin/bash"]

