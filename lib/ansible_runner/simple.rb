module AnsibleRunner
  class Simple
    attr_reader :output

    def execute
      puts "Running `#{command_line}"
      @output = `#{command_line}`
      @result = $?
      @result.success?
    end

    def command_line
      opt_str = options.join(' ')
      env_str = env.join(' ')

      "#{env_str} #{command} #{opt_str}".strip
    end

    def options
      @options ||= []
    end

    def options=(option)
      if option.kind_of? Array
        options.concat option
      else
        options.push option
      end
    end

    def env
      @env ||= []
    end

    def env=(value)
      if value.kind_of? Array
        env.concat value
      else
        env.push value
      end
    end

    def ran?
      !@result.nil?
    end

    def output
      raise 'Command hasn\'t run yet' unless ran?

      @output
    end

    def result
      raise 'Command hasn\'t run yet' unless ran?

      @result
    end

    def success?
      raise 'Command hasn\'t run yet' unless ran?

      @result.success?
    end

    def debug?
      @debug = false if @debug.nil?
      @debug
    end

    def debug=(value)
      @debug = value
    end
  end
end
