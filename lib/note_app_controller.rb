require_relative "./note.rb"
=begin
  Consider converting all class methods to instance methods
  Also make the changes reflect in the tests
=end
class NoteAppController
  def run
  end

  def self.create_note
    input_string = gets.chomp.split
    Note.create(title: input_string[0], content: input_string[1])
    puts "Note has been created"
  end

  def self.view_note
    note_id = gets.chomp.to_i
    note = Note.find(note_id)
    return puts "This note doesn't exist!" unless note
    response = "#{note.title}\n\n#{note.content}"
    puts response
  end

  def self.delete_note
    note_id = gets.chomp.to_i
    note = Note.find(note_id)
    return puts "This note doesn't exist!" unless note
    note.delete
    puts "Note has been deleted"
  end

  def self.list_notes
    return puts "Sorry, no notes here!" if Note.all.empty?
    Note.all.each_with_index do |note, index|
      puts format("%02d. %s", index + 1, note.title)
    end
  end

  def self.search_notes
    query = gets.chomp
    response = Note.search(query)
    return puts "No match found!" if response.empty?
    response.each do |index, note|
      puts format("%02d. %s", index + 1, note.title)
    end
  end

  def self.update_note
    note_id = gets.chomp.to_i
    title = gets.chomp
    content = gets.chomp
    note = Note.find(note_id)
    note.update(title: title, content: content)
    puts "Note has been updated!"
  end
end
