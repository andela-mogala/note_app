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

  def view_note(id)
    note = Note.find(id)
    return view.display "This note doesn't exist!" unless note
    response = "#{note.title}\n\n#{note.content}"
    view.display response
  end

  def delete_note(id)
    note = Note.find(id)
    return view.display "This note doesn't exist!" unless note
    note.delete
    view.display "Note has been deleted"
  end

  def list_notes(size = nil)
    return view.display "Sorry, no notes here!" if Note.all.empty?
    return view.display_hash Note.all.take(size) if size
    view.display_hash Note.all
  end

  def search_notes(query, size = nil)
    response = Note.search(query)
    response = response.take(size) if size
    return view.display "No match found!" if response.empty?
    view.display_hash response
  end

  # I have not decided how best to implement this yet so I'm putting it on hold
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
    when /\Aviewnote\s\d$/ then view_note cmd.split[1].to_i
    when /\Adeletenote\s\d$/ then delete_note cmd.split[1].to_i
    when /\Alistnotes/ then process_list_notes cmd
    when /\Asearchnotes\s.*$/ then process_search cmd
    else view.display_error "Unknown command!"
    end
  end

  def process_search(cmd)
    keywords = cmd.split
    return search_notes(keywords[1]) if keywords.size == 2
    return view.display_error 'Invalid Command!' if keywords.size < 4 && \
    (keywords[2] != "--limit" || keywords[2] != "-l")
    search_notes(keywords[1], keywords[3].to_i)
  end

  def process_list_notes(cmd)
    keywords = cmd.split
    return list_notes if keywords.size == 1
    return view.display_error 'Invalid Command!' if keywords.size < 3 && \
    (keywords[1] != "--limit" || keywords[1] !="-l")
    return list_notes keywords[2].to_i if keywords.size == 3
  end
end
