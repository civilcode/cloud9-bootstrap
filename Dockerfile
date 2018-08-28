FROM amazonlinux

LABEL maintainer="bonjour@civilcode.io"

RUN yum groupinstall -y "Development Tools"
RUN yum install -y sudo wget go

RUN mkdir /app
WORKDIR /app

CMD ["/bin/bash"]
