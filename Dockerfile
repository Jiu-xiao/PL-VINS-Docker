FROM nvidia/cuda:11.2.2-devel-ubuntu20.04

ARG DEBIAN_FRONTEND=noninteractive

LABEL maintainer="2592509183@qq.com"
LABEL description="This is a Docker Image for DeepLSD build."

RUN apt update && apt upgrade -y --no-install-recommends

RUN apt install wget curl git nano -y --no-install-recommends

RUN wget https://repo.anaconda.com/miniconda/Miniconda3-py38_22.11.1-1-Linux-x86_64.sh
RUN bash Miniconda3-py38_22.11.1-1-Linux-x86_64.sh