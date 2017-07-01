require_relative '../lib/note.rb'

RSpec.describe Note do

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

      expect(Note.all).to include(note)

      Note.destroy_all
    end
  end

  describe ".find" do
    it "finds a returns a note" do
      note_1 = Note.create(title: 'First', content: 'First Story')
      note_2 = Note.create(title: 'Second', content: 'Second Story')
      note_3 = Note.create(title: 'Third', content: 'Third Story')

      expect(Note.find(3)).to eq note_3

      Note.destroy_all
    end
  end

  describe "#save" do
    it "saves a note to memory" do
      note = Note.new(title: 'Title', content: 'Content')
      note.save

      expect(Note.all).to include note

      Note.destroy_all
    end
  end

  describe "#update" do
    it "updates the title and content of a note" do
      note = Note.new(title: 'Title', content: 'Content').save
      note.update(title: 'Amazing Grace', content: 'How sweet the sound')

      expect(note.title).to eq 'Amazing Grace'
      expect(note.content).to eq 'How sweet the sound'

      Note.destroy_all
    end
  end

  describe "#delete" do
    it "deletes a note from memory" do
      note = Note.create(title: "Title", content: "content")
      expect(Note.all).to include note

      note.delete

      expect(Note.all).not_to include note

      Note.destroy_all
    end
  end

  describe ".all" do
    it "returns all notes" do
      note_1 = Note.create(title: 'First', content: 'First Story')
      note_2 = Note.create(title: 'Second', content: 'Second Story')
      note_3 = Note.create(title: 'Third', content: 'Third Story')

      expect(Note.all).to contain_exactly(note_1, note_2, note_3)

      Note.destroy_all
    end
  end

  describe ".search" do
    it "returns a hash containing notes that match the query" do
      note_1 = Note.create(title: 'First', content: 'First Story')
      note_2 = Note.create(title: 'Second', content: 'Second Story')
      note_3 = Note.create(title: 'Third', content: 'Third Story')

      response = Note.search("ir")
      expect(response[0]).to eq note_1
      expect(response[2]).to eq note_3
    end
  end
end
