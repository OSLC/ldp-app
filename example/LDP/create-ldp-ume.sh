# Create the University of Maine example data
#
# The root LDPC for LDP.js is http://localhost:3000 - everything goes in here.
#
# LDP resource is stored as a separate named graph in Fuseki, where the
#  graph URI equals the resource URI. This is a natural fit because:
#
#  - Each LDP resource is logically an RDF graph (a set of triples)
#  - Named graphs provide clean isolation — you can create, read, update, and delete individual resources independently
#  - Containment and membership relationships between resources are expressed as triples within those graphs
#
# The sample ldp-app runs on port 3000
#
# Example GET http://localhost:3030/univ/get?graph=http://localhost:3000/univ/umaine
#
curl -X POST http://localhost:3030/univ/update --data-urlencode 'update=DROP ALL'

# Load the University Schema
#
curl --request PUT \
 --url http://localhost:3000/univ/data?graph=http://localhost:3000/univ/rdfs \
 --header 'Content-Type: text/turtle' \
 --data-binary @./university-ldp-schema.ttl \
 --verbose


# Start with the umaine resource
#
curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ/umaine \
 --header 'Content-Type: text/turtle' \
 --data-binary @./umaine.ttl \
 --verbose

# Create the LDPCs to contain the courses, professors and students, this is a new root LDPC
curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ/umaine/students \
 --header 'Content-Type: text/turtle' \
 --data-binary @./students.ttl


# Create the LDPCs to contain the courses, professors and students, this is a new root LDPC
curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ/umaine/courses \
 --header 'Content-Type: text/turtle' \
 --data-binary @./courses.ttl


# Create the LDPCs to contain the courses, professors and students, this is a new root LDPC
curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ/umaine/professors \
 --header 'Content-Type: text/turtle' \
 --data-binary @./professors.ttl




