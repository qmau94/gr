require 'rsolr'
require 'open-uri'
require 'nbayes'
require 'mongo'

ALL=10580
REVIEW_CSV="reviews.csv"
RESULT_CSV="result.csv"
TRAIN="train/train_data/train_data.csv"
TEST="train/test_data/test_data.csv"
CATEGORIES=["camera","design","perform","general","misc"]
HOSTS=["tinhte.vn","vnreview.vn","sohoa.vnexpress.net","news.zing.vn"]
SOLR = RSolr.connect :url => 'http://master:8983/solr/collection1/'
MONGO_DB="test"
MONGO_ADD="master:27017"
HOST_DATA_INDEX=3
ID_DATA_INDEX=0
REVIEW_DATA_INDEX=2
DIGSEST_DATA_INDEX=4
TAG_DATA_INDEX=5
TITLE_DATA_INDEX=1
PUBLISHED_DATE_DATA_INDEX=6
POPULAR_DATA_INDEX=7
