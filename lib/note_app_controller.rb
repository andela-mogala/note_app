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
  end

  def create_note
    input_string = view.request "Enter a title and content for your note"
    Note.create(title: input_string[0], content: input_string[1])
    view.display "Note has been created"
  end

  def view_note
    note_id = view.request "Enter the note id"
    note = Note.find(note_id.to_i)
    return view.display "This note doesn't exist!" unless note
    response = "#{note.title}\n\n#{note.content}"
    view.display response
  end

  def delete_note
    note_id = view.request "Enter the note id"
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
    query = view.request "Enter a search string"
    response = Note.search(query)
    return view.display "No match found!" if response.empty?
    view.display_hash response
  end

  def update_note
    note_id = view.request "Enter a note id"
    title = view.request "Enter the title"
    content = view.request "Enter your note"
    Note.find(note_id.to_i).update(title: title, content: content)
    view.display "Note has been updated!"
  end
end
