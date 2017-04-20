class Incbisa
  vattr_initialize :start

  def run
    position = start
    step = 1
    last_failed = 0

    loop do
      if yield(position)
        last_succeeded = position
        if last_failed == position + 1
          return position
        end
        step *= 2

        position += step
      else
        last_failed = position
        step /= 2 if step > 1

        position -= step
      end
    end
  end
end
