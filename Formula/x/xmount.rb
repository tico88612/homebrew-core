class Xmount < Formula
  desc "Convert between multiple input & output disk image types"
  homepage "https://www.sits.lu/xmount"
  url "https://code.sits.lu/foss/xmount/-/archive/1.2.0/xmount-1.2.0.tar.bz2"
  sha256 "07c261e54e1e4cbcd4f7eaaf4f62efcbbbc68c76797ddca704592d99ebed3d10"
  license "GPL-3.0-or-later"

  bottle do
    sha256 x86_64_linux: "7693dc80c9ce82caf5cf123dac6bbe8b94be092e1e1c3dcc1c7715deeb40c41e"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "afflib"
  depends_on "libewf"
  depends_on "libfuse"
  depends_on :linux # on macOS, requires closed-source macFUSE
  depends_on "zlib"

  def install
    system "cmake", "-S", ".", "-B", "build", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    system bin/"xmount", "--version"
  end
end
