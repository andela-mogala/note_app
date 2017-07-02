require 'colorize'

class NoteAppView

  def display(message)
    puts message.colorize color: :black, background: :white
  end

  def display_hash(hash)
    hash.each do |index, note|
      display format("%02d. %s", index, note.title)
    end
  end

  def prompt(prompt_message)
    print "#{prompt_message}>> ".colorize :green
    gets.chomp
  end
end
