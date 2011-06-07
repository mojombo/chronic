module Chronic
  class Separator < Tag

    # Scan an Array of {Token}s and apply any necessary Separator tags to
    # each token
    #
    # @param [Array<Token>] tokens Array of tokens to scan
    # @param [Hash] options Options specified in {Chronic.parse}
    # @return [Array] list of tokens
    def self.scan(tokens, options)
      tokens.each do |token|
        if t = scan_for_commas(token) then token.tag(t); next end
        if t = scan_for_slash_or_dash(token) then token.tag(t); next end
        if t = scan_for_at(token) then token.tag(t); next end
        if t = scan_for_in(token) then token.tag(t); next end
        if t = scan_for_on(token) then token.tag(t); next end
      end
    end

    # @param [Token] token
    # @return [SeparatorComma, nil]
    def self.scan_for_commas(token)
      scan_for token, SeparatorComma, { /^,$/ => :comma }
    end

    # @param [Token] token
    # @return [SeparatorSlashOrDash, nil]
    def self.scan_for_slash_or_dash(token)
      scan_for token, SeparatorSlashOrDash,
      {
        /^-$/ => :dash,
        /^\/$/ => :slash
      }
    end

    # @param [Token] token
    # @return [SeparatorAt, nil]
    def self.scan_for_at(token)
      scan_for token, SeparatorAt, { /^(at|@)$/ => :at }
    end

    # @param [Token] token
    # @return [SeparatorIn, nil]
    def self.scan_for_in(token)
      scan_for token, SeparatorIn, { /^in$/ => :in }
    end

    # @param [Token] token
    # @return [SeparatorOn, nil]
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