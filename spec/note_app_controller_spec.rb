require_relative "../lib/note_app_controller.rb"
require_relative "../lib/note.rb"
require_relative "spec_helper.rb"

RSpec.describe NoteAppController do
  before(:each) { Note.create(title: "Title", content: "Content") }
  after(:each) { Note.destroy_all }

  describe ".create_note" do
    it "creates a note in memory" do
      allow(NoteAppController).to receive(:gets).and_return("Title Content")

      message = capture_puts { NoteAppController.create_note }

      expect(Note.all[0].title).to eq "Title"
      expect(Note.all[0].content).to eq "Content"
      expect(message).to eq "Note has been created"
    end
  end

  describe ".view_note" do
    it "displays the title and content of a note" do
      allow(NoteAppController).to receive(:gets).and_return("1")
      response = capture_puts { NoteAppController.view_note }

      expect(response).to eq "Title\n\nContent"
    end
  end

  describe ".delete_note" do
    it "removes a note from memory" do
      allow(NoteAppController).to receive(:gets).and_return("1")

      response = capture_puts { NoteAppController.delete_note }
      expect(Note.all).to eq []
      expect(response).to eq "Note has been deleted"
    end
  end

  describe ".list_notes" do
    it "displays all note titles with their index position" do
      message = capture_puts { NoteAppController.list_notes }
      expect(message).to include "01. Title"
    end
  end

  describe ".search_notes" do
    it "returns the index and titles of notes that contain the search query" do
      allow(NoteAppController).to receive(:gets).and_return("story")

      note_1 = Note.create(title: "Story", content: "A nice story")
      note_2 = Note.create(title: "Another Story", content: "Random text")
      note_3 = Note.create(title: "Evening Time", content: "Here is a note")

      result = capture_puts { NoteAppController.search_notes }

      expect(result).to include("02. Story")
      expect(result).to include("03. Another Story")
      expect(result).not_to include("01. Title")
      expect(result).not_to include("04. Evening Time")
    end
  end
end
