# run "scrapy runspider news_crawler.py -o output.csv

import scrapy

from scrapy.spiders import CrawlSpider, Rule
from scrapy.linkextractors import LinkExtractor

# NewsArticle class represents the object obtained by the spider
class NewsArticle(scrapy.Item):
    title = scrapy.Field()
    link = scrapy.Field()
    site = scrapy.Field()

# Spider that scrapes articles for news sites
class NewsSpider(CrawlSpider):
    name = 'newsspider'
    start_urls = ['https://www.yahoo.com/news/',
                  'http://www.nytimes.com',
                  'http://www.washingtonpost.com',
                  'https://news.google.com/',
                  'http://www.huffingtonpost.com/',
                  'http://www.cnn.com/',
                  'http://www.foxnews.com/',
                  'http://www.nbcnews.com/',
                  'http://www.dailymail.co.uk/ushome/index.html',
                  'https://www.theguardian.com/us',
                  'https://www.wsj.com/',
                  'http://abcnews.go.com/',
                  'http://www.bbc.com/news',
                  'https://www.usatoday.com/',
                  'http://www.latimes.com/']

    def parse(self, response):
        for url in response.xpath('//a'):
            news = NewsArticle()

            news['title'] = url.xpath('text()').extract()
            news['link'] = url.xpath('@href').extract()
            news['site'] = url.xpath('//title/text()').extract()

            yield news


