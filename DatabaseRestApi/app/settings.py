schema = {
                "alias_symbol": {"type":["string","double"]},
                "cancer": {"type":"array"},
                "date_approved_reserved": {"type":["string","double"]},
                "date_modified": {"type":["string","double"]},
                "date_symbol_changed": {"type":["string","double"]},
                "driver_information":{"type":"array"},
                "drugs": {"type":"array"},
                "ensembl_gene_id": {"type":["string","double"]},
                "entrez_id": {"type":"double"},
                "gene_family": {"type":["string","double"]},
                "gene_symbol": {"type":"string"},
                "hgnc_id": {"type":"int32"},
                "location": {"type":["string","double"]},
                "locus_group": {"type":"string"},
                "locus_type": {"type":"string"},
                "name": {"type":"string"},
                "prev_symbol": {"type":["string","double"]},
                "status": {"type":"string"},
                "uniprot_ids": {"type":["string","double"]},
                "driver_score": {"type":["int32","string"]},
                "drug_evidence_score": {"type":"array"}
        }


genedrug = {
    # 'title' tag used in item links. Defaults to the resource title minus
    # the final, plural 's' (works fine in most cases but not for 'people')
    'item_title': 'gene_symbol',

    # by default the standard item entry point is defined as
    # '/charlotta/<ObjectId>'. We leave it untouched, and we also enable an
    # additional read-only entry point. This way consumers can also perform
    # GET requests at '/people/<lastname>'.
    'additional_lookup': {
        'url': 'regex("[\w]+")',
        'field': 'gene_symbol'
    },

    # We choose to override global cache-control directives for this resource.
    'cache_control': 'max-age=10,must-revalidate',
    'cache_expires': 10,

    # most global settings can be overridden at resource level
    'resource_methods': ['GET', 'POST'],

    'schema': schema
}



#DOMAIN = {'charlotta': genedrug }
DOMAIN = {'biograph_genes': genedrug }
# Let's just use the local mongod instance. Edit as needed.

# Please note that MONGO_HOST and MONGO_PORT could very well be left
# out as they already default to a bare bones local 'mongod' instance.
MONGO_HOST = 'mongodb'
MONGO_PORT = 27017

# Skip these if your db has no auth. But it really should.
#MONGO_USERNAME = '<your username>'
#MONGO_PASSWORD = '<your password>'
MONGO_DBNAME = "clinical_reporting"

QUERY_MAX_RESULTS = 1000
PAGINATION = False
#MONGO_DBNAME = 'drivers'
