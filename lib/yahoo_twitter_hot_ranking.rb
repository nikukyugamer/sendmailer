require 'mechanize'

class YahooTwitterHotRanking
  attr_reader :body, :last_updated_at

  def ranking_page
    agent = Mechanize.new

    ranking_uri = 'https://searchranking.yahoo.co.jp/realtime_buzz/'
    @ranking_page = agent.get(ranking_uri)
  end

  def last_updated_at
    @ranking_page.search('//*[@id="main"]/header/div/div[2]/div/p').text
  end

  def ranking_word(rank_number)
    ranking_word = ''
    (1..rank_number).each do |rank|
      key_word = @ranking_page.search(%Q(//*[@id="main"]/div/ul/li[#{rank}]/h3/a)).text
      ranking_word += "#{rank}位: #{key_word}\n"
    end

    ranking_word
  end

  def body(rank_number)
    <<~EOM
      #{ranking_word(rank_number).chomp}
      https://searchranking.yahoo.co.jp/realtime_buzz/
    EOM
  end

  def yahoo_twitter_hot_ranking(rank_number)
    ranking_page
    @last_updated_at = last_updated_at
    @body = body(rank_number)
  end
end
