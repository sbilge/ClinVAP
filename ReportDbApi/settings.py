import os
import json

__PATH__ = os.path.dirname(__file__)
__REPORT_SCHEMA__ = os.path.join(__PATH__, 'schema/report.json')

with open(__REPORT_SCHEMA__) as fp:
    reports_schema = json.load(fp)

reports = {
    'cache_control': 'max-age=10,must-revalidate',
    'cache_expires': 10,
    'resource_methods': ['GET', 'POST'],
    'schema': reports_schema,
}

DOMAIN = {
    'reports': reports
}

MONGO_HOST = 'db'
MONGO_PORT = 27017
MONGO_DBNAME = 'clinical_reporting'

QUERY_MAX_RESULTS = 1000
PAGINATION = False
