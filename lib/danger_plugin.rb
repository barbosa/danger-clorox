module Danger


  # Checks the presence of Xcode file headers.
  # This is done using the [clorox](https://pypi.python.org/pypi/clorox) python egg.
  # Results are passed out as a list in markdown.
  #
  # @example Running clorox from current directory
  #
  #          clorox.check
  #
  # @example Running clorox from specific directories
  #
  #          clorox.check ["MyApp", "MyAppTests", "MyAppExtension"]
  #
  # @see barbosa/danger-clorox
  # @tags xcode, clorox, comments
  #
  class DangerClorox < Plugin

    ROOT_DIR = "/tmp/danger_clorox"
    EXECUTABLE = "#{ROOT_DIR}/clorox/clorox.py"

    LEVEL_WARNING = "warning"
    LEVEL_FAILURE = "failure"

    # Allows you to set a level to the checker.
    # Possible values are "warning" and "failure".
    # Defaults to "warning".
    #
    # @return [String]
    attr_accessor :level

    # Checks presence of file header comments. Will fail if `clorox` cannot be installed correctly.
    # Generates a list of warnings/failures of your Objective-C and Swift files.
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
      if result['status'] == 'dirty'
        result['files'].each do |file|
          message = "#{file} contains Xcode's file header"
          level == LEVEL_FAILURE ? fail(message) : warn(message)
        end
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
