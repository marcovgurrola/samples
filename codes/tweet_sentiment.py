import sys
import json
import codecs
from collections import Counter

def hw(sentiments, tweets):
  afinnfile = open(sentiments)
  scores = {}
  for line in afinnfile:
    term, score = line.split("\t")
    scores[term] = int(score)
  afinnfile.close()

  tweets_file = open(tweets)
  json_input = []

  total = 0
  for line in tweets_file:
    tweet = json.loads(line.decode('utf-8-sig'))
    if 'retweeted' in tweet:
      if tweet['retweeted'] == False:
        total = 0
        counts = Counter(tweet['text'].split())
        for word in counts:
          if word in scores:
            total += scores[word] * counts[word]
        print total

  tweets_file.close()

def lines(fp):
    print str(len(fp.readlines()))

def main():
    sent_file = sys.argv[1]
    tweet_file = sys.argv[2]
    hw(sent_file, tweet_file)
    #lines(sent_file)
    #lines(tweet_file)

if __name__ == '__main__':
    main()
