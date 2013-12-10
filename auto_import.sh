#!/bin/bash
source xero_settings.sh
ruby stripe_to_xero.rb
casperjs casper.coffee
echo "successfully imported stripe to xero"
