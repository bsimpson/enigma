require_relative './wheel'

class Enigma
  attr_accessor :wheel_one, :wheel_two, :wheel_three

  def initialize
    @wheel_one = Wheel.new
    @wheel_two = Wheel.new(@wheel_one)
    @wheel_three = Wheel.new(@wheel_two)
  end

  def increment!
    @wheel_three.increment!
    self
  end
end
