require_relative "../lib/note_app_view.rb"
require_relative "../lib/note.rb"
require_relative "./spec_helper.rb"

RSpec.describe NoteAppView do
  let(:view) { NoteAppView.new }

  describe "#request" do
    it "prompts the user and returns a string" do
      allow(view).to receive(:gets).and_return("1")

      message = capture_puts { view.prompt("Search") }

      expect(message).to include "Search>> "
      expect(view.prompt("Search")).to eq "1"
    end
  end

  describe "#display" do
    it "prints messages to the console" do
      message = capture_puts { view.display("Note has been deleted!") }
      expect(message).to include "Note has been deleted!"
    end
  end

  describe "#display_list" do
    it "prints the list of notes with index and title" do
      note_1 = Note.create(title: "Story", content: "A nice story")
      note_2 = Note.create(title: "Another Story", content: "Random text")
      note_3 = Note.create(title: "Evening Time", content: "Here is a note")

      output = capture_puts { view.display_hash(Note.all) }

      expect(output).to include "01. Story"
      expect(output).to include "02. Another Story"
      expect(output).to include "03. Evening Time"
    end
  end
end
