require 'discordrb'
require 'dotenv'
Dotenv.load
bot = Discordrb::Bot.new token: ENV['TOKEN']

$twitter_link_regexp = /https:\/\/twitter\.com\/\S{1,}|https:\/\/x.com\/\S{1,}/i
$twitter_domains_regexp = /x|twitter/i

def fix_message_with_twitter(message, event)
  matched = message.scan($twitter_link_regexp)
  return unless matched.length&.positive?

  # deleter = matched.length > 1

  if deleter
    event.respond "<@#{event.message.author.id}> sent :\n#{message.gsub($twitter_domains_regexp, "fxtwitter")}"
    event.message.delete
  else
    response = "fxtwitter > twitter.\n#{matched.map{|mes| mes.gsub($twitter_domains_regexp, 'fxtwitter')}.join("\n")}"
    event.respond response
  end
end

bot.message() do |event|
  message_content = event.message.content
  fix_message_with_twitter(message_content, event)
end




bot.run
