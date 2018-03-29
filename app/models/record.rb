class Record < ApplicationRecord
  has_many :chunks
  accepts_nested_attributes_for :chunks

  def distribution
    chunk_data
  end

  def average_rate
    # * 1000 because miliseconds
    ((chunks.count.to_f / len.to_f) * 1000).round(2)
  end

  private

  def len
    fst = chunks.first.start_at
    last = chunks.last.start_at
    last - fst
  end

  def chunk_data
    t = chunks.map(&:start_at)
    s = chunks.map(&:source)

    # Dirty, to make more clear need rethink record/chunk structure
    timings = t.map.with_index do |_, index|
      [ s[index],
        t[index+1] - t[index],
      ] if t[index+1]
    end.compact

    result = timings.group_by(&:first).map do |k, v|
      [k, v.map(&:last).inject(:+)]
    end

    result.map do |r|
      [r[0], percent_at(r[1])]
    end
  end

  def percent_at amount
    (amount.to_f * 100 / len).round(2)
  end
end
