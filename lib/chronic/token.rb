module Chronic
  class Token

    attr_accessor :word
    attr_accessor :tags

    def initialize(word)
      @word = word
      @tags = []
    end

    # Tag this token with the specified tag.
    #
    # new_tag - The new Tag object.
    #
    # Returns nothing.
    def tag(new_tag)
      @tags << new_tag
    end

    # Remove all tags of the given class.
    #
    # tag_class - The tag Class to remove.
    #
    # Returns nothing.
    def untag(tag_class)
      @tags.delete_if { |m| m.kind_of? tag_class }
    end

    # Returns true if this token has any tags.
    def tagged?
      @tags.size > 0
    end

    # tag_class - The tag Class to search for.
    #
    # Returns The first Tag that matches the given class.
    def get_tag(tag_class)
      @tags.find { |m| m.kind_of? tag_class }
    end

    # Print this Token in a pretty way
    def to_s
      @word << '(' << @tags.join(', ') << ') '
    end

    def inspect
      to_s
    end
  end
end