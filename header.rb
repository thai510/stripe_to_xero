#!/usr/bin/env ruby
# the name of your bank of xero. example: "US Bank"
BANK_NAME = "name" 
# how far back you want to look on stripe for data to include in the CSV
TIME_INTERVAL = 1 #unit: days
# your secret stripe key
STRIPE_SECRET = "secret key"
# output file name (will automatically append .csv) to your value
OUTPUT_FILE = "xero"
# use timestamp in outputfilename (will append a timestamp before .csv)
USE_TIMESTAMP = true 
# number of customers to fetch at a time on stripe
COUNT = 100
# waiting period. Important because of the way stripe's API works with number of parallel requests
WAITING_INTERVAL = 2 #unit: seconds
