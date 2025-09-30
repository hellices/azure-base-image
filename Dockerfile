FROM ubuntu:20.04

ENV DEBIAN_FRONTEND=noninteractive

# CIFS 및 Kerberos 인증에 필요한 핵심 패키지 설치
RUN apt-get update && apt-get install -y \
    cifs-utils \
    keyutils \
    krb5-user \
    samba-common-bin \
    && apt-get clean && rm -rf /var/lib/apt/lists/*

# 기본 명령
CMD ["/bin/bash"]
