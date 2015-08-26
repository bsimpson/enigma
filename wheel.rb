class Wheel
  attr_accessor :position

  def initialize(adjacent_wheel=nil)
    @position = 1
    @adjacent_wheel = adjacent_wheel
  end

  def increment!
    if (@position % 26 == 0)
      @adjacent_wheel && @adjacent_wheel.increment!
      @position = 1
    else
      @position += 1
    end
  end

  def to_s
    { position: @position }
  end
end
