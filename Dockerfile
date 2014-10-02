FROM ubuntu:14.04
MAINTAINER johnm@hooroo.com

RUN apt-get -qqy update
RUN apt-get -qqy install software-properties-common python-software-properties

RUN add-apt-repository -y ppa:brightbox/ruby-ng
RUN apt-get -qqy update
RUN apt-get -qqy install ruby2.1=2.1.2-1bbox1~trusty2 ruby2.1-dev=2.1.2-1bbox1~trusty2
