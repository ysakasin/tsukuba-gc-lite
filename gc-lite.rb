# frozen_string_literal: true

# --------------------------------------------- #
#  gc-lite.rb
#
#  MIT License
#  Copyright (c) 2017 SAKATA Sinji
#
#  https://github.com/ysakasin/tsukuba-gc-lite
# --------------------------------------------- #

require "date"
require "json"
require "icalendar"

module Tsukuba
  module GC; end
end

class Tsukuba::GC::Lite
  TYPES_JA = {
    none: "収集なし",
    burnable: "燃やせるごみ",
    used_paper: "古紙・古衣",
    glass: "びん・スプレー容器",
    spray: "びん・スプレー容器",
    pet: "ペットボトル",
    oversized: "粗大ごみ",
    cans: "かん",
    non_burnale: "燃やせないごみ",
  }.freeze

  def self.generate(seed_path)
    self.new(seed_path).dump
  end

  def self.generate_ics(seed_path)
    self.new(seed_path).dump_ics
  end

  def initialize(seed_path)
    seed_json = File.read(seed_path)
    seed = JSON.parse(seed_json)

    year = seed["year"]
    @cycle = seed["cycle"].map do |week|
      week.map(&:to_sym).freeze
    end.freeze
    @special_case = {}
    seed["special case"].each do |date_str, type|
      date = Date.parse(date_str)
      @special_case[date] = type.to_sym
    end
    @special_case.freeze

    first = Date.new(year, 4, 1)
    last = Date.new(year + 1, 3, 31)
    @period = first..last

    @counter = Array.new(7, 0)
  end

  def make_calendar
    return @result_obj if @result_obj
    @result_obj = {}

    @period.each do |date|
      w = @cycle[date.wday]
      count = @counter[date.wday]

      type = w[count % w.size]

      if @special_case[date]
        type = @special_case[date]
      else
        @counter[date.wday] += 1
      end

      @result_obj[date.to_s] = TYPES_JA[type]
    end
    @result_obj
  end

  def dump
    calendar = make_calendar()
    JSON.pretty_generate(calendar) + "\n"
  end

  def dump_ics
    calendar = make_calendar()
    ics = Icalendar::Calendar.new
    calendar.each do |date, type|
      if type == TYPES_JA[:none]
        next
      end

      ics.event do |e|
        e.dtstart = Icalendar::Values::Date.new(Date.parse(date))
        e.summary = type
      end
    end

    ics.to_ical
  end
end

def print_usage
  puts "Usage: ruby gc-lite.rb FORMAT SEED_FILE [dest]"
  puts "  If dest are omitted, it prints result to stdout."
  puts "Formats:"
  puts "  json, ics"
end


if __FILE__ == $0
  mode = ARGV[0]
  seed = ARGV[1]
  dest = ARGV[2]

  if seed.nil?
    print_usage()
    exit
  end


  case mode
  when "json" then
    str = Tsukuba::GC::Lite.generate(seed)
  when "ics" then
    str = Tsukuba::GC::Lite.generate_ics(seed)
  else
    puts "Error: unknown format"
    puts ""
    print_usage()
    exit
  end

  if dest
    File.write(dest, str)
  else
    print str
  end
end
