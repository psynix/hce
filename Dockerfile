FROM ubuntu:14.04.1
MAINTAINER johnm@hooroo.com

RUN uname -a
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:brightbox/ruby-ng
RUN apt-get -y update

RUN apt-get -y install ruby2.1=2.1.2-1bbox1~trusty2 ruby2.1-dev=2.1.2-1bbox1~trusty2
