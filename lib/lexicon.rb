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

    tokens = item.title.split(/\.| /)
    title = []
    state = :title
    
    while tokens.length > 0
      token = tokens.shift
      
      case(state)
      when :title
        if token =~ /s(\d+)e(\d+)/i
          parsed[:series] = Regexp.last_match[1].to_i
          parsed[:episode] = Regexp.last_match[2].to_i
          state = :done
        elsif token =~ /^(\d)x?(\d\d)$/i
          parsed[:series] = Regexp.last_match[1].to_i
          parsed[:episode] = Regexp.last_match[2].to_i
          state = :done
        elsif token =~ /^s(\d+)$/i
          parsed[:series] = Regexp.last_match[1].to_i
          state = :series
        else
          title << token
        end
      when :series
        if token =~ /^e(\d+)$/i
          parsed[:episode] = Regexp.last_match[1].to_i
          state = :done
        end
      when :done
        if token =~ /HDTV|720p|1080|mkv/i
          parsed[:high_def] = true
        end
      end
    end

    # Reparse to look for some hd/sd info
    if state != :done
      tokens = item.title.split(/\.| /)
      title = [] if state == :title
      
      while tokens.length > 0
        token = tokens.shift
        case(state)
        when :title
          if token =~ /HDTV|720p|1080|mkv/i
            parsed[:high_def] = true
            state = :done
          else
            title << token
          end
        when :series
          if token =~ /HDTV|720p|1080|mkv/i
            parsed[:high_def] = true
            state = :done
          end
        end
      end     
    end

    # Try to split on some common lines
    if state != :done
      tokens = item.title.split(/\.| /)
      title = [] if state == :title
      
      while tokens.length > 0
        token = tokens.shift
        case(state)
        when :title
          if token =~ /vid|DVDRip|xvid|divx|repack|internal/i
            state = :done
          elsif token =~ /avi|ts|mkv|mpg/i
            state = :done
          else
            title << token
          end
        when :series
          if token =~ /vid|DVDRip|xvid|divx|repack|internal/i
            state = :done
          elsif token =~ /avi|ts|mkv|mpg/i
            state = :done
          end
        end
      end        
    end

    if state == :title
      title = item.title.split(/\.| /)
    end

    parsed[:title] = title.join(' ')
    parsed[:publish_date] = item.published if item.published
    return parsed
  end
end
