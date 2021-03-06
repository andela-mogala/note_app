require_relative "../lib/note_app_controller.rb"
require_relative "../lib/note.rb"
require_relative "../lib/note_app_view.rb"
require_relative "spec_helper.rb"

RSpec.describe NoteAppController do
  let(:view) { NoteAppView.new }
  let(:controller) { NoteAppController.new(view) }
  before(:each) { Note.create(title: "Title", content: "Content") }
  after(:each) { Note.destroy_all }

  describe ".create_note" do
    it "creates a note in memory" do
      allow(view).to receive(:gets).and_return("Title", "Content")

      message = capture_puts { controller.create_note }

      expect(Note.all[1].title).to eq "Title"
      expect(Note.all[1].content).to eq "Content"
      expect(message).to include "Note has been created"
    end
  end

  describe ".view_note" do
    it "displays the title and content of a note" do
      response = capture_puts { controller.view_note 1 }

      expect(response).to include "Title\n\nContent"
    end

    context "when the note doesn't exist" do
      it "indicates that the note doesn't exist" do
        message  = capture_puts { controller.view_note 50 }

        expect(message).to include "This note doesn't exist!"
      end
    end
  end

  describe ".delete_note" do
    it "removes a note from memory" do
      response = capture_puts { controller.delete_note(1) }

      expect(Note.all.has_value? @note).to be false
      expect(response).to include "Note has been deleted"
    end

    context "when the note doesn't exist" do
      it "indicates that the note doesn't exist" do
        message  = capture_puts { controller.delete_note 50 }

        expect(message).to include "This note doesn't exist!"
      end
    end
  end

  describe ".list_notes" do
    it "displays all note titles with their index position" do
      note_1 = Note.create(title: "Story", content: "A nice story")
      note_2 = Note.create(title: "Another Story", content: "Random text")

      message = capture_puts { controller.list_notes }

      expect(message).to include "01. Title"
      expect(message).to include "02. Story"
      expect(message).to include "03. Another Story"
    end

    context "when there are no notes" do
      it "indicates that there are no notes" do
        Note.destroy_all

        message = capture_puts { controller.list_notes }
        expect(message).to include "Sorry, no notes here!"
      end
    end
  end

  describe ".search_notes" do
    it "returns the index and titles of notes that contain the search query" do
      note_1 = Note.create(title: "Story", content: "A nice story")
      note_2 = Note.create(title: "Another Story", content: "Random text")
      note_3 = Note.create(title: "Evening Time", content: "Here is a note")

      result = capture_puts { controller.search_notes "story" }

      expect(result).to include("02. Story")
      expect(result).to include("03. Another Story")
      expect(result).not_to include("01. Title")
      expect(result).not_to include("04. Evening Time")

      Note.destroy_all
    end

    context "when there is no match for the query" do
      it "indicates that no match was found" do
        note_1 = Note.create(title: "Story", content: "A nice story")
        note_2 = Note.create(title: "Another Story", content: "Random text")
        note_3 = Note.create(title: "Evening Time", content: "Here is a note")

        result = capture_puts { controller.search_notes "member" }

        expect(result).to include "No match found!"

        Note.destroy_all
      end
    end

    context "when a limit is specified" do
      it "returns the exact number of results matching the limit size" do
        note_1 = Note.create(title: "Story", content: "A nice story")
        note_2 = Note.create(title: "Another Story", content: "Random text")
        note_3 = Note.create(title: "Evening Time", content: "Here is a note")

        result = capture_puts { controller.search_notes "story", 1 }

        expect(result).to include "Story"
        expect(result).not_to include "Another Story"
        expect(result).not_to include "Evening Time"
      end
    end
  end

  # I will revisit these tests when I have decided how to implement the controller method
  describe ".update_note" do
    it "updates the title or/and content of a note" do
      allow(view).to receive(:gets).and_return("1", "New Title", "New Content")

      message = capture_puts { controller.update_note }

      expect(Note.all[1].title).to eq "New Title"
      expect(Note.all[1].content).to eq "New Content"
      expect(message).to include "Note has been updated!"
    end
  end
end
