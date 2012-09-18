require 'fileutils'
class HaterChecker < Squarebot::Plugin
  FILE = File.join(Squarebot.root, 'hatercounter.json')
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
      top = ["TOP"] + @data.sort_by{|k,v| -v}.take(5).map{|k,v| "#{Campfire.user(k.to_i)['name']}: #{v}"}
      return top
    end
    nil
  end

  def react(message, user, options)
    id = user.to_s
    if (message.include?("--"))
      initialize()
      minus = /(--)+/
      matches = message.match(/([^+-:\s\n]+)(#{minus})/)
      if (matches)
        puts id
        @data[id] += 1
        persist
      end
    end
    nil
  end

end
