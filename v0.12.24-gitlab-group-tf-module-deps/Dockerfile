FROM quay.io/ci-container-images/terraform-bundle:v1.0.0
ADD ./terraform-bundle.hcl  /tmp/
RUN cd /tmp  && \
    terraform-bundle package terraform-bundle.hcl  && \
    mkdir terraform-bundle && unzip terraform*.zip   -d ./terraform-bundle


FROM registry.access.redhat.com/ubi8/ubi:8.1-277
ENV TZ="Europe/Moscow"
RUN mkdir /terraform && ln -s /terraform/terraform /bin/terraform && \
    yum -y install git-core
COPY --from=0 /tmp/terraform-bundle/  /terraform/

WORKDIR /terraform
CMD ["/bin/bash"]

