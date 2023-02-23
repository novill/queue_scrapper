Test task for Salt Egde https://www.saltedge.com/

The task was rejected without any explanation.

# Queue scrapper

Implement a simple web scraper that takes a list of URLs and retrieves the HTML content of each
page. The scraper should be able to handle large lists of URLs efficiently by using queue threads.

**Specific features of the scraper could include:**

● A queue of URLs to be processed. The queue should be processed by a fixed number of threads,
each of which retrieves the HTML content of the next URL in the queue and stores it in a local
cache.

● A cache of HTML content that is stored locally on the machine running the scraper. This cache
should be used to store the HTML content of each URL that has been processed, so that the same
URL is not processed multiple times.

● A way to limit the number of URLs that are processed in a given time period, to avoid overloading
the server being scraped. This could be implemented using a rate limiter or a delay between
requests.

● A way to handle errors that occur during scraping, such as connection timeouts or HTTP errors. The
scraper should be able to retry failed requests a certain number of times before giving up.

● A way to process the HTML content of each page after it has been retrieved. This could involve
parsing the HTML to extract specific pieces of information, or storing the HTML in a database for
later analysis.

Usage example see in sample.rb
