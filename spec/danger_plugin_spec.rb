require File.expand_path('../spec_helper', __FILE__)

module Danger
  describe DangerClorox do
    it 'is a plugin' do
      expect(Danger::DangerClorox < Danger::Plugin).to be_truthy
    end

    describe 'with Dangerfile' do
      before do
        @dangerfile = testing_dangerfile
        @clorox = testing_dangerfile.clorox

        @clorox.config_file = nil
      end

      it "handles clorox not being installed" do
        allow(@clorox).to receive(:`).with("which clorox").and_return("")
        expect(@clorox.clorox_installed?).to be_falsy
      end

      it "handles clorox being installed" do
        allow(@clorox).to receive(:`).with("which clorox").and_return("/bin/wherever/clorox")
        expect(@clorox.clorox_installed?).to be_truthy
      end

      describe :lint_files do
        before do
          # So it doesn't try to install on your computer
          allow(@clorox).to receive(:`).with("which clorox").and_return("/bin/wheverever/clorox")

          # Set up our stubbed JSON response
          @clorox_response = '[{"reason": "Force casts should be avoided.", "file": "/User/me/this_repo/spec/fixtures/SwiftFile.swift", "line": 13, "severity": "Error" }]'
        end

        it 'handles a known Clorox report' do
          allow(@clorox).to receive(:`).with('clorox lint --quiet --reporter json --path spec/fixtures/SwiftFile.swift').and_return(@clorox_response)

          # Do it
          @clorox.lint_files("spec/fixtures/*.swift")

          output = @clorox.status_report[:markdowns].first

          expect(output).to_not be_empty

          # A title
          expect(output).to include("Clorox found issues")
          # A warning
          expect(output).to include("SwiftFile.swift | 13 | Force casts should be avoided.")
        end

        it 'handles no files' do
          allow(@clorox).to receive(:modified_files).and_return('spec/fixtures/SwiftFile.swift')
          allow(@clorox).to receive(:`).with('clorox lint --quiet --reporter json --path spec/fixtures/SwiftFile.swift').and_return(@clorox_response)

          @clorox.lint_files("spec/fixtures/*.swift")

          expect(@clorox.status_report[:markdowns].first).to_not be_empty
        end

      end
    end
  end
end
