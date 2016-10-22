module Danger


  class DangerClorox < Plugin

    # Allows you to specify a directory from where clorox will be run.
    attr_accessor :directory

    # Checks presence of file header comments. Will fail if `clorox` cannot be installed correctly.
    # Generates a `markdown` list of dirty Objective-C and Swift files
    #
    # @return  [void]
    #
    def check_files
      # Installs clorox if needed
      system "pip install --target /tmp/danger_clorox clorox" unless clorox_installed?

      # Check that this is in the user's PATH after installing
      unless clorox_installed?
        fail "clorox is not in the user's PATH, or it failed to install"
        return
      end

      clorox_command = "python /tmp/danger_clorox/clorox/clorox.py "
      clorox_command += "--path #{directory ? directory : '.'} "
      clorox_command += "--inspection "
      clorox_command += "--report json"

      require 'json'
      result_json = JSON.parse(`(#{clorox_command})`)

      message = ''
      if result_json['status'] == 'dirty'
        message = "### Clorox has found issues\n"
        message << "Please, remove the header from the files below (those comments on the top of your file):\n\n"
        # message << parse_results(result_json['files'])
        markdown message
      end
    end

    # Parses clorox invocation results into a string
    # which is formatted as a markdown table.
    #
    # @return  [String]
    #
    def parse_results(results)
      message = ""
      results.each do |r|
        message << "- #{r} :hankey:\n"
      end

      message
    end

    # Determine if clorox is currently installed in the system paths.
    # @return  [Bool]
    #
    def clorox_installed?
      Dir.exists? "/tmp/danger_clorox"
    end
  end
end
