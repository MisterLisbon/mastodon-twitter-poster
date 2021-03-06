# frozen_string_literal: true

class TweetTransformer
  def self.replace_links(text, urls)
    urls.each do |u|
      text = text.gsub(u.url.to_s, u.expanded_url.to_s)
    end
    text
  end

  def self.replace_mentions(text)
    twitter_mention_regex = /(\s|^.?|[^A-Za-z0-9_!#\$%&*@＠\/])([@＠][A-Za-z0-9_]+)(?=[^A-Za-z0-9_@＠]|$)/
    if Rails.configuration.x.use_alternative_twitter_domain
      text.gsub(twitter_mention_regex, "\\1\\2@#{Rails.configuration.x.alternative_twitter_domain}")
    else
      text.gsub(twitter_mention_regex, '\1\2@twitter.com')
    end
  end

  def self.detect_cw(text)
    common_format = /(Cont[ée]m:|Contains:|CN:?|Spoiler:?|[CT]W:?|TW\s*[\/,]\s*CW[:,]?|CW\s*[\/,]\s*TW[:,]?)/i
    format = /\A#{common_format}\s+(?<cw>[^\n\r]+)(?:[\n\r]+|\z)(?<text>.*)/im
    rt_format = /\A#{common_format}\s+(?<cw>[^\n\r]+) (?<text>https:\/\/twitter\.com.*)/im

    m = rt_format.match(text)
    return ["RT: #{m[:text]}", m[:cw]] if m

    m = format.match(text)
    return [m[:text], m[:cw]] if m

    [text, nil]
  end
end
