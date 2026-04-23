require "spec_helper"
require "kitchen"
require "kitchen/transport/sftp"

describe Kitchen::Transport::Sftp do
  subject(:transport) { described_class.new }

  it "is a subclass of Kitchen::Transport::Ssh" do
    expect(described_class.ancestors).to include(Kitchen::Transport::Ssh)
  end

  it "defines a default ruby_path config" do
    expect(transport[:ruby_path]).to eq("/opt/chef/embedded/bin/ruby")
  end

  describe "CHECKSUMS_PATH" do
    it "points at the bundled checksums.rb script" do
      expect(File).to exist(described_class::CHECKSUMS_PATH)
      expect(described_class::CHECKSUMS_PATH).to end_with("kitchen-sync/checksums.rb")
    end
  end

  describe "CHECKSUMS_REMOTE_PATH" do
    it "embeds the checksums script SHA1 in the remote path" do
      expect(described_class::CHECKSUMS_REMOTE_PATH).to match(%r{\A/tmp/checksums-[0-9a-f]{40}\.rb\z})
    end

    it "is frozen" do
      expect(described_class::CHECKSUMS_REMOTE_PATH).to be_frozen
    end
  end

  describe "MAX_TRANSFERS" do
    it "is a positive integer" do
      expect(described_class::MAX_TRANSFERS).to be_a(Integer)
      expect(described_class::MAX_TRANSFERS).to be > 0
    end
  end
end
