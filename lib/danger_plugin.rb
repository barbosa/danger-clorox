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
      system "pip install clorox" unless clorox_installed?

      # Check that this is in the user's PATH after installing
      unless clorox_installed?
        fail "clorox is not in the user's PATH, or it failed to install"
        return
      end

      # Either use files provided, or use the modified + added
      files = files ? Dir.glob(files) : (modified_files + added_files)

      require 'json'
      result = files.uniq.collect { |f| JSON.parse(`clorox -p #{f} -i -r json`.strip).flatten }.flatten

      message = ''
      if result['status'] == 'dirty'
          message = '### Clorox found issues\n\n'
          message << parse_results(result['files'])
      end

      markdown message
    end

    # Parses clorox invocation results into a string
    # which is formatted as a markdown table.
    #
    # @return  [String]
    #
    def parse_results(results)
      message = "#### #{heading}\n\n"

      message << '| File | Status |\n'
      message << '| ---- | ------ |\n'

      results.each do |r|
        message << "#{r} | dirty | \n"
      end

      message
    end

    # Determine if clorox is currently installed in the system paths.
    # @return  [Bool]
    #
    def clorox_installed?
      `which clorox`.strip.empty? == false
    end
  end
end
