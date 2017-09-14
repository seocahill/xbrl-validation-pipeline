# xbrl-validation-pipeline
This stack takes an iXBRL instance document as an input and validates it against referenced XSD schemas and custom business rules.

The only supported Discoverable Taxonomy Set is the 2012 Irish GAAP taxonomy extension to the 2012 UK GAAP taxonomy. This will soon be deprecated in favour of the forthcoming FRS 102 taxonomy.

The implemented custom validations rules are listed in the document "Electronic Filing of Financial Statements (iXBRL)" which is published on the Irish Revenue Commissioners website - www.revenue.ie.

This repo is offered for demonstration purposes only, use in production at your own risk.

## The Stack

The stack consists of a patched image of Arelle, an open source XBRL processing application and an XBRL validator application.

- [Arelle web service](https://github.com/seocahill/arelle-web-service)
- [Xbrl validator app](https://github.com/seocahill/xbrl-validator)

The arelle web service handles specific validation scenarios, for example xbrl dimensional validation. 

The xbrl validator app handles data extraction; xhtml, ixbrl and xbrl schema validation; and validation of custom business rules.

There is also a dummy app included for making test requests to the stack.


## Running

Firstly you will need to make sure you have docker installed on your system and running: [get docker](https://www.docker.com/get-docker)

### Tests

Execute ```run_tests.sh``` to bring up the stack and run the validation tests.

You can view json response logs in the logs directory as well as a standard error log.

### Validating an instance document

Bring up the stack using the command ```docker-compose up -d``` (omit the d flag if you want to run in the foreground).

Stop the stack with ```docker-compose down```.

To use the Arelle validation service make a GET request to:

```
http://localhost:8080/rest/xbrl/validation?file=/ixbrl/#{filename})
```

To use the XBRL validator validation service make a GET request to 

```
http://localhost:4567/validate/#{filename})
```

In both of the examples above ```#{filename}``` should be the full name of the ixbrl instance you want to validate e.g. ```acme-ltd-31-12-2016-ixbrl-instance.html```

#### N.B. Location of files

Both the validation services expect the files to be located in a folder called 'ixbrl'.

When the test suite is run the example ixbrl instance files folder is mounted into each app's container as '/ixbrl'.

If you wish to expose a folder on your host machine instead change the volume mount source in the docker-compose.yml file to the folder where your ixbrl instance documents are located, e.g.

```
  volumes: 
      - /Users/my-name/documents/ixbrl-docs:/ixbrl
```

Otherwise you can just drop your files in the ixbrl folder where the test files are currently.

For more details on how docker volume mounting works consult the docker api documentation.

#### Arelle API

To view the full API documentation for the Arelle web service go to:

```
http://localhost:8080/help
```
