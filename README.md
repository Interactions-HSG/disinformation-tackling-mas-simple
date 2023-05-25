# disinformation-tackling-mas-simple

A dummy MAS where an admin agent allocates tasks to agents within a MOISE organisation for tackling online disinformation. 

Requirements:
- More than one agents can evaluate the same article for the same subprocess
- An agent can evaluate more than one articles
- An agent can complete more than one subprocesses

Modelling decisions:
- One group per article
- One scheme per process (e.g. content evaluation)
- One mission per subprocess (e.g. general article impression, article subject etc.)

To run:
```
./gradlew task
```
