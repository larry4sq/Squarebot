require 'fileutils'
class PlusPlus < Squarebot::Plugin
  FILE = File.join(Squarebot.root, 'plusplus.json')
  register self, "plus plus, minus minus", "you know how it works"

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
    if(message.downcase == "show leaderboard" || message.downcase == "leaderboard")

      top = ["TOP"] + @data.sort_by{|k,v| v}.reverse.take(3).map{|k,v| "#{k}: #{v}"}
      top += ["BOTTOM"] + @data.sort_by{|k,v| v}.take(3).map{|k,v| "#{k}: #{v}"} if @data.size > 3
      return top
    end
    if (matches = message.downcase.match(/check ([^+-:\s\n]+)/i))
      oldname = matches[1]
      name = oldname.downcase

      if (@data[name])
        return "#{oldname} is at #{@data[name]}."
      else
        return "#{oldname} not found."
      end
    end
    nil
  end

  def react(message, user, options)
    if (message.include?("++") || message.include?("--"))
      initialize()
      plus = /(\+\+)+/
      minus = /(--)+/

      karma = ""
      message.scan(/(([^+\-\n\s\/])+)(#{plus}|#{minus})/).each do|matches|
        oldname = matches[0]
        name = oldname.downcase
	dir = matches[2]

        direction = dir.match(plus) ? (dir.size / 2.0).floor : (dir.size / 2.0).floor * -1
        puts "found: #{name}, #{direction}"
	
        @data[name] ||= 0
	if (oldname != name and @data[oldname])

	  @data[name] += @data[oldname]
          @data.delete(oldname)
        end
        @data[name] += direction
        goodbad = direction > 0 ? "woot!" : "oh noes!"
        persist
        karma += "#{oldname} now at #{@data[name]} (#{goodbad})\n"
      end
      if (karma != "")
        return karma.chomp
      end
    end
  end

end
