require_relative './rotor'
require_relative './event_handler'
require 'ostruct'

class Enigma
  attr_accessor :event_handler

  def initialize
    @event_handler = EventHandler.new
    @rotor_one = Rotor.new(event_handler: event_handler)
    @rotor_two = Rotor.new(event_handler: event_handler)
    @rotor_three = Rotor.new(event_handler: event_handler)

    @event_handler.rotors = [@rotor_one, @rotor_two, @rotor_three]
  end

  def set_rotors(one=RotorMapping::IC.mapping, two=RotorMapping::IIC.mapping, three=RotorMapping::IIIC.mapping)
    @rotor_one.mapping = one.dup
    @rotor_two.mapping = two.dup
    @rotor_three.mapping = three.dup
  end

  def set_positions(one=0, two=0, three=0)
    [@rotor_three, @rotor_two, @rotor_one].map(&:reset)

    @rotor_three.position = three
    @rotor_two.position = two
    @rotor_one.position = one
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

  module RotorMapping
    def self.char_code(char)
      ::Enigma.new.char_code(char)
    end

    IC, IIC, IIIC, RocketI, RocketII, RocketIII, RocketUKW, RocketETW, IK, IIK, IIIK, UKWK, ETWK, I, II, III, IV, V, VI,
    VII, VIII, Beta, Gamma, ReflectorA, ReflectorB, ReflectorC, ReflectorBThin, ReflectorCThin, ETW = 
    *[
      { mapping: "DMTWSILRUYQNKFEJCAZBPGXOHV", date: "1924"            , name: "Commercial Enigma A, B" }  ,
      { mapping: "HQZGPJTMOBLNCIFDYAWVEUSRKX", date: "1924"            , name: "Commercial Enigma A, B" }  ,
      { mapping: "UQNTLSZFMREHDPXKIBVYGJCWOA", date: "1924"            , name: "Commercial Enigma A, B" }  ,
      { mapping: "JGDQOXUSCAMIFRVTPNEWKBLZYH", date: "7 February 1941" , name: "German Railway (Rocket)" } ,
      { mapping: "NTZPSFBOKMWRCJDIVLAEYUXHGQ", date: "7 February 1941" , name: "German Railway (Rocket)" } ,
      { mapping: "JVIUBHTCDYAKEQZPOSGXNRMWFL", date: "7 February 1941" , name: "German Railway (Rocket)" } ,
      { mapping: "QYHOGNECVPUZTFDJAXWMKISRBL", date: "7 February 1941" , name: "German Railway (Rocket)" } ,
      { mapping: "QWERTZUIOASDFGHJKPYXCVBNML", date: "7 February 1941" , name: "German Railway (Rocket)" } ,
      { mapping: "PEZUOHXSCVFMTBGLRINQJWAYDK", date: "February 1939"   , name: "Swiss K" }                 ,
      { mapping: "ZOUESYDKFWPCIQXHMVBLGNJRAT", date: "February 1939"   , name: "Swiss K" }                 ,
      { mapping: "EHRVXGAOBQUSIMZFLYNWKTPDJC", date: "February 1939"   , name: "Swiss K" }                 ,
      { mapping: "IMETCGFRAYSQBZXWLHKDVUPOJN", date: "February 1939"   , name: "Swiss K" }                 ,
      { mapping: "QWERTZUIOASDFGHJKPYXCVBNML", date: "February 1939"   , name: "Swiss K" }                 ,
      { mapping: "EKMFLGDQVZNTOWYHXUSPAIBRCJ", date: "1930"            , name: "Enigma I" }                ,
      { mapping: "AJDKSIRUXBLHWTMCQGZNPYFVOE", date: "1930"            , name: "Enigma I" }                ,
      { mapping: "BDFHJLCPRTXVZNYEIWGAKMUSQO", date: "1930"            , name: "Enigma I" }                ,
      { mapping: "ESOVPZJAYQUIRHXLNFTGKDCMWB", date: "December 1938"   , name: "M3 Army" }                 ,
      { mapping: "VZBRGITYUPSDNHLXAWMJQOFECK", date: "December 1938"   , name: "M3 Army" }                 ,
      { mapping: "JPGVOUMFYQBENHZRDKASXLICTW", date: "1939"            , name: "M3 & M4 Naval (FEB 1942)" },
      { mapping: "NZJHGRCXMYSWBOUFAIVLPEKQDT", date: "1939"            , name: "M3 & M4 Naval (FEB 1942)" },
      { mapping: "FKQHTLXOCBJSPDZRAMEWNIUYGV", date: "1939"            , name: "M3 & M4 Naval (FEB 1942)" },
      { mapping: "LEYJVCNIXWPBQMDRTAKZGFUHOS", date: "Spring 1941"     , name: "M4 R2" }                   ,
      { mapping: "FSOKANUERHMBTIYCWLQPZXVGJD", date: "Spring 1942"     , name: "M4 R2" }                   ,
      { mapping: "EJMZALYXVBWFCRQUONTSPIKHGD", date: nil               , name: nil }                       ,
      { mapping: "YRUHQSLDPXNGOKMIEBFZCWVJAT", date: nil               , name: nil }                       ,
      { mapping: "FVPJIAOYEDRZXWGCTKUQSBNMHL", date: nil               , name: nil }                       ,
      { mapping: "ENKQAUYWJICOPBLMDXZVFTHRGS", date: "1940"            , name: "M4 R1 (M3 + Thin)" }       ,
      { mapping: "RDOBJNTKVEHMLFCWZAXGYIPSUQ", date: "1940"            , name: "M4 R1 (M3 + Thin)" }       ,
      { mapping: "ABCDEFGHIJKLMNOPQRSTUVWXYZ", date: nil               , name: "Enigma I" }                ,
    ].map { |rotor| rotor[:mapping].split("").map {|x| char_code(x)}.freeze }
  end
end
