FROM quay.io/ci-container-images/terraform-bundle:v1.0.0
ADD ./terraform-bundle.hcl  /tmp/
RUN cd /tmp  && \
    mkdir -p ./plugins && \
    #Install Minio S3 provider
    curl -L -o ./plugins/terraform-provider-minio_v1.1.0  https://github.com/aminueza/terraform-provider-minio/releases/download/v1.1.0/terraform-provider-minio_v1.1.0_linux_amd64 && \
    #Install Ignition configuration provider
    cd ./plugins && \
    curl -L -O https://github.com/poseidon/terraform-provider-ct/releases/download/v0.5.0/terraform-provider-ct-v0.5.0-linux-amd64.tar.gz && \
    tar xzf terraform-provider-ct-v0.5.0-linux-amd64.tar.gz && \
    mv terraform-provider-ct-v0.5.0-linux-amd64/terraform-provider-ct ./terraform-provider-ct_v0.5.0 && \
    cd /tmp && \
    ######
    terraform-bundle package terraform-bundle.hcl  && \
    mkdir terraform-bundle && \
    unzip terraform*.zip   -d ./terraform-bundle


FROM docker.io/fedora:32
ENV OCP_RELEASE="4.4.3"
RUN dnf -y install  p7zip p7zip-plugins && \
    mkdir /tmp/rhcos-installer-iso && \
    cd /tmp/rhcos-installer-iso && \
    curl -O https://mirror.openshift.com/pub/openshift-v4/dependencies/rhcos/latest/latest/rhcos-${OCP_RELEASE}-x86_64-installer.x86_64.iso && \
    7z x *.iso && \
    rm -f *.iso && \
    rm -rf '[BOOT]'

FROM registry.access.redhat.com/ubi8/ubi:8.2
ENV TZ="Europe/Moscow"
ENV OCP_RELEASE="4.4.3"
ENV EXTRACTED_ISO_IMAGE="/rhcos-installer-iso"
ADD ./centos-apps.repo  /etc/yum.repos.d/
#Prepare directories
RUN mkdir /terraform && \
    mkdir /terraform-workspace && \
    ln -s /terraform/terraform /bin/terraform

#Install minio s3 client
RUN curl -L  -o /usr/local/bin/mc https://dl.min.io/client/mc/release/linux-amd64/mc && \
    chmod +x /usr/local/bin/mc
#Install openshift-install
RUN cd /tmp && \
    curl -L -O   https://mirror.openshift.com/pub/openshift-v4/clients/ocp/${OCP_RELEASE}/openshift-install-linux-${OCP_RELEASE}.tar.gz && \
    tar -xzf openshift-install-linux-${OCP_RELEASE}.tar.gz && \
    chmod +x openshift-install && \
    mv ./openshift-install /usr/local/bin/ && \
    rm -f openshift-install-linux-${OCP_RELEASE}.tar.gz
#Add OpenShift extracted ISO image content
COPY --from=1 /tmp/rhcos-installer-iso  ${EXTRACTED_ISO_IMAGE}

#Install xorriso tools from centos repository http://mirror.centos.org/centos/8/AppStream/x86_64/os/ and git core tools
RUN  yum -y install  xorriso git-core && \
     yum clean all

#Add terraform bundle and make all binaries exacutable
COPY --from=0 /tmp/terraform-bundle/  /terraform/
RUN chmod +x  /terraform/*

WORKDIR /terraform-workspace
CMD ["/bin/bash"]

