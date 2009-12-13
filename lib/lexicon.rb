class Lexicon
  def self.parse(item)
    parsed = {
      :title => nil,
      :series => nil,
      :episode => nil,
      :size => nil,
      :publish_date => nil,
      :high_def => false
    }

    tokens = item.title.split('.')
    title = []
    state = :title
    
    while tokens.length > 0
      token = tokens.shift
      
      case(state)
      when :title
        if token =~ /s(\d+)e(\d+)/i
          parsed[:series] = Regexp.last_match[1]
          parsed[:episode] = Regexp.last_match[2]
          state = :done
        else
          title << token
        end
      when :done
        if token =~ /HDTV|720p|1080|mkv/
          parsed[:high_def] = true
        end
      end
    end
    parsed[:title] = title.join(' ')
    parsed[:publish_date] = item.pubDate if item.pubDate

    return parsed
  end
end
