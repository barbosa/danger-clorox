module Danger


  class DangerClorox < Plugin

    # Allows you to specify a config file location for swiftlint.
    attr_accessor :config_file

    # Lints Swift files. Will fail if `swiftlint` cannot be installed correctly.
    # Generates a `markdown` list of warnings for the prose in a corpus of .markdown and .md files.
    #
    # @param   [String] files
    #          A globbed string which should return the files that you want to lint, defaults to nil.
    #          if nil, modified and added files from the diff will be used.
    # @return  [void]
    #
    def lint_files(files=nil)
      # Installs clorox if needed
      system "brew install clorox" unless clorox_installed?

      # Check that this is in the user's PATH after installing
      unless clorox_installed?
        fail "clorox is not in the user's PATH, or it failed to install"
        return
      end

      # Either use files provided, or use the modified + added
      swift_files = files ? Dir.glob(files) : (modified_files + added_files)
      swift_files.select! do |line| line.end_with?(".swift") end

      clorox_command = "clorox lint --quiet --reporter json"
      clorox_command += " --config #{config_file}" if config_file

      require 'json'
      result_json = swift_files.uniq.collect { |f| JSON.parse(`#{clorox_command} --path #{f}`.strip).flatten }.flatten

      # Convert to clorox results
      warnings = result_json.flatten.select do |results|
        results['severity'] == 'Warning'
      end
      errors = result_json.select do |results|
        results['severity'] == 'Error'
      end

      message = ''

      # We got some error reports back from clorox
      if warnings.count > 0 || errors.count > 0
        message = '### Clorox found issues\n\n'
      end

      message << parse_results(warnings, 'Warnings') unless warnings.empty?
      message << parse_results(errors, 'Errors') unless errors.empty?

      markdown message
    end

    # Parses clorox invocation results into a string
    # which is formatted as a markdown table.
    #
    # @return  [String]
    #
    def parse_results (results, heading)
      message = "#### #{heading}\n\n"

      message << 'File | Line | Reason |\n'
      message << '| --- | ----- | ----- |\n'

      results.each do |r|
        filename = r['file'].split('/').last
        line = r['line']
        reason = r['reason']

        message << "#{filename} | #{line} | #{reason} \n"
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
