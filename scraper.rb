# frozen_string_literal: true


require 'net/http'
require 'json'

web_url = URI("https://www.reddit.com/r/subreddit.json")

web_endpoint = URI("https://webhook.site/ff8e6c91-9c4e-4820-bf58-c01fa25a5b29")

response = nil

output = {}
output["title"] = []
output["url"] = []


def rec_looking(values, some_array)
  values.each do |key, value|
    if value.is_a?(Hash)
      rec_looking(value, some_array)
    else
      if value.is_a?(Array)
        value.each do |item|
          if item.is_a?(Hash)
            rec_looking(item,some_array)
          end
        end
      end
      if key == "url"
        some_array[key] << value
      elsif key == "title"
        some_array[key] << value
        end
      end
  end
  end



loop do
  response = Net::HTTP.get_response(web_url)

  if response.code == '429'
    puts 'Too many req, next fetch in 60 second.....'
  end

  #puts response.body

  data = JSON.parse(response.body)
  rec_looking(data, output)
  puts output




  #puts response.body
  if response.code == '200'
    break
  end
  sleep 5
end

j_data =  output.to_json


http = Net::HTTP.new(web_endpoint.host,web_endpoint.port)
http.use_ssl = true

request_post = Net::HTTP::Post.new(web_endpoint)
request_post["Content-Type"] = "application/json"
request_post.body = j_data

response_post = http.request(request_post)

#resp_from_post = Net::HTTP.start(web_endpoint.hostname, web_endpoint.port) do |http |
# begin
#   http.request(request_post)

#  rescue Errno::ECONNRESET => e
#   sleep 2
#    retry
#  rescue Exception => e
#    puts "WTF : #{e.message}"
#  end
#end





