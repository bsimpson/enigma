require_relative './rotor'
require_relative './event_handler'

class Enigma
  attr_accessor :event_handler

  module RotorMapping
    IC =   [3, 12, 19, 22, 18, 8, 11, 17, 20, 24, 16, 13, 10, 5, 4, 9, 2, 0, 25, 1, 15, 6, 23, 14, 7, 21].freeze
    IIC =  [7, 16, 25, 6, 15, 9, 19, 12, 14, 1, 11, 13, 2, 8, 5, 3, 24, 0, 22, 21, 4, 20, 18, 17, 10, 23].freeze
    IIIC = [20, 16, 13, 19, 11, 18, 25, 5, 12, 17, 4, 7, 3, 15, 23, 10, 8, 1, 21, 24, 6, 9, 2, 22, 14, 0].freeze
  end

  def initialize
    @event_handler = EventHandler.new
    @rotor_one = Rotor.new(event_handler: event_handler)
    @rotor_two = Rotor.new(event_handler: event_handler)
    @rotor_three = Rotor.new(event_handler: event_handler)

    @event_handler.rotors = [@rotor_one, @rotor_two, @rotor_three]
  end

  def set_rotors(one=RotorMapping::IC, two=RotorMapping::IIC, three=RotorMapping::IIIC)
    @rotor_one.mapping = one.dup
    @rotor_two.mapping = two.dup
    @rotor_three.mapping = three.dup
  end

  def set_positions(one=0, two=0, three=0)
    three.times { @rotor_three.increment }
    two.times { @rotor_two.increment }
    one.times { @rotor_one.increment }
  end

  def input(message)
    ensure_rotors_and_positions
    message = message.downcase.gsub(/[^a-z]/, '').split("").map { |char| char_code(char) }
    message.map { |char| @event_handler.input(char) }.map { |code| code_char(code) }.join
  end

  def reflect(message)
    ensure_rotors_and_positions
    message = message.downcase.gsub(/[^a-z]/, '').split("").map { |char| char_code(char) }
    message.map { |char| @event_handler.reflect(char) }.map { |code| code_char(code) }.join
  end

  def ensure_rotors_and_positions
    raise "Set your rotors first" unless @rotor_one.mapping
    raise "Set your positions first" unless @rotor_one.position
  end

  def char_code(char)
    ("a".."z").to_a.index(char.downcase)
  end

  def code_char(idx)
    ("a".."z").to_a[idx]
  end
end
