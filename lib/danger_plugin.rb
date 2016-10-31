module Danger


  # Checks the presence of Xcode file headers.
  # This is done using the [clorox](https://pypi.python.org/pypi/clorox) python egg.
  # Results are passed out as a list in markdown.
  #
  # @example Running clorox from current directory
  #
  #          # clorox.check_files
  #
  # @example Running clorox from specific directories
  #
  #          clorox.directories = ["MyApp", "MyAppTests", "MyAppExtension"]
  #          clorox.check_files
  #
  # @tags xcode, clorox, comments
  #
  class DangerClorox < Plugin

    ROOT_DIR = "/tmp/danger_clorox"
    EXECUTABLE = "#{ROOT_DIR}/clorox/clorox.py"

    # Checks presence of file header comments. Will fail if `clorox` cannot be installed correctly.
    # Generates a `markdown` list of dirty Objective-C and Swift files
    #
    # @param directories [Array<String>] Directories from where clorox will be run. Defaults to current dir.
    # @return [void]
    #
    def check(directories=["."])
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
      result = JSON.parse(`#{clorox_command}`)
      result['files'].each { |file| warn("#{file} contains file header", sticky: false) } unless result['status'] == 'clean'
    end

    # Determine if clorox is currently installed in the system paths.
    # @return  [Bool]
    #
    def clorox_installed?
      File.exists? EXECUTABLE
    end
  end
end
