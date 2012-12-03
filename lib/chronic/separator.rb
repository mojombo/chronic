module Chronic
  class Separator < Tag

    # Scan an Array of Token objects and apply any necessary Separator
    # tags to each token.
    #
    # tokens - An Array of tokens to scan.
    # options - The Hash of options specified in Chronic::parse.
    #
    # Returns an Array of tokens.
    def self.scan(tokens, options)
      tokens.each do |token|
        if t = scan_for_commas(token) then token.tag(t); next end
        if t = scan_for_slash_or_dash(token) then token.tag(t); next end
        if t = scan_for_at(token) then token.tag(t); next end
        if t = scan_for_in(token) then token.tag(t); next end
        if t = scan_for_on(token) then token.tag(t); next end
        if t = scan_for_and(token) then token.tag(t); next end
      end
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorComma object.
    def self.scan_for_commas(token)
      scan_for token, SeparatorComma, { /^,$/ => :comma }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorSlashOrDash object.
    def self.scan_for_slash_or_dash(token)
      scan_for token, SeparatorSlashOrDash,
      {
        /^-$/ => :dash,
        /^\/$/ => :slash
      }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorAt object.
    def self.scan_for_at(token)
      scan_for token, SeparatorAt, { /^(at|@)$/ => :at }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorIn object.
    def self.scan_for_in(token)
      scan_for token, SeparatorIn, { /^in$/ => :in }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeparatorOn object.
    def self.scan_for_on(token)
      scan_for token, SeparatorOn, { /^on$/ => :on }
    end

    # token - The Token object we want to scan.
    #
    # Returns a new SeperatorAnd Object object.
    def self.scan_for_and(token)
      scan_for token, SeparatorAnd, { /^and$/ => :and }
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

  class SeparatorAnd < Separator #:nodoc:
    def to_s
      super << '-and'
    end
  end
end
