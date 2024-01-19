# frozen_string_literal: true

require 'discordrb'
require 'dotenv'
Dotenv.load
bot = Discordrb::Bot.new token: ENV['TOKEN']

$twitter_link_regexp = %r{https://twitter\.com/\S{1,}|https://x.com/\S{1,}}i
$twitter_domains_regexp = /x|twitter/i

def format_match_list(matches)
  "fxtwitter > twitter.\n#{matches.map do |match|
                             match.gsub($twitter_domains_regexp, 'fxtwitter')
                           end.join("\n")}"
end

def fix_message_with_twitter(event)
  message =  event.message.content
  matches = message.scan($twitter_link_regexp)
  return unless matches.length&.positive?

  deleter = false
  # deleter = matches.length > 1

  if deleter
    event.respond "<@#{event.message.author.id}> sent :\n#{message.gsub($twitter_domains_regexp, 'fxtwitter')}"
    event.message.delete
  else
    event.respond format_match_list(matches)
  end
end

bot.message do |event|
  fix_message_with_twitter(event)
end

bot.run
