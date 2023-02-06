require 'open-uri'
require 'thread'

# The number of threads to use for processing the queue
NUM_THREADS = 1

# The number of retries for failed requests
MAX_RETRIES = 3

# The rate limit for requests (in seconds)
RATE_LIMIT = 1

# A local cache to store the HTML content of each URL
$html_cache = {}

# A queue of URLs to be processed
$url_queue = Queue.new

# A lock to synchronize access to the cache
$cache_lock = Mutex.new

def process_html(html)
  if html
    puts "Process the content. Title #{html.to_s[/(?<=<title>)(.+)(?=<\/title>)/]}"
  else
    puts "No content"
  end
end

def fetch_html(url, retries = 0)
  begin
    URI.open(url).read
  rescue StandardError => e
    if retries < MAX_RETRIES
      sleep(RATE_LIMIT)
      fetch_html(url, retries + 1)
    else
      puts "Error retrieving HTML for URL: #{url} #{e.message}"
      nil
    end
  end
end

def worker
  # Worker thread to process the queue
  while true
    url = $url_queue.pop(true) rescue break
    is_new = false

    $cache_lock.synchronize do
      is_new = $html_cache.key?(url)
      $html_cache[url] = 'fetching is in progress' unless is_new
    end

    next if is_new

    html = fetch_html(url)

    $cache_lock.synchronize do
      $html_cache[url] = html
    end

    process_html($html_cache[url])
  end
end

def start_workers
  Array.new(NUM_THREADS) { Thread.new { worker } }
end

def scrape(url_list)
  url_list.each { |url| $url_queue << url }
  threads = start_workers
  threads.each { |thr| thr.join }
  puts "URL list"
  $html_cache.each { |k, v| puts "#{k}. #{v.to_s.size}"}; nil
end
