module Chronic

  class Separator < Tag #:nodoc:
    def self.scan(tokens)
      tokens.each_index do |i|
        if t = self.scan_for_commas(tokens[i]) then tokens[i].tag(t); next end
        if t = self.scan_for_slash_or_dash(tokens[i]) then tokens[i].tag(t); next end
        if t = self.scan_for_at(tokens[i]) then tokens[i].tag(t); next end
        if t = self.scan_for_in(tokens[i]) then tokens[i].tag(t); next end
        if t = self.scan_for_on(tokens[i]) then tokens[i].tag(t); next end
      end
    end

    def self.scan_for_commas(token)
      {
        /^,$/ => :comma
      }.each do |item, symbol|
        return SeparatorComma.new(symbol) if item =~ token.word
      end
      return nil
    end

    def self.scan_for_slash_or_dash(token)
      {
        /^-$/ => :dash,
        /^\/$/ => :slash
      }.each do |item, symbol|
        return SeparatorSlashOrDash.new(symbol) if item =~ token.word
      end
      return nil
    end

    def self.scan_for_at(token)
      {
        /^(at|@)$/ => :at
      }.each do |item, symbol|
        return SeparatorAt.new(symbol) if item =~ token.word
      end
      return nil
    end

    def self.scan_for_in(token)
      {
        /^in$/ => :in
      }.each do |item, symbol|
        return SeparatorIn.new(symbol) if item =~ token.word
      end
      return nil
    end

    def self.scan_for_on(token)
      {
        /^on$/ => :on
      }.each do |item, symbol|
        return SeparatorOn.new(symbol) if item =~ token.word
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

  class SeparatorOn < Separator #:nodoc:
    def to_s
      super << '-on'
    end
  end

end
