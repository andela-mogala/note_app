class Note
  attr_reader :title, :content, :id
  @@note_count = 0
  @@notes = {}

  def initialize(title:, content:)
    self.title = title
    self.content = content
    @@note_count += 1
    @id = @@note_count
  end

  def title=(title)
    raise "Title can't be blank" unless title && !title.empty?
    @title = title
  end

  def content=(content)
    raise "Content can't be blank" unless content && !content.empty?
    @content  = content
  end

  def self.create(title:, content:)
    new(title: title, content: content).save
  end

  def self.find(note_id)
    @@notes[note_id]
  end

  def save
    Note.class_variable_get(:@@notes)[self.id] = self
    self
  end

  def update(title: nil, content: nil)
    self.title = title
    self.content = content
  end

  def delete
    Note.class_variable_get(:@@notes).delete(self.id)
  end

  def self.all
    @@notes
  end

  def self.search(query)
    response_hash = {}
    @@notes.select do |index, note|
      note.title =~ /#{query}/i || note.content =~ /#{query}/i
    end
  end

  def self.destroy_all
    @@notes.clear
    @@note_count = 0
  end
end
