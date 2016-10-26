module Danger


  class DangerClorox < Plugin

    ROOT_DIR = "/tmp/danger_clorox"
    EXECUTABLE = "#{ROOT_DIR}/clorox/clorox.py"

    # Allows you to specify directories from where clorox will be run.
    attr_accessor :directories

    # Checks presence of file header comments. Will fail if `clorox` cannot be installed correctly.
    # Generates a `markdown` list of dirty Objective-C and Swift files
    #
    # @return  [void]
    #
    def check_files
      # Installs clorox if needed
      system "pip install --target #{ROOT_DIR} clorox" unless clorox_installed?

      # Check that this is in the user's PATH after installing
      unless clorox_installed?
        fail "clorox is not in the user's PATH, or it failed to install"
        return
      end

      clorox_command = "python #{EXECUTABLE} "
      clorox_command += "--path #{directories ? directories.join(' ') : '.'} "
      clorox_command += "--inspection "
      clorox_command += "--report json"

      require 'json'
      result_json = JSON.parse(`#{clorox_command}`)

      message = ''
      if result_json['status'] == 'dirty'
        message = "### Clorox has found issues\n"
        message << "Please, remove the header from the files below (those comments on the top of your file):\n\n"
        result_json['files'].each do |r|
          message << "- #{r}\n"
        end
        markdown message
      end
    end

    # Determine if clorox is currently installed in the system paths.
    # @return  [Bool]
    #
    def clorox_installed?
      File.exists? EXECUTABLE
    end
  end
end
