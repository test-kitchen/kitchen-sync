require "spec_helper"
require "kitchen"

# kitchen-sync's core_ext.rb monkey-patches Kitchen::Provisioner::ChefBase, a
# class that lives in downstream gems (e.g. kitchen-chef). Define a minimal
# stand-in here so we can exercise the patch in isolation.
module Kitchen
  module Provisioner
    class ChefBase < Base
      def init_command
        "ORIGINAL INIT COMMAND for #{config[:root_path]}"
      end
    end
  end
end

require "kitchen-sync/core_ext"
require "kitchen/transport/sftp"
require "kitchen/transport/rsync"

describe "kitchen-sync/core_ext" do
  let(:provisioner) do
    Kitchen::Provisioner::ChefBase.new(root_path: "/opt/kitchen").tap do |p|
      p.instance_variable_set(:@instance, instance)
    end
  end

  let(:instance) { double("Kitchen::Instance", transport: transport) }

  context "when the transport is Kitchen::Transport::Sftp" do
    let(:transport) { Kitchen::Transport::Sftp.new }

    it "returns a simple mkdir for the root_path" do
      expect(provisioner.init_command).to eq("mkdir -p /opt/kitchen")
    end
  end

  context "when the transport is Kitchen::Transport::Rsync" do
    let(:transport) { Kitchen::Transport::Rsync.new }

    it "returns a simple mkdir for the root_path" do
      expect(provisioner.init_command).to eq("mkdir -p /opt/kitchen")
    end
  end

  context "when the transport is something else" do
    let(:transport) { Kitchen::Transport::Ssh.new }

    it "delegates to the original init_command implementation" do
      expect(provisioner.init_command).to eq("ORIGINAL INIT COMMAND for /opt/kitchen")
    end
  end
end
