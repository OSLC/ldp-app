# Create the University of Maine example data
#
# The root LDPC for LDP.js is http://localhost:3000/r - everything goes in here.
#

# Start with the umaine LDP-RS and add it to the root LDPC
#
curl --request POST \
 --url http://localhost:3000/r/ \
 --header 'Slug: umaine' \
 --header 'Content-Type: text/turtle' \
 --data-binary @./umaine.ttl

# Create the LDPC to contain the students, this is a new root LDPC
curl --request PUT \
 --url http://localhost:3000/r/umaine/students \
 --header 'Content-Type: text/turtle' \
 --data-binary @./students.ttl

 # Add Fred Johnson to the students container
 curl --request POST\
 --url http://localhost:3000/r/umaine/students \
 --header 'Slug:727175' \
 --header 'Content-Type:text/turtle' \
 --data-binary @./727175.ttl

  # Add Jay Jackson to the students container
 curl --request POST\
 --url http://localhost:3000/r/umaine/students \
 --header 'Slug:727188' \
 --header 'Content-Type:text/turtle' \
 --data-binary @./727188.ttl

 # Create the LDPC for the teachers
 curl --request PUT \
 --url http://localhost:3000/r/umaine/teachers \
 --header 'Content-Type: text/turtle' \
 --data-binary @./teachers.ttl

 # Create the LDPC for the courses
 curl --request PUT \
 --url http://localhost:3000/r/umaine/courses \
 --header 'Content-Type: text/turtle' \
 --data-binary @./courses.ttl

 # Get information about the /umaine/students container
 curl --request GET \
 --url http://localhost:3000/r/umaine/students \
 --header 'Accept: text/turtle' \
 --header 'Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMinimalContainer"'

 # Get the members of the the /umaine/students container, preferring the containment triples
 curl --request GET \
 --url http://localhost:3000/r/umaine/students \
 --header 'Accept: text/turtle' \
 --header 'Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferContainment http://www.w3.org/ns/ldp#PreferMinimalContainer"'

 # Get the members of the the /umaine/students container, preferring the membership triples
 curl --request GET \
 --url http://localhost:3000/r/umaine/students \
 --header 'Accept: text/turtle' \
 --header 'Prefer: return=representation; include="http://www.w3.org/ns/ldp#PreferMembership http://www.w3.org/ns/ldp#PreferMinimalContainer"'



