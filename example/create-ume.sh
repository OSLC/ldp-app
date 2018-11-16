# Create the University of Maine example data
#
# The root LDPC for LDP.js is http://localhost:3000 - everything goes in here.
#

# Start with the umaine LDP-RS and add it to the root LDPC
#
curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ/umaine \
 --header 'Content-Type: text/turtle' \
 --data-binary @./umaine.ttl \
 --verbose

# Create the LDPC to contain the students, this is a new root LDPC
curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ/umaine/students \
 --header 'Content-Type: text/turtle' \
 --data-binary @./students.ttl

# add Jay Jackson with a PUT, but not in an LDPC
curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ/umaine/students/727188 \
 --header 'Content-Type:text/turtle' \
 --data-binary @./727188.ttl


# add Fred Johnson with a PUT, but not in an LDPC
curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ/umaine/students/727175 \
 --header 'Content-Type:text/turtle' \
 --data-binary @./727175.ttl


 # Create the LDPC for the teachers
 curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ/umaine/teachers \
 --header 'Content-Type: text/turtle' \
 --data-binary @./teachers.ttl

# add teacher Joe Clark with a put, but not in an LDPC

curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ/umaine/teachers/P154567 \
 --header 'Content-Type:text/turtle' \
 --data-binary @./P154567.ttl


# Create the LDPC for the courses
 curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ/umaine/courses \
 --header 'Content-Type: text/turtle' \
 --data-binary @./courses.ttl

# add the courses

curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ/umaine/courses/EN100 \
 --header 'Content-Type:text/turtle' \
 --data-binary @./EN100.ttl

curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ/umaine/courses/ME201 \
 --header 'Content-Type:text/turtle' \
 --data-binary @./ME201.ttl

curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ/umaine/courses/CS101 \
 --header 'Content-Type:text/turtle' \
 --data-binary @./CS101.ttl



