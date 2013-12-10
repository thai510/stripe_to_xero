This is a script forked from vidpresso/stripe_to_xero that is meant to pull all charges from stripe from a given time period and generate a CSV file that you
can import directly into your Xero Sales section. You can automate this very easily with rake tasks or cronjobs. At RepairTech, we use this script to
automate our accounting process.

# Purpose
At RepairTech, we believe that by automating mundane and low-level processes, we can enable people to focus on more important tasks that actually require their attention. We use both Stripe and Xero, and found that we were spending a lot of time doing data, entry, and decided to automate the process. We use this script within our rails application. Using the scheduler gem and a simple mailer we run this script once per week, and email our CFO the CSV file. He then imports it into Xero.
This saves him tons of time. We made it open-source so you could save time too. You will need to modify some of the code for your needs.

# Configuration

## Header Variables
There are variables located in header.rb that you will need to modify to make the ruby script work. There is a description for each variable in the header file. 


# Dependencies

- `stripe` gem

# Usage

Once you enter your information, you can run the script by doing the following:

ruby stripe_to_xero.rb

This will generate the CSV file.

NOTE: You can also pass the ruby file an integer as the first argument that will override TIME_INTERVAL. For example, you could run `ruby stripe_to_xero.rb 7` to set TIME_INTERVAL to 7.

# Notes

For more information about importing CSV files in stripe, see this URL: https://help.xero.com/us/#Accounts_InvoiceImport$BK_CSVCols

Requires ruby 1.9.

# License

Copyright (c) 2013, Vidpresso, Inc.
All rights reserved.

Redistribution and use in source and binary forms, with or without modification, are permitted provided that the following conditions are met:

Redistributions of source code must retain the above copyright notice, this list of conditions and the following disclaimer.
Redistributions in binary form must reproduce the above copyright notice, this list of conditions and the following disclaimer in the documentation and/or other materials provided with the distribution.
Neither the name of the company nor the names of its contributors may be used to endorse or promote products derived from this software without specific prior written permission.
THIS SOFTWARE IS PROVIDED BY THE COPYRIGHT HOLDERS AND CONTRIBUTORS "AS IS" AND ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE ARE DISCLAIMED. IN NO EVENT SHALL THE COPYRIGHT HOLDER OR CONTRIBUTORS BE LIABLE FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION) HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF SUCH DAMAGE.
