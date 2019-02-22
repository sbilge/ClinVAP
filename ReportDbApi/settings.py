import os
import json

MONGO_HOST = os.getenv('MONGO_HOST', 'localhost')
MONGO_PORT = os.getenv('MONGO_PORT', 27017)
MONGO_DBNAME = os.getenv('MONGO_DBNAME', 'report_db')
QUERY_MAX_RESULTS = 1000
PAGINATION = False

__PATH__ = os.path.dirname(__file__)
__REPORT_SCHEMA__ = os.path.join(__PATH__, 'schema/report.json')

REPORTS_COLL = os.getenv('CLINVAP_REPORT_COLL', 'patient_report')

with open(__REPORT_SCHEMA__) as fp:
    reports_schema = json.load(fp)

reports = {
    'cache_control': 'max-age=10,must-revalidate',
    'cache_expires': 10,
    'resource_methods': ['GET', 'POST'],
    'schema': reports_schema,
}

DOMAIN = {
    REPORTS_COLL: reports
}
