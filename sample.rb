require 'json'
require_relative 'scrapper'

def process_html(url, html)
  if html
    puts "#{url}. Title #{html.to_s[/(?<=<title>)(.+)(?=<\/title>)/]}"
  else
    puts "#{url}. No content"
  end
end

def save_cache_to_json(html_cache, file_name)
  File.open(file_name, 'w') do |f|
    f.write(JSON.pretty_generate(html_cache))
  end
end

url_list = File.read('url_list.example').split

cache = Scrapper.new(processor: :process_html).scrape(url_list)

save_cache_to_json(cache, 'sample_cache.json')
