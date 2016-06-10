class SequenceFinder
  VERSION = '1.0.0'
  attr_reader :source, :sequence

  def initialize(source, sequence)
    @source   = source
    @sequence = sequence
  end

  def ranges
    starting_indexes.map { |start_index| range_for_start_index(start_index) }
  end

  def sequences(mapping=source)
    ranges.map { |r| mapping[r] }
  end

  private

  def starting_indexes
    (token_positions[sequence.first] || []).
      select { |i| sequence == source[range_for_start_index(i)] }
  end

  def range_for_start_index(start_index)
    end_offset = sequence.size-1
    start_index..start_index+end_offset
  end

  def token_positions
    {}.tap do |memo|
      source.each_with_index { |value, index| (memo[value] ||= []) << index }
    end
  end
end

module SequenceFinderExtension
  def sequence(list)
    SequenceFinder.new(self, list)
  end
end

Array.send(:include, SequenceFinderExtension)
