require_relative '../lib/note.rb'

RSpec.describe Note do
  after(:each) { Note.destroy_all }

  describe ".find" do
    it "finds and returns a note" do
      note_1 = Note.create(title: 'First', content: 'First Story')
      note_2 = Note.create(title: 'Second', content: 'Second Story')
      note_3 = Note.create(title: 'Third', content: 'Third Story')

      expect(Note.find(note_3.id)).to eq note_3
    end
  end

  describe '.new' do
    it 'accepts title and content as arguments' do
      note = Note.new(title: 'Title', content: 'Nice Story');
      expect(note.title).to eq 'Title'
      expect(note.content).to eq 'Nice Story'
    end

    context "when title is blank" do
      it "raises an error" do
        expect{ Note.new(title: '', content: 'Some content') }.to raise_error "Title can't be blank"
      end
    end

    context "when content is blank" do
      it "raises an error" do
        expect { Note.new(title: "Title", content: '') }.to raise_error "Content can't be blank"
      end
    end

    context "when no argument is provided" do
      it "raises an error" do
        expect { Note.new }.to raise_error "missing keywords: title, content"
      end
    end
  end

  describe ".create" do
    it "creates and adds a new note to memory" do
      note = Note.create(title: 'Title', content: 'Content')

      expect(Note.all.has_value? note).to be true
    end
  end

  describe "#save" do
    it "saves a note to memory" do
      note = Note.new(title: 'Title', content: 'Content')
      note.save

      expect(Note.all.has_value? note).to be true
    end
  end

  describe "#update" do
    it "updates the title and content of a note" do
      note = Note.new(title: 'Title', content: 'Content').save
      note.update(title: 'Amazing Grace', content: 'How sweet the sound')

      expect(note.title).to eq 'Amazing Grace'
      expect(note.content).to eq 'How sweet the sound'
    end
  end

  describe "#delete" do
    it "deletes a note from memory" do
      note = Note.create(title: "Title", content: "content")
      expect(Note.all.has_value? note).to be true

      note.delete

      expect(Note.all.has_value? note).to be false
    end
  end

  describe ".all" do
    it "returns all notes" do
      note_1 = Note.create(title: 'First', content: 'First Story')
      note_2 = Note.create(title: 'Second', content: 'Second Story')
      note_3 = Note.create(title: 'Third', content: 'Third Story')

      expect(Note.all.has_value? note_1).to be true
      expect(Note.all.has_value? note_2).to be true
      expect(Note.all.has_value? note_3).to be true
    end
  end

  describe ".search" do
    it "returns a hash containing notes that match the query" do
      note_1 = Note.create(title: 'First', content: 'First Story')
      note_2 = Note.create(title: 'Second', content: 'Second Story')
      note_3 = Note.create(title: 'Third', content: 'Third Story')

      response = Note.search("ir")
      expect(response.has_value? note_1).to be true
      expect(response.has_value? note_3).to be true
    end
  end

  describe ".destroy_all" do
    it "clears all notes from memory and resets note count" do
      note_1 = Note.create(title: 'First', content: 'First Story')
      note_2 = Note.create(title: 'Second', content: 'Second Story')

      expect(Note.all.size).to eq 2

      Note.destroy_all

      expect(Note.all.empty?).to be true
      expect(Note.class_variable_get(:@@note_count)).to eq 0
    end
  end
end
