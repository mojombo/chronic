module Chronic
  class Handler
    # tokens - An Array of tokens to process.
    # token_index - Index from which token to start matching from.
    # pattern - An Array of patterns to check against. (eg. [ScalarDay, [SeparatorSpace, SeparatorDash, nil], MonthName])
    #
    # Returns true if a match is found.
    def self.match(tokens, token_index, pattern)
      count = 0
      index = 0
      pattern.each do |elements|
        elements = [elements] unless elements.is_a?(Array)
        optional = elements.include?(:optional)
        dont_match = elements.include?(:none)
        count += 1
        match = 0
        elements.each_index do |i|
          if elements[i].is_a?(Class) and self.tags_match?(elements[i], tokens, token_index + index)
            match += 1
            index += 1
            break unless dont_match
          elsif i + 1 < elements.count
            next
          else
            if optional or (dont_match and match < elements.count - 1)
              count -= 1
              index -= match
            else
              return false
            end
          end
        end
      end
      return false if index != count
      true
    end

    def self.tags_match?(klass, tokens, token_index)
      return !tokens[token_index].get_tag(klass).nil? if tokens[token_index]
      false
    end

  end
end
