# Create the University of Maine example data
#
# The root LDPC for LDP.js is http://localhost:3000 - everything goes in here.
#
# Start the Fuseki server:
# cd ~/bin/apache-jena-fuseki1-6.0.0
# ./fuseki-server --conf=../config-univ.ttl

# Create the /univ BasicContainer, the root container for the database
curl --request PUT \
 --url http://localhost:3030/univ/data?graph=http://localhost:3000/univ \
 --header 'Content-Type: text/turtle' \
 --data-binary @./univ.ttl

# Add a new University
 curl --request POST \
 --url http://localhost:3030/univ \
 --header 'Slug:umt' \
 --header 'Content-Type:text/turtle' \
 --data-binary @./umt.ttl --verbose

# Get information about the /univ container
 curl --request GET \
 --url http://localhost:3030/univ \
 --header 'Accept: text/turtle' \
 --header 'Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMinimalContainer"'

 # Get the members of the the /umaine/students container, preferring the containment triples
 curl --request GET \
 --url http://localhost:3030/univ \
 --header 'Accept: text/turtle' \
 --header 'Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferContainment http://www.w3.org/ns/ldp#PreferMinimalContainer"'

 # Get the members of the the /umaine/students container, preferring the membership triples
 curl --request GET \
 --url http://localhost:3030/univ \
 --header 'Accept: text/turtle' \
 --header 'Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMembership http://www.w3.org/ns/ldp#PreferMinimalContainer"'






# Start with the umaine LDP-RS and add it to the root LDPC
#
curl --request PUT \
 --url http://localhost:3000/univ/data?graph=http://localhost:3000/univ/umaine \
 --header 'Content-Type: text/turtle' \
 --data-binary @./umaine.ttl \
 --verbose

# GET the umaine graph that was just created
curl --request GET \
 --url http://localhost:3000/univ/data?graph=http://localhost:3000/univ/umaine \
 --header 'Accept: text/turtle' 

# Create the LDPC to contain the students, this is a new root LDPC
curl --request PUT \
 --url http://localhost:3000/univ/data?graph=http://localhost:3000/univ/umaine/students \
 --header 'Content-Type: text/turtle' \
 --data-binary @./students.ttl

 # Add Fred Johnson to the students container using LDP
 curl --request POST\
 --url http://localhost:3000/umaine/students \
 --header 'Slug:727175' \
 --header 'Content-Type:text/turtle' \
 --data-binary @./727175.ttl \
 --verbose





# For testing POST to add a new member to a container

# Reset umaine to its original state (doesn't have student 727185)
curl --request PUT \
 --url http://localhost:3000/univ/data?graph=http://localhost:3000/univ/umaine \
 --header 'Content-Type: text/turtle' \
 --data-binary @./umaine.ttl 

# delete student 727185 in case it already exists
curl --request DELETE \
--url http://localhost:3000/univ/umaine/students/727185 

# Add Joe Smith to the students container
 curl --request POST \
 --url http://localhost:3000/univ/umaine/students \
 --header 'Slug:727185' \
 --header 'Content-Type:text/turtle' \
 --data-binary @./727185.ttl --verbose

# Get the new student, it should exist from a 201 status from the previous command
curl --request GET \
--url http://localhost:3000/univ/umaine/students/727185 \
 --header 'Accept:text/turtle'

# and the Student 727185 should now be part of umaine students
curl http://localhost:3000/univ/umaine 

# and members of the students LDPC should also now include Student 727185
 curl --request GET \
 --url http://localhost:3000/univ/umaine/students \
 --header 'Accept: text/turtle'





 # this is just for testing, add Jay Jackson with a PUT, but not in a container
curl --request PUT \
 --url http://localhost:3000/univ/umaine/students/727185 \
 --header 'Content-Type:text/turtle' \
 --data-binary @./727188.ttl


# this is just for testing, add Fred Johnson with a PUT, but not in a container
curl --request PUT \
 --url http://localhost:3000/univ/umaine/students/727175 \
 --header 'Content-Type:text/turtle' \
 --data-binary @./727175.ttl

curl --request GET \
 --url http://localhost:3000/univ/umaine/students/727175 \
 --header 'Accept:text/turtle'
 
 # Create the LDPC for the teachers
 curl --request PUT \
 --url http://localhost:3000/univ/data?graph=http://localhost:3000/univ/umaine/teachers \
 --header 'Content-Type: text/turtle' \
 --data-binary @./teachers.ttl

 # Get information about the /umaine/teachers container
 curl --request GET \
 --url http://localhost:3000/univ/umaine/teachers \
 --header 'Accept: text/turtle' 

 # Delete the /umaine/teachers container
 curl --request DELETE --url http://localhost:3000/univ/umaine/teachers 
 
 # Create the LDPC for the courses
 curl --request PUT \
 --url http://localhost:3000/univ/data?graph=http://localhost:3000/univ/umaine/courses \
 --header 'Content-Type: text/turtle' \
 --data-binary @./courses.ttl

 # Get information about the /umaine/students container
 curl --request GET \
 --url http://localhost:3000/univ/umaine/students \
 --header 'Accept: text/turtle' \
 --header 'Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMinimalContainer"'

 # Get the members of the the /umaine/students container, preferring the containment triples
 curl --request GET \
 --url http://localhost:3000/univ/umaine/students \
 --header 'Accept: text/turtle' \
 --header 'Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferContainment http://www.w3.org/ns/ldp#PreferMinimalContainer"'

 # Get the members of the the /umaine/students container, preferring the membership triples
 curl --request GET \
 --url http://localhost:3000/univ/umaine/students \
 --header 'Accept: text/turtle' \
 --header 'Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMembership http://www.w3.org/ns/ldp#PreferMinimalContainer"'



###########

# Testing POST to an LDPC to add a member to the container


# Add Joe Smith to the umaine students using an LDPC DirectContainer
 curl --request POST \
 --url http://localhost:3000/univ/umaine/students \
 --header 'Slug:727185' \
 --header 'Content-Type:text/turtle' \
 --data-binary @./727185.ttl \
 --verbose

# Check the result: should have resource Joe Smith, and added to university students

# GET Joe Smith to the umaine students using an LDPC DirectContainer
 curl --request GET \
 --url http://localhost:3000/univ/umaine/students/727185 \
 --header 'Accept:text/turtle'

# Joe Smith 727185 should be added to the umaine students
curl --request GET \
 --url http://localhost:3000/univ/umaine \
 --header 'Accept: text/turtle' 

 # and be a member of the /umaine/students container
 curl --request GET \
 --url http://localhost:3000/univ/umaine/students \
 --header 'Accept: text/turtle'




