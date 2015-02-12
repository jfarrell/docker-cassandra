# docker-cassandra
Docker container for Apache Cassandra


## Usage

### Building
To create the image `docker-cassandra`, execute the following command in the docker-cassandra folder:

    docker build -t cassandra .

You can now push new image to your registry.


### Running your Apache Cassandra image
Start your image binding the external ports 7000 7001 7199 9042 9160

    docker run -d --name cassandra -p 7000:7000 -p 7001:7001 -p 7199:7199 -p 9042:9042 -p 9160:9160 -t cassandra

Linking your Apache Cassandra running container to another container

	docker run --rm --name client --link cassandra:cassandra -i -t ubuntu bin/bash

Testing your linked containers

	gem install cassandra-driver
	pry
	
	require 'cassandra'
	cluster = Cassandra.cluster(hosts:['cassandra'])
	cluster.each_host do |host| # automatically discovers all peers
	  puts "Host #{host.ip}: id=#{host.id} datacenter=#{host.datacenter} rack=#{host.rack}"
	end
	keyspace = 'system'
	session  = cluster.connect(keyspace)
	future = session.execute_async('SELECT keyspace_name, columnfamily_name FROM schema_columnfamilies') # fully asynchronous api
	future.on_success do |rows|
	  rows.each do |row|
	    puts "The keyspace #{row['keyspace_name']} has a table called #{row['columnfamily_name']}"
	  end
	end

