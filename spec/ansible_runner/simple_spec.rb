require 'spec_helper'

class TestRunner < AnsibleRunner::Simple
  def command
    '/bin/bash'
  end
end

describe AnsibleRunner::Simple do
  let(:binary) { '/bin/bash' }

  subject { TestRunner.new }

  context '#env and #env=' do
    it 'default to an empty Array' do
      expect(subject.env).to eq []
    end

    it 'can add one' do
      subject.env = 'HOME=/home/ansible'
      expect(subject.env).to include 'HOME=/home/ansible'
    end

    it 'can add multiple' do
      subject.env = [ 'HOME=/home/ansible', 'SHELL=/bin/bash' ]
      expect(subject.env).to include 'HOME=/home/ansible'
      expect(subject.env).to include 'SHELL=/bin/bash'
    end
  end

  context '#options and #options=' do
    it 'default to an empty Array' do
      expect(subject.options).to eq []
    end

    it 'can add one' do
      subject.options = '--step'
      expect(subject.options).to include '--step'
    end

    it 'can add multiple' do
      subject.options = [ '--step', '--flush-cache' ]
      expect(subject.options).to include '--step'
      expect(subject.options).to include '--flush-cache'
    end
  end

  context '#command_line' do
    it 'correctly renders the command' do
      expect(subject.command_line).to eq "#{binary}"
    end

    it 'correctly renders environment variables' do
      subject.env = 'HOME=/home/ansible'
      expect(subject.command_line).to match(/HOME=\/home\/ansible #{binary}/)
    end

    it 'correctly renders options' do
      subject.options = '--step'
      expect(subject.command_line).to match(/#{binary} --step$/)
    end
  end

  context '#execute' do
    it 'populates the output' do
      subject.options = '--version'
      subject.execute
      expect(subject.output).not_to be_empty
    end

    it 'populates the result' do
      subject.options = '--version'
      subject.execute
      expect(subject.result).to be_kind_of(Process::Status)
    end

    it 'reports on the command\'s success' do
      subject.options = '--version'
      subject.execute
      expect([false, true]).to include(subject.success?)
    end
  end

  context 'sanity check' do
    it 'fails when you access the output without executing the command' do
      expect{ subject.output }.to raise_error
    end

    it 'fails when you access the result without executing the command' do
      expect{ subject.result }.to raise_error
    end

    it 'fails when you check the success without executing the command' do
      expect{ subject.success? }.to raise_error
    end
  end

  context 'debug mode' do
    subject do
      runner = AnsibleRunner::Simple.new
      runner.debug = true
      runner
    end

    it 'is not in debug mode by default' do
      expect(AnsibleRunner::Simple.new.debug?).to eq false
    end

    it 'can be set to run in debug mode' do
      runner = AnsibleRunner::Simple.new

      runner.debug = true
      expect(runner.debug?).to eq true
    end
  end
end
