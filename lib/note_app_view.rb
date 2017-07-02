class NoteAppView

  def request(req)
    display "#{req}>> "
    gets.chomp
  end

  def display(message)
    puts message
  end

  def display_hash(hash)
    hash.each do |index, note|
      display format("%02d. %s", index, note.title)
    end
  end
end
