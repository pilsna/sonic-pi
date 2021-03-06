#--
# This file is part of Sonic Pi: http://sonic-pi.net
# Full project source: https://github.com/samaaron/sonic-pi
# License: https://github.com/samaaron/sonic-pi/blob/master/LICENSE.md
#
# Copyright 2013, 2014 by Sam Aaron (http://sam.aaron.name).
# All rights reserved.
#
# Permission is granted for use, copying, modification, distribution,
# and distribution of modified versions of this work as long as this
# notice is included.
#++
module SonicPi
  class Note

    NOTES_TO_INTERVALS =
      {c:  0,
       cs: 1,  df: 1,  db: 1,
       d:  2,
       eb: 3,  ef: 3,  ds: 3,
       e:  4,  fb: 4,  ff: 4,
       f:  5,  es: 5,
       fs: 6,  gb: 6,  gf: 6,
       g:  7,
       gs: 8,  ab: 8,  af: 8,
       a:  9,
       bb: 10, bf: 10, as: 10,
       b:  11, cf: 11, cb: 11,
       bs: 12}

    INTERVALS_TO_NOTES = {
      0  => :C,
      1  => :Cs,
      2  => :D,
      3  => :Eb,
      4  => :E,
      5  => :F,
      6  => :Fs,
      7  => :G,
      8  => :Ab,
      9  => :A,
      10 => :Bb,
      11 => :B}

    DEFAULT_OCTAVE = 4

    attr_reader :pitch_class, :octave, :interval, :midi_note, :midi_string

    def self.resolve_midi_note(n, o=nil)
      case n
      when String
        self.new(n, o).midi_note
      when NilClass
        nil
      when Integer
        n
      when Float
        n
      when Symbol
        resolve_midi_note(n.to_s, o)
      when Array
        resolve_midi_note(n[0], n[1])
      end
    end

    def self.resolve_note_name(n, o=nil)
      note = resolve_midi_note(n, o)
      note = note % 12
      INTERVALS_TO_NOTES[note]
    end

    def initialize(n, o=nil)

      n = n.to_s
      midi_note_re = /([a-gA-G][sSbBfF]?)([-]?[-0-9]*)/
      m = midi_note_re.match n

      raise "Invalid note: #{n}" unless m
      @pitch_class = m[1].capitalize

      str_oct = m[2].empty? ? DEFAULT_OCTAVE : m[2].to_i
      @octave = o ? o.to_i : str_oct
      @interval = NOTES_TO_INTERVALS[@pitch_class.downcase.to_sym]

      raise "Invalid note: #{n}" unless @interval

      @midi_note = (@octave * 12) + @interval + 12
      @midi_string = "#{@pitch_class.capitalize}#{@interval}"
    end

    def to_s
      @midi_string
    end
  end
end
