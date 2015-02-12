# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.

FROM ubuntu:trusty

ENV DEBIAN_FRONTEND noninteractive

# General Depdenencies
RUN \
  apt-get update && \
  apt-get -y upgrade && \
  apt-get install -y build-essential software-properties-common \
    curl git htop man unzip vim wget

# Install Java.
RUN \
  echo oracle-java7-installer shared/accepted-oracle-license-v1-1 select true | debconf-set-selections && \
  add-apt-repository -y ppa:webupd8team/java && \
  apt-get update && \
  apt-get install -y oracle-java7-installer && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /var/cache/oracle-jdk7-installer

ENV JAVA_HOME /usr/lib/jvm/java-7-oracle

# Install Cassandra
RUN \
  curl -s https://dist.apache.org/repos/dist/release/cassandra/KEYS | gpg --import - && \
  gpg --export --armor | sudo apt-key add - && \
  echo "deb http://www.apache.org/dist/cassandra/debian 21x main" > /etc/apt/sources.list.d/cassandra.list && \
  apt-get update -y && \
  apt-get install -y cassandra=2.1.2

ADD scripts/cassandra-startup.sh /usr/bin/cassandra-startup

EXPOSE 22 7000 7001 7199 9042 9160

# Clean up
RUN \
  apt-get clean && \
  rm -rf /var/cache/apt/* && \
  rm -rf /var/lib/apt/lists/* && \
  rm -rf /tmp/* && \
  rm -rf /var/tmp/*

WORKDIR /root

ENTRYPOINT ["cassandra-startup"]

CMD [""]
