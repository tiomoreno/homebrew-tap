class Teldrop < Formula
  desc "Telegram channel and chat downloader — TUI and CLI"
  homepage "https://github.com/tiomoreno/teldrop"
  version "0.1.0"
  if OS.mac?
    if Hardware::CPU.arm?
      url "https://github.com/tiomoreno/teldrop/releases/download/v0.1.0/teldrop-aarch64-apple-darwin.tar.xz"
      sha256 "dbe912a3bf62fdb4436724f4f1024a4ef2bbe2f3df3ec3ed3d7b78c8aebfd266"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tiomoreno/teldrop/releases/download/v0.1.0/teldrop-x86_64-apple-darwin.tar.xz"
      sha256 "c8a2cf1e1500772432b4f12c489b92324375e5d0bfe2939b5f2a9988df8efa79"
    end
  end
  if OS.linux?
    if Hardware::CPU.arm?
      url "https://github.com/tiomoreno/teldrop/releases/download/v0.1.0/teldrop-aarch64-unknown-linux-gnu.tar.xz"
      sha256 "42204f65499cf254a2c42633686714db301f30633f083f7ae8197ebac7fad51f"
    end
    if Hardware::CPU.intel?
      url "https://github.com/tiomoreno/teldrop/releases/download/v0.1.0/teldrop-x86_64-unknown-linux-gnu.tar.xz"
      sha256 "505a38928ec0a0cd6491d2ae47317314b939444f02b241542a363704c6fecb2c"
    end
  end

  BINARY_ALIASES = {
    "aarch64-apple-darwin":      {},
    "aarch64-unknown-linux-gnu": {},
    "x86_64-apple-darwin":       {},
    "x86_64-pc-windows-gnu":     {},
    "x86_64-unknown-linux-gnu":  {},
  }.freeze

  def target_triple
    cpu = Hardware::CPU.arm? ? "aarch64" : "x86_64"
    os = OS.mac? ? "apple-darwin" : "unknown-linux-gnu"

    "#{cpu}-#{os}"
  end

  def install_binary_aliases!
    BINARY_ALIASES[target_triple.to_sym].each do |source, dests|
      dests.each do |dest|
        bin.install_symlink bin/source.to_s => dest
      end
    end
  end

  def install
    bin.install "teldrop" if OS.mac? && Hardware::CPU.arm?
    bin.install "teldrop" if OS.mac? && Hardware::CPU.intel?
    bin.install "teldrop" if OS.linux? && Hardware::CPU.arm?
    bin.install "teldrop" if OS.linux? && Hardware::CPU.intel?

    install_binary_aliases!

    # Homebrew will automatically install these, so we don't need to do that
    doc_files = Dir["README.*", "readme.*", "LICENSE", "LICENSE.*", "CHANGELOG.*"]
    leftover_contents = Dir["*"] - doc_files

    # Install any leftover files in pkgshare; these are probably config or
    # sample files.
    pkgshare.install(*leftover_contents) unless leftover_contents.empty?
  end
end
