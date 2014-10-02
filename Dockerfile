FROM ubuntu:14.04.1
MAINTAINER johnm@hooroo.com

RUN apt-get -y install python-software-properties
RUN apt-get -y install software-properties-common
RUN add-apt-repository -y ppa:brightbox/ruby-ng-experimental
RUN apt-get -y update

RUN apt-get -y install ruby2.1.2 ruby2.1.2-dev
