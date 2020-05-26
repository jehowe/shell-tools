#!/bin/bash

#-------SES Mail Generator---------------------------------------------------#
# Date: 02/24/2020  Auth: jeff@jhowe.net                                     #     
# Simple method to genetate email to a single recipient via bash script.     #
# Edit the 'to', 'from', aws credentials, loop count & AWS region.           #
#----------------------------------------------------------------------------#

x=1
while [ $x -le 3600 ]  # edit value to determine how much email will be generated
do
  #-----SES Sendmail Function------
  TO="Mail Recipient <recipient@example.com>"
  FROM="SES Sender<sender@example.com>"
  SUBJECT="SES message"
  MESSAGE="Test message, that is all."

  date="$(date -R)"
  priv_key="AWS SECRET KEY"
  access_key="AWS ACCESS KEY"
  signature="$(echo -n "$date" | openssl dgst -sha256 -hmac "$priv_key" -binary | base64 -w 0)"
  auth_header="X-Amzn-Authorization: AWS3-HTTPS AWSAccessKeyId=$access_key, Algorithm=HmacSHA256, Signature=$signature"
  endpoint="https://email.us-east-1.amazonaws.com/"

  action="Action=SendEmail"
  source="Source=$FROM"
  to="Destination.ToAddresses.member.1=$TO"
  subject="Message.Subject.Data=$SUBJECT"
  message="Message.Body.Text.Data=$MESSAGE"

  curl -v -X POST -H "Date: $date" -H "$auth_header" --data-urlencode "$message" --data-urlencode "$to" --data-urlencode "$source" --data-urlencode "$action" --data-urlencode "$subject"  "$endpoint"
  #-----End of function--------
  x=$(( $x + 1 ))
  sleep 1s
done

exit
