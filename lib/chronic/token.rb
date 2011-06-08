module Chronic
  class Token

    # @return [String] The word this Token represents
    attr_accessor :word

    # @return [Array] A list of tag associated with this Token
    attr_accessor :tags

    def initialize(word)
      @word = word
      @tags = []
    end

    # Tag this token with the specified tag
    #
    # @param [Tag] new_tag An instance of {Tag} or one of its subclasses
    def tag(new_tag)
      @tags << new_tag
    end

    # Remove all tags of the given class
    #
    # @param [Class] The tag class to remove
    def untag(tag_class)
      @tags.delete_if { |m| m.kind_of? tag_class }
    end

    # @return [Boolean] true if this token has any tags
    def tagged?
      @tags.size > 0
    end

    # @param [Class] tag_class The tag class to search for
    # @return [Tag] The first Tag that matches the given class
    def get_tag(tag_class)
      @tags.find { |m| m.kind_of? tag_class }
    end

    # Print this Token in a pretty way
    def to_s
      @word << '(' << @tags.join(', ') << ') '
    end
  end
end