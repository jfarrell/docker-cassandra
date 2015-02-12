#!/usr/bin/env bash
#
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

set -ex

CONFIG_DIR=/etc/cassandra

IP=$(hostname --ip-address)

# Set up networking addresses
sed -i -e "s/^rpc_address.*/rpc_address: 0.0.0.0/" $CONFIG_DIR/cassandra.yaml
sed -i -e "s/^# broadcast_rpc_address.*/broadcast_rpc_address: $IP/" $CONFIG_DIR/cassandra.yaml
sed -i -e "s/^listen_address.*/listen_address: $IP/" $CONFIG_DIR/cassandra.yaml

# Setup seeds
sed -i -e "s/- seeds: \"127.0.0.1\"/- seeds: \"$IP\"/" $CONFIG_DIR/cassandra.yaml

# Skip gossip for single node cluster
echo "JVM_OPTS=\"\$JVM_OPTS -Dcassandra.skip_wait_for_gossip_to_settle=0\"" >> $CONFIG_DIR/cassandra-env.sh

# Add extra JVM options
echo "JVM_EXTRA_OPTS=\"-XX:TargetSurvivorRatio=50 -XX:+AggressiveOpts -XX:+UseLargePages -Dcassandra.consistent.rangemovement=false\"" >> /etc/default/cassandra

# Start Cassandra
cassandra -f

