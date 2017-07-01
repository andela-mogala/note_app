class Note
  attr_reader :title, :content, :id
  @@note_count = 0
  @@notes = []

  def initialize(title:, content:)
    self.title = title
    self.content = content
    @@note_count += 1
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
    @@notes[note_id - 1]
  end

  def save
    Note.class_variable_get(:@@notes) << self
    self
  end

  def update(title: nil, content: nil)
    self.title = title
    self.content = content
  end

  def delete
    Note.class_variable_get(:@@notes)
      .delete_at(Note.class_variable_get(:@@notes).find_index(self))
  end

  def self.all
    @@notes
  end

  def self.search(query)
    response_hash = {}
    @@notes.each_with_index do |note, index|
      if note.title =~ /#{query}/i || note.content =~ /#{query}/i
        response_hash[index] = note
      end
    end
    response_hash
  end

  def self.destroy_all
    @@notes= []
  end
end
