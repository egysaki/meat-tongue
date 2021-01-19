require 'line/bot'

module Line
  module Bot
    class HTTPClient
      def http(uri)
        proxy = URI(ENV["FIXIE_URL"])
        http = Net::HTTP.new(uri.host, uri.port, proxy.host, proxy.port, proxy.user, proxy.password)
        if uri.scheme == "https"
          http.use_ssl = true
        end

        http
      end
    end
  end
end

class WebhookController < ApplicationController
  protect_from_forgery except: :callback

  CHANNEL_SECRET = ENV['MEAT_TONGUE_CHANNEL_SECRET']
  CHANNEL_ACCESS_TOKEN = ENV['MEAT_TONGUE_CHANNEL_ACCESS_TOKEN']

  def callback
    unless is_validate_signature
      head 470
    end

    client = Line::Bot::Client.new { |config|
      config.channel_secret = CHANNEL_SECRET
      config.channel_token = CHANNEL_ACCESS_TOKEN
    }

    body = request.body.read
    events = client.parse_events_from(body)

    events.each do |event|
      case event 
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          url = root_url(only_path: false)

          text = event.message['text']
          meat = Meat.find_by_name(text)

          message = {}

          if meat
            contents = meat.return_contents

            message = {
              type: 'flex',
              altText: "#{meat.name} について",
              contents: contents
            }
          else
            message = {
              type: 'text',
              text: 'ちょっと何言ってるか分からない。'
            }
          end

          response = client.reply_message(event['replyToken'], message)
          puts response
        end
      end
    end
    head :ok
  end

  private

  def is_validate_signature
    signature = request.headers["X-LINE-Signature"]
    http_request_body = request.raw_post
    hash = OpenSSL::HMAC::digest(OpenSSL::Digest::SHA256.new, CHANNEL_SECRET, http_request_body)
    signature_answer = Base64.strict_encode64(hash)
    signature == signature_answer
  end

end
