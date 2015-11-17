import sys
import json
import codecs
import re
from collections import Counter

def hw(sentiments, tweets):
  afinnfile = open(sentiments)
  scores = {}

  for line in afinnfile:
    term, score = line.split('\t')
    scores[term] = int(score)
  afinnfile.close()

  tweets_file = open(tweets)
  term_sents = {}

  for line in tweets_file:
    tweet = json.loads(line)#.decode('utf-8'))
    #term_sents = {}

    #Ignores retweets
    if tweet.has_key('retweeted_status'): continue

    #Ignores manual retweet
    #if tweet.has_key('text') and tweet['text'].lower().find('rt ') > -1:
      #continue
 
    for field in tweet:
      if field not in ['filter_level','text','source']: continue      
      #if field not in 'text': continue

      delimiters = '[^a-zA-Z]|[\un]|[- ]+|[\"\s\t\r\n!@#$%:;()_.=,\s]'
      list = re.split(delimiters, tweet[field].lower().encode('ascii', 'ignore'))

      count = len(list)
      if count < 1: continue
      last_i = count - 1

      for i in range(count):
        if len(list[i]) < 2: continue
        #if(list[i].isalpha == False or 
        if list[i] in scores.keys(): continue
        
        prev = ''
        next = '' 
        if ((i > 0) and (list[i - 1] in scores)):
          prev = list[i - 1]
        if ((i < last_i) and (list[i + 1] in scores)):
          next = list[i + 1]
      
        if prev != '':
          if term_sents.has_key(list[i]):
            term_sents[list[i]].append(float(scores[prev]))
          else:
            term_sents[list[i]] = [float(scores[prev])]
        if next != '':
          if term_sents.has_key(list[i]):
            term_sents[list[i]].append(float(scores[next]))
          else:
            term_sents[list[i]] = [float(scores[next])]
      
  for sent in term_sents.keys():
    print '%s %.3f\r' % (sent, float(sum(term_sents[sent]) / len(term_sents[sent])))

  tweets_file.close()

def lines(fp):
    print str(len(fp.readlines()))

def main():
    hw(sys.argv[1], sys.argv[2])

if __name__ == '__main__':
    main()
