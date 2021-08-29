FROM ubuntu:20.04

ARG DEBIAN_FRONTEND=noninteractive

ENV TZ="America/Los_Angeles"

RUN apt-get update
RUN apt -y install software-properties-common
RUN add-apt-repository --yes --update ppa:ansible/ansible
RUN apt -y install ansible