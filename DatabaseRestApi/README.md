# clinicalReporting_DB_RESTAPI
If you would like to use the database as a stand-alone application, use docker-compose to set up the MongoDB and attache Eve REST API.

command line usage is as follows:

```docker-compose up```

To test the functionality, point your browser to the following link:

```http://localhost:5000/biograph_genes?where={%22meta_information.symbol%22:%20%22EGFR%22}```
