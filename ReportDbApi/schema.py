import os
import json

__PATH__ = os.path.dirname(__file__)
__SCHEMAS__ = os.path.join(__PATH__, 'schema')

def get(name):
    schema = os.path.join(__SCHEMAS__, name+'.json')
    with open(schema) as fp:
        return json.load(fp)
