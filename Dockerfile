FROM ubuntu:14.04.1
MAINTAINER johnm@hooroo.com

# Install package utils
RUN apt-get -y update
RUN apt-get -y install software-properties-common python-software-properties

# Install Ruby2.1.2
RUN add-apt-repository -y ppa:brightbox/ruby-ng
RUN apt-get -y update
RUN apt-get -y install ruby2.1=2.1.2-1bbox1~trusty2 ruby2.1-dev=2.1.2-1bbox1~trusty2

# Make sure to remove parallel config
RUN apt-get -y install parallel

RUN gem install bundler rake

# Create a mount point for the application
VOLUME /srv/application
