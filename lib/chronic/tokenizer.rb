module Chronic
  module Tokenizer
    def self.char_type(char)
      case char
      when '.'
        :period
      when /[[:alpha:]]/
        :letter
      when /[[:digit:]]/
        :digit
      when /[[:space:]]/
        :space
      when /[[:punct:]]/
        :punct
      else
        :other
      end
    end

    # Proccess text to tokens
    def self.tokenize(text)
      alter_text = text.dup
      tokens = []
      text.split(" ").each do |sub_text|
        tokens << Token.new(sub_text, text, alter_text.index(sub_text))
        alter_text.sub!(/\#{sub_text}/, (" " * sub_text.length))
      end
      tokens
    end

  end
end
