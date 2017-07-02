require_relative "./note.rb"
require_relative "./note_app_view.rb"
=begin
  Consider converting all class methods to instance methods
  Also make the changes reflect in the tests
=end
class NoteAppController
  attr_reader :view

  def initialize(view)
    @view = view
  end

  def run
    loop do
      cmd = view.prompt ""
      break if cmd =~ /\Aexit/
      evaluate cmd
    end
  end

  def create_note
    title = view.prompt "Enter a title"
    content = view.prompt "Type your note"
    Note.create(title: title, content: content)
    view.display "Note has been created"
  end

  def view_note
    note_id = view.prompt "Enter the note id"
    note = Note.find(note_id.to_i)
    return view.display "This note doesn't exist!" unless note
    response = "#{note.title}\n\n#{note.content}"
    view.display response
  end

  def delete_note
    note_id = view.prompt "Enter the note id"
    note = Note.find(note_id.to_i)
    return view.display "This note doesn't exist!" unless note
    note.delete
    view.display "Note has been deleted"
  end

  def list_notes
    return view.display "Sorry, no notes here!" if Note.all.empty?
    view.display_hash Note.all
  end

  def search_notes
    query = view.prompt "Enter a search string"
    response = Note.search(query)
    return view.display "No match found!" if response.empty?
    view.display_hash response
  end

  def update_note
    note_id = view.prompt "Enter a note id"
    title = view.prompt "Enter the title"
    content = view.prompt "Enter your note"
    Note.find(note_id.to_i).update(title: title, content: content)
    view.display "Note has been updated!"
  end

  private

  def evaluate(cmd)
    case cmd
    when "createnote" then create_note
    when "viewnote" then view_note
    when "deletenote" then delete_note
    when "listnotes" then list_notes
    when "searchnotes" then search_notes
    else view.display "Unknown command!"
    end
  end
end
