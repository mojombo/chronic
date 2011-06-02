module Chronic

  class Separator < Tag #:nodoc:
    def self.scan(tokens, options)
      tokens.each_index do |i|
        if t = scan_for_commas(tokens[i]) then tokens[i].tag(t); next end
        if t = scan_for_slash_or_dash(tokens[i]) then tokens[i].tag(t); next end
        if t = scan_for_at(tokens[i]) then tokens[i].tag(t); next end
        if t = scan_for_in(tokens[i]) then tokens[i].tag(t); next end
        if t = scan_for_on(tokens[i]) then tokens[i].tag(t); next end
      end
    end

    def self.scan_for_commas(token)
      scan_for token, SeparatorComma, { /^,$/ => :comma }
    end

    def self.scan_for_slash_or_dash(token)
      scan_for token, SeparatorSlashOrDash,
      {
        /^-$/ => :dash,
        /^\/$/ => :slash
      }
    end

    def self.scan_for_at(token)
      scan_for token, SeparatorAt, { /^(at|@)$/ => :at }
    end

    def self.scan_for_in(token)
      scan_for token, SeparatorIn, { /^in$/ => :in }
    end

    def self.scan_for_on(token)
      scan_for token, SeparatorOn, { /^on$/ => :on }
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
