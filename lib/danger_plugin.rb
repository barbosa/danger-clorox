module Danger


  class DangerClorox < Plugin

    # Checks presence of file header comments. Will fail if `clorox` cannot be installed correctly.
    # Generates a `markdown` list of dirty Objective-C and Swift files
    #
    # @param   [String] files
    #          A globbed string which should return the files that you want to check, defaults to nil.
    #          if nil, modified and added files from the diff will be used.
    # @return  [void]
    #
    def check_files(files=nil)
      # Installs clorox if needed
      system "pip install --target /tmp/danger_clorox clorox" unless clorox_installed?

      # Check that this is in the user's PATH after installing
      unless clorox_installed?
        fail "clorox is not in the user's PATH, or it failed to install"
        return
      end

      # Either use files provided, or use the modified + added
      files = files ? Dir.glob(files) : (git.modified_files + git.added_files).uniq

      require 'json'
      result = JSON.parse(`python /tmp/danger_clorox/clorox/clorox.py -p #{files.join(" ")} -i -r json`)

      message = ''
      if result['status'] == 'dirty'
        message = "### Clorox has found issues\n"
        message << "Please, remove the header from the files below (those comments on the top of your file):\n\n"
        message << parse_results(result['files'])
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
