require 'ansible_runner/simple'

module AnsibleRunner
  class Command < Simple
    def command
      `which ansible`.strip
    end

    def inventory
      '~/ansible/inventory' # TODO: Configurable or Dynamic?
    end

    def options
      @options = super
      return @options if @options.count > 0
      @options.push '--module-name=command'
      @options.push '--check' if debug?
      @options
    end
  end
end
