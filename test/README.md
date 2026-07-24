# Commands to run tests

0.Start main db with ```docker compose up``` or ```docker compose up -d```

1.```docker compose --profile test up -d db_test``` - start test db

2.```pytest```   to run all tests

3.```coverage run -m pytest``` - to run all tests with coverage enabled. After this
```coverage report``` to see coverage results

4.```docker compose --profile test stop db_test ``` - stop test db