class Note
  @note_count = 0
  @notes = {}

  class << self
    attr_accessor :note_count, :notes

    def create(title:, content:)
      Note.new(title: title, content: content).save
    end

    def find(note_id)
      notes[note_id]
    end

    def search(query)
      response_hash = {}
      notes.select do |index, note|
        note.title =~ /#{query}/i || note.content =~ /#{query}/i
      end
    end

    def all
      notes
    end

    def destroy_all
      @notes.clear
      @note_count = 0
    end
  end

  attr_reader :title, :content, :id


  def initialize(title:, content:)
    self.title = title
    self.content = content
    Note.note_count += 1
    @id = Note.note_count
  end

  def title=(title)
    raise "Title can't be blank" unless title && !title.empty?
    @title = title
  end

  def content=(content)
    raise "Content can't be blank" unless content && !content.empty?
    @content  = content
  end

  def save
    Note.notes[self.id] = self
  end

  def update(title: nil, content: nil)
    self.title = title
    self.content = content
  end

  def delete
    Note.notes.delete(self.id)
  end
end
