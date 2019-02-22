import os
from eve import Eve

CLINVAP_HOST = os.getenv('CLINVAP_HOST', '0.0.0.0')
CLINVAP_PORT = os.getenv('CLINVAP_PORT', 5151)
CLINVAP_DEBUG = os.getenv('CLINVAP_DEBUG', True)

app = Eve('clinvap')

if __name__ == '__main__':
    app.run(
        host=CLINVAP_HOST,
        port=CLINVAP_PORT,
        debug=CLINVAP_DEBUG,
    )
