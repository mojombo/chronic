require 'active_support/core_ext'

module Chronic
  class Locale

    AVAILABLE = [:en, :ru]

    def [](path)
      path.to_s.split('.').reduce(self.class::LOCALE_HASH) do |value, element|
        value[element.to_sym] || {}
      end
    end

    class << self
      def by_name(name)
        raise "Unknown locale #{name}. Available: #{AVAILABLE}" unless AVAILABLE.include?(name)
        klass = "Chronic::Locale::#{name.to_s.camelize}".constantize
        klass.new
      end

      def default
        by_name(:en)
      end
    end
  end
end
