class Partitioner
  vattr_initialize :words

  def partition(start = 1)
    size = start
    found = true

    size = Incbisa.new(start).run do |current_size|
      ngrams = words.ngrams(current_size)

      last = ngrams.counts.sort_by(&:last).last
      ngrams.counts.sort_by(&:last).last.last > 1
    end

    ngrams = words.ngrams(size)
    stats = ngrams.counts
    ngrams.each do |ngram|
      next unless ngram.size > 1 || ngrams.any? { |n| n.is_a?(Array) }
      if stats[ngram] > 1
        replacement = ngram
        while range = words.sequence(ngram).ranges.first
          words[range] = [replacement]
        end
      end
    end

    size - 1
  end
end
