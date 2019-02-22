import os
import json

import schema

MONGO_HOST = os.getenv('MONGO_HOST', 'localhost')
MONGO_PORT = os.getenv('MONGO_PORT', 27017)
MONGO_DBNAME = os.getenv('MONGO_DBNAME', 'report_db')
QUERY_MAX_RESULTS = 1000
PAGINATION = False

REPORTS_COLL = os.getenv('CLINVAP_REPORT_COLL', 'patient_report')

reports = {
    'cache_control': 'max-age=10,must-revalidate',
    'cache_expires': 10,
    'resource_methods': ['GET', 'POST'],
    'schema': schema.get('report'),
}

DOMAIN = {
    REPORTS_COLL: reports,
}
