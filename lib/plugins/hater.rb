require 'fileutils'
class HaterChecker < Squarebot::Plugin
  FILE = File.join(Squarebot.root, 'haterchecker.json')
  register self, "keeps track of who's been hatin'", "-- all the way!"

  def persist
    File.open(FILE, 'w'){|file| file.puts(@data.to_json)}
  end

  def initialize
    @parser = Yajl::Parser.new
    raw = File.exists?(FILE) ? File.open(FILE).read : "{}"
    @data = @parser.parse(raw)
  end

  def respond(message, user, options)
    initialize()
    if(message.downcase == "haters")
      top = ["TOP"] + @data.sort_by{|k,v| -v}.take(5).map{|k,v| "#{k}: #{v}"}
      return top
    end
    nil
  end

  def react(message, user, options)
    if (message.include?("--"))
      initialize()
      minus = /(--)+/
      matches = message.match(/([^+-:\s\n]+)(#{minus})/)
      if (matches)
        @data[user] ||= 0
        @data[user] += 1
        persist
	nil
      end
    end
  end

end
