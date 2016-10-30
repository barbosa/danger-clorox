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
      end

      it "handles clorox not being installed" do
        allow(File).to receive(:exists?).with(Danger::DangerClorox::EXECUTABLE).and_return(false)
        expect(@clorox.clorox_installed?).to be_falsy
      end

      it "handles clorox being installed" do
        allow(File).to receive(:exists?).with(Danger::DangerClorox::EXECUTABLE).and_return(true)
        expect(@clorox.clorox_installed?).to be_truthy
      end

      it "handles a single directory" do
        allow(File).to receive(:exists?).with(Danger::DangerClorox::EXECUTABLE).and_return(true)

        @clorox_response = '{"status": "dirty", "files": ["some/path/FileA.swift", "some/path/FileB.m"]}'
        allow(@clorox).to receive(:`).with("python #{Danger::DangerClorox::EXECUTABLE} --path some/dir --inspection --report json").and_return(@clorox_response)

        @clorox.directories = ["some/dir"]
        @clorox.check_files
      end

      it "handles multiple directories" do
        allow(File).to receive(:exists?).with(Danger::DangerClorox::EXECUTABLE).and_return(true)

        @clorox_response = '{"status": "dirty", "files": ["some/path/FileA.swift", "some/path/FileB.m"]}'
        allow(@clorox).to receive(:`).with("python #{Danger::DangerClorox::EXECUTABLE} --path some/dir some/path --inspection --report json").and_return(@clorox_response)

        @clorox.directories = ["some/dir", "some/path"]
        @clorox.check_files
      end

      describe :check_files do
        before do
          allow(File).to receive(:exists?).with(Danger::DangerClorox::EXECUTABLE).and_return(true)
        end

        it 'handles a dirty clorox report' do
          @clorox_response = '{"status": "dirty", "files": ["some/path/FileA.swift", "some/path/FileB.m"]}'
          allow(@clorox).to receive(:`).with("python #{Danger::DangerClorox::EXECUTABLE} --path some/dir --inspection --report json").and_return(@clorox_response)

          @clorox.directories = ["some/dir"]
          @clorox.check_files

          output = @clorox.status_report[:markdowns].first

          expect(output.message).to include("Clorox has found issues")
          expect(output.message).to include("- some/path/FileA.swift")
          expect(output.message).to include("- some/path/FileB.m")
        end

        it 'handles a clean clorox report' do
          @clorox_response = '{"status": "clean", "files": []}'
          allow(@clorox).to receive(:`).with("python #{Danger::DangerClorox::EXECUTABLE} --path some/dir --inspection --report json").and_return(@clorox_response)

          @clorox.directories = ["some/dir"]
          @clorox.check_files

          expect(@clorox.status_report[:markdowns].first).to be_nil
        end

      end
    end
  end
end
