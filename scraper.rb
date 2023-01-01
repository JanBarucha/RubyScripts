# frozen_string_literal: false


require 'net/http'
require 'json'


web_url = URI("https://www.reddit.com/r/subreddit.json")
web_endpoint = URI("https://webhook.site/ff8e6c91-9c4e-4820-bf58-c01fa25a5b29")

if not ARGV[0]
  puts "Default web urls will be used "

elsif ARGV[0].include?("https://") and ARGV[1] && ARGV[1].include?("https://")
  web_url = URI(ARGV[0])
  web_endpoint = URI(ARGV[1])

  puts "Web url set to " + ARGV[0]
  puts "Web endpoint set to " + ARGV[1]

elsif ARGV[0] or ARGV[1]
  puts "Problem with input urls check urls, I'm done"
  exit 1
end


http = Net::HTTP.new(web_endpoint.host,web_endpoint.port)
http.use_ssl = true
request_post = Net::HTTP::Post.new(web_endpoint)
request_post["Content-Type"] = "text/plain"

output = ""



=begin
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
=end

def send_requ(output,request_post,http)
  j_data =  output.to_json
  request_post.body = j_data
  response_post = http.request(request_post)

end


loop do
  response = Net::HTTP.get_response(web_url)

  if response.code == '429'
    puts 'Too many req, next fetch in 60 second.....'
  else

  data = JSON.parse(response.body)
  #rec_looking(data, output)

  data['data']['children'].each do |item|
    output << "title: #{item['data']['title']}  url: #{item['data']['url']} \n"
    end

  puts output
  if output.length > 0
    send_requ(output,request_post,http)
    end
  end

  #if response.code == '200'
  # break
  #end
  #
  sleep 60
end


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





