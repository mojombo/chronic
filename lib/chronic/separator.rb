module Chronic

  class Separator < Tag #:nodoc:
    def self.scan(tokens)
      tokens.each_index do |i|
        if t = self.scan_for_commas(tokens[i]) then tokens[i].tag(t); next end
        if t = self.scan_for_slash_or_dash(tokens[i]) then tokens[i].tag(t); next end
        if t = self.scan_for_at(tokens[i]) then tokens[i].tag(t); next end
        if t = self.scan_for_in(tokens[i]) then tokens[i].tag(t); next end
      end
      tokens
    end
    
    def self.scan_for_commas(token)
      scanner = {/^,$/ => :comma}
      scanner.keys.each do |scanner_item|
        return SeparatorComma.new(scanner[scanner_item]) if scanner_item =~ token.word
      end
      return nil
    end
    
    def self.scan_for_slash_or_dash(token)
      scanner = {/^-$/ => :dash,
                 /^\/$/ => :slash}
      scanner.keys.each do |scanner_item|
        return SeparatorSlashOrDash.new(scanner[scanner_item]) if scanner_item =~ token.word
      end
      return nil
    end
    
    def self.scan_for_at(token)
      scanner = {/^(at|@)$/ => :at}
      scanner.keys.each do |scanner_item|
        return SeparatorAt.new(scanner[scanner_item]) if scanner_item =~ token.word
      end
      return nil
    end
    
    def self.scan_for_in(token)
      scanner = {/^in$/ => :in}
      scanner.keys.each do |scanner_item|
        return SeparatorIn.new(scanner[scanner_item]) if scanner_item =~ token.word
      end
      return nil
    end
    
    def to_s
      'separator'
    end
  end
  
  class SeparatorComma < Separator #:nodoc:
    def to_s
      super << '-comma'
    end
  end
  
  class SeparatorSlashOrDash < Separator #:nodoc:
    def to_s
      super << '-slashordash-' << @type.to_s
    end
  end
  
  class SeparatorAt < Separator #:nodoc:
    def to_s
      super << '-at'
    end
  end
  
  class SeparatorIn < Separator #:nodoc:
    def to_s
      super << '-in'
    end
  end

end