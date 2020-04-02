FROM jenkins/jenkins:lts
# use root to install cli's
USER root
# install docker
ENV DOCKERVERSION=18.09.9
RUN curl -fsSLO https://download.docker.com/linux/static/stable/x86_64/docker-${DOCKERVERSION}.tgz \
  && tar xzvf docker-${DOCKERVERSION}.tgz --strip 1 \
                 -C /usr/local/bin docker/docker \
  && rm docker-${DOCKERVERSION}.tgz
# install kubectl
RUN apt-get update && apt-get install -y apt-transport-https \
  && curl -s https://packages.cloud.google.com/apt/doc/apt-key.gpg | apt-key add - \
  && echo "deb https://apt.kubernetes.io/ kubernetes-xenial main" | tee -a /etc/apt/sources.list.d/kubernetes.list \
  && apt-get update \
  && apt-get install -y kubectl
# install openshift-cli
ENV OPENSHIFTVERSION=v3.11.0-0cbc58b-linux-64bit
RUN wget -q https://github.com/openshift/origin/releases/download/v3.11.0/openshift-origin-client-tools-${OPENSHIFTVERSION}.tar.gz \
  && tar -zvxf openshift-origin-client-tools-${OPENSHIFTVERSION}.tar.gz \
  && cd openshift-origin-client-tools-${OPENSHIFTVERSION} \
  && cp oc /usr/local/bin \
  && cd .. && rmdir --ignore-fail-on-non-empty openshift-origin-client-tools-${OPENSHIFTVERSION} \
  && rm openshift-origin-client-tools-${OPENSHIFTVERSION}.tar.gz
# add señor Jenkins to docker group for rights to /var/run/docker.sock
RUN groupadd docker \
  && usermod -a -G docker jenkins
# back to Jenkins user
USER jenkins
ENTRYPOINT ["tini", "--", "/usr/local/bin/jenkins.sh"]
