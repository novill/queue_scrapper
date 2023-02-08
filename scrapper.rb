require 'open-uri'
require 'thread'

class Scrapper
  def initialize(processor:, max_threads: 10, max_retries: 3, rate_limit: 1)
    @max_threads = max_threads
    @max_retries = max_retries
    @rate_limit = rate_limit
    @html_cache = {}
    @url_queue = Queue.new
    @cache_lock = Mutex.new
    @processor = processor
  end

  def scrape(url_list)
    url_list.each { |url| @url_queue << url }
    threads = start_workers
    threads.each(&:join)
    @html_cache
  end

  private

  def start_workers
    Array.new(@max_threads) { Thread.new { worker } }
  end

  def worker
    loop do
      url = @url_queue.pop(true) rescue break
      is_new = false
      @cache_lock.synchronize do
        is_new = @html_cache.key?(url)
        @html_cache[url] = 'fetching is in progress' unless is_new
      end

      next if is_new

      html = fetch_html(url)
      @cache_lock.synchronize do
        @html_cache[url] = html
      end
      method(@processor).call(url, @html_cache[url])
    end
  end

  def fetch_html(url, retries = 0)
    begin
      URI.open(url).read
    rescue StandardError => e
      if retries < @max_retries
        sleep(@rate_limit)
        fetch_html(url, retries + 1)
      else
        puts "Error retrieving HTML for URL: #{url} #{e.message}"
        nil
      end
    end
  end
end
