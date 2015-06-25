# coding: utf-8
import twitter #pip install python-twitter
import sys

#argument à passer au script
# exemple : python twitter_crawler.py anoltami
username = sys.argv[1]
print username

api = twitter.Api(consumer_key="Ym4Sr5MF0ql6inVq2mM3mkisZ",
consumer_secret="XjjE98AurxGqtfS3JGp4wweE3HD5HisJ8awfkltZVKfusAUDdK",
access_token_key="3094543072-iNQRGSIgcrZWGKaq1k50q15fbgkcqUoA2aALkUD",
access_token_secret="Ug2L5EdqbS18fCaChXcGBjTIVRVlPv2zNYPRQmoPZnMsC")

user = api.GetUser(screen_name=username)
print "id : %s" % user.id
print "name : %s" % user.name
print "screen_name : %s" % user.screen_name
print "location : %s" % user.location
print "description : %s" % user.description
print "follower count : %s" % user.followers_count
followers = api.GetFollowers(screen_name=username)
for f in followers:
    print f.name

print "friends count : %s" % user.friends_count
friends = api.GetFriends(screen_name=username)
for f in friends:
    print f.name
