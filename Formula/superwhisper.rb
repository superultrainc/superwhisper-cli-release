class Superwhisper < Formula
  desc "Search and browse your superwhisper transcription history"
  homepage "https://superwhisper.com"
  url "https://github.com/superultrainc/superwhisper-cli-release/releases/download/v0.1.0/superwhisper-v0.1.0-macos-universal.tar.gz"
  # Fill from checksums.txt on the v0.1.0 release.
  sha256 "REPLACE_AFTER_FIRST_RELEASE"
  version "0.1.0"
  license "MIT"

  def install
    bin.install "superwhisper"
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/superwhisper --version")
  end
end
