# Commands to run tests
- **Path** to db in **.env** required
- **Active** db required

1.```pytest```   to run all tests

2.```pytest -m integration``` to run integrational only

3.```coverage run -m pytest``` to run all tests with coverage enabled. After this
```coverage report``` to see coverage results