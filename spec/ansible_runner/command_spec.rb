require 'spec_helper'

describe AnsibleRunner::Command do
  let(:binary) { `which ansible`.strip }

  it 'uses the ansible-playbook command' do
    expect(subject.command_line).to match(/^#{binary}/)
  end

  context 'debug mode' do
    subject do
      runner = AnsibleRunner::Command.new
      runner.debug = true
      runner
    end

    it 'sets --check, but not --diff' do
      expect(subject.options).to_not include('--diff')
      expect(subject.options).to include('--check')
    end
  end
end
