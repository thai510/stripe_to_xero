#!/usr/bin/env ruby

require 'csv'
require 'date'
require 'stripe'

require_relative './header.rb'

Stripe.api_key = STRIPE_SECRET
puts "==========================================="
puts "Getting ready to run stripe => xero script."
puts "===========================================\n\n"
print "Checking for necessary variables..."
[TIME_INTERVAL, STRIPE_SECRET, OUTPUT_FILE].each do |v|
  if v.nil?
    puts "Please configure your variables in header.rb before running this script."
    exit
  end
end
puts "OK\n\n"
#Get the resulting filename that we're exporting to
output_file = OUTPUT_FILE
if USE_TIMESTAMP == true
  output_file << Time.now.strftime("_%m_%d_%Y")
end
output_file << ".csv"
puts "Will be exporting to #{output_file}.\n\n"

start_date = Time.at(Time.now.to_i - ((ARGV[0] || TIME_INTERVAL).to_i * 3600 * 24))
puts "Gathering charges that happened since #{start_date.strftime("%m-%d-%Y")}:"

# get all the charges
charges = Array.new
offset = 0
begin
  print "Pulling charge chunk #{offset + 1}-#{offset + COUNT}..."
  all_charges = Stripe::Charge.all(offset: offset, count: COUNT, :expand => ['data.customer'], :created => {:gte => start_date.to_i})
  puts "OK.\n\n"
  while offset <= all_charges.count
    all_charges.data.each do |c|
      charges.push c
    end
    offset += COUNT
    if offset <= all_charges.count
      sleep WAITING_INTERVAL
      print "Pulling charge chunk #{offset + 1}-#{offset + COUNT}..."
      all_charges = Stripe::Charge.all(offset: offset, count: COUNT, :expand => ['data.customer'], :created => {:gte => start_date.to_i})
      puts "OK.\n\n"
    end
  end
rescue Stripe::StripeError => e
  puts "There was an error connecting to stripe. Please ensure that you've entered the correct secret key. Error: #{e.message}"
  exit
end
print "Finished gathering #{charges.count} charges.\n\n"

def cents_to_dollars(value)
  if value != 0
    val = value.to_s[0..-3] + "." + value.to_s[-2..-1]
    val.to_f
  else
    value
  end
end

def xero_date(date_obj)
  if !date_obj.respond_to? :year
    date_obj = Time.at date_obj
  end
  return "#{"%02d" % date_obj.month}/#{"%02d" % date_obj.day}/#{date_obj.year}"
end

puts "Writing #{output_file}:"

CSV.open(output_file, 'wb', row_sep: "\r\n") do |csv|
  csv << ['ContactName','EmailAddress', 'POCountry', 'InvoiceNumber', 'InvoiceDate', 'Description', 'Quantity', 'UnitAmount', 'AccountCode','Reference']
  charges.each do |charge|
    if charge.paid
      paid_charges_count += 1
      contact_name = (charge.customer ? charge.customer.id : 'removed')
      if charge.customer
        email = charge.customer.email if charge.customer.respond_to? :email
      end
      if charge.customer and charge.customer.cards and charge.customer.cards.count > 0
        country = charge.customer.cards.data.last.country
      end
      date = xero_date charge.created
      #
      #NOTE: RepairTech uses the description field to ascertain which product the charge is for, please adjust
      #      this accordingly for your needs.
      #
      if charge.description.nil? or charge.description.empty?
        description = "TechSuite"
      else
        description = "ROB"
      end
      amount = cents_to_dollars charge.amount - charge.amount_refunded
      reference = charge.id
      discount = 'none'
      if charge.customer and charge.customer.discount
        discount = charge.customer.discount.coupon.id
      end
      quantity = 1

      csv << [contact_name,email,country,reference,date,description,quantity,amount,ACCOUNT_CODE,discount] if contact_name
    end
  end
end
puts "Finished creating #{output_file} based on #{paid_charges_count} paid charges."
