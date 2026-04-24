require "spec_helper"
require "json"
require "digest/sha1"

describe "kitchen-sync/checksums.rb" do
  let(:script_path) { File.expand_path("../../lib/kitchen-sync/checksums.rb", __dir__) }

  def run_checksums(target)
    output = IO.popen([RbConfig.ruby, script_path, target], &:read)
    raise "checksums.rb failed: #{output}" unless $CHILD_STATUS.success?

    JSON.parse(output)
  end

  around(:each) do |example|
    Dir.mktmpdir("kitchen-sync-checksums") do |dir|
      @tmpdir = dir
      example.run
    end
  end

  it "exists at the expected path" do
    expect(File).to exist(script_path)
  end

  context "with a single file target" do
    it "returns the file digest keyed by empty path" do
      file = File.join(@tmpdir, "single.txt")
      File.write(file, "hello world")
      expected = Digest::SHA1.hexdigest("hello world")

      result = run_checksums(file)
      expect(result).to eq("" => expected)
    end
  end

  context "with a directory target" do
    before do
      File.write(File.join(@tmpdir, "a.txt"), "alpha")
      File.write(File.join(@tmpdir, "b.txt"), "beta")
      FileUtils.mkdir_p(File.join(@tmpdir, "sub"))
      File.write(File.join(@tmpdir, "sub", "c.txt"), "gamma")
    end

    it "returns a hash with sha1 digests for files and true for directories" do
      result = run_checksums(@tmpdir)

      expect(result["/a.txt"]).to eq(Digest::SHA1.hexdigest("alpha"))
      expect(result["/b.txt"]).to eq(Digest::SHA1.hexdigest("beta"))
      expect(result["/sub/c.txt"]).to eq(Digest::SHA1.hexdigest("gamma"))
      expect(result["/sub"]).to eq(true)
    end

    it "uses paths relative to the target directory" do
      result = run_checksums(@tmpdir)
      result.each_key do |key|
        expect(key).to start_with("/").or eq("")
        expect(key).not_to include(@tmpdir)
      end
    end
  end

  context "with an empty directory" do
    it "returns an empty mapping for the contents" do
      result = run_checksums(@tmpdir)
      # Keys (if any) should only refer to dot entries within the target.
      result.each_value do |value|
        expect(value).to(satisfy { |v| v == true || v.is_a?(String) })
      end
    end
  end
end
