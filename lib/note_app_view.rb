class NoteAppView

  def request(req)
    display "#{req}>> "
    gets.chomp
  end

  def display(message)
    puts message
  end

  def display_list(list)
    list.each_with_index do |note, index|
      display format("%02d. %s", index + 1, note.title)
    end
  end
end
