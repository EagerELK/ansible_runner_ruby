require 'ansible_runner/simple'

module AnsibleRunner
  class Play < Simple
    attr_reader :name

    def initialize(name, opts = [])
      @name = name
      options.concat opts
    end

    def command
      `which ansible-playbook`.strip
    end

    def inventory
      '~/ansible/inventory' # TODO: Configurable or Dynamic?
    end

    def plays_location
      'scripts/ansible'
    end

    def options
      @options = super
      return @options if @options.count > 0
      @options.concat [ '--diff', '--check' ] if debug?
      @options
    end

    def run
      play_name = name + '.yml' unless name[-5..-1] == '.yml'
      # It might be better to move these to #options?
      options.push "-i #{inventory}"
      options.push "#{plays_location}/#{play_name}"
      execute
    end
  end
end
