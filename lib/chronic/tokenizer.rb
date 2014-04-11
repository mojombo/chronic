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
      tokens = []
      index = 0
      previos_index = 0
      text.each_char do |char|
        type = char_type(char)
        if type == :space
          tokens << Token.new(text[previos_index...index], text, previos_index)
          previos_index = index+1
        end
        index += 1
      end
      tokens << Token.new(text[previos_index...index], text, previos_index)
      tokens
    end

  end
end