class ReplyText < ActiveRecord::Base


  #-----------------------------------------------
  # 自動応答のためのコメント選択
  #  -> いろいろロジックを作り込みたいけど、それはまた今度...
  def self.select_auto
    feed_text = ReplyText.all.sample


    if feed_text.blank?
      return '(返事がない。ただの屍のようだ...)'
    else
      return feed_text.text
    end
  end
  
end
