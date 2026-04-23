require "spec_helper"
require "kitchen"
require "kitchen/transport/rsync"

describe Kitchen::Transport::Rsync do
  subject(:transport) { described_class.new }

  it "is a subclass of Kitchen::Transport::Ssh" do
    expect(described_class.ancestors).to include(Kitchen::Transport::Ssh)
  end

  it "defines a Connection class that inherits from Ssh::Connection" do
    expect(described_class::Connection.ancestors).to include(Kitchen::Transport::Ssh::Connection)
  end
end
