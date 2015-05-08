require 'spec_helper'

describe AnsibleRunner::Play do
  subject { AnsibleRunner::Play.new('test') }

  let(:binary) { `which ansible-playbook`.strip }

  it 'uses the ansible-playbook command' do
    expect(subject.command_line).to match(/^#{binary}/)
  end

  context 'debug mode' do
    subject do
      runner = AnsibleRunner::Play.new('test')
      runner.debug = true
      runner
    end

    it 'sets --diff and --check' do
      expect(subject.options).to include('--diff')
      expect(subject.options).to include('--check')
    end
  end
end
