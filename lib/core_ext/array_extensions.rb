module ArrayExtensions
  def self.included(base)
    base.class_eval do
      include InstanceMethods
    end
  end

  module InstanceMethods
    def ngrams(count)
      last_ngram_start = size - count

      (0..last_ngram_start).map do |start|
        self[start..start + count - 1]
      end
    end

    def counts(stats = {})
      each do |element|
        if block_given?
          key = yield(element)
        else
          key = element
        end

        stats[key] ||= 0
        stats[key] += 1
      end

      stats
    end
  end
end

Array.send(:include, ArrayExtensions)
