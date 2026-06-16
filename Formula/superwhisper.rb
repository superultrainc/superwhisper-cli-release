class Superwhisper < Formula
  desc "Search and browse your superwhisper transcription history"
  homepage "https://superwhisper.com"
  url "https://github.com/superultrainc/superwhisper-cli-release/releases/download/v0.1.0/superwhisper-v0.1.0-macos-universal.tar.gz"
  version "0.1.0"
  sha256 "455175349ecd226384e89820f668c080701b7900d841243a3c2707a9aec73860"
  license "MIT"

  def install
    bin.install "superwhisper"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/superwhisper --version")
  end
end
