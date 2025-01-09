class Qcachegrind < Formula
  desc "Visualize data generated by Cachegrind and Calltree"
  homepage "https://apps.kde.org/kcachegrind/"
  url "https://download.kde.org/stable/release-service/24.12.1/src/kcachegrind-24.12.1.tar.xz"
  sha256 "d38a1056daab0523955834648c9ce7e2e04536bad67f4f7b275834eaef336272"
  license "GPL-2.0-or-later"
  head "https://invent.kde.org/sdk/kcachegrind.git", branch: "master"

  # We don't match versions like 19.07.80 or 19.07.90 where the patch number
  # is 80+ (beta) or 90+ (RC), as these aren't stable releases.
  livecheck do
    url "https://download.kde.org/stable/release-service/"
    regex(%r{href=.*?v?(\d+\.\d+\.(?:(?![89]\d)\d+)(?:\.\d+)*)/?["' >]}i)
  end

  bottle do
    sha256 cellar: :any,                 arm64_sonoma:  "f79287eb8dab3287c45a4b2ead0f25e42263df20523db1592879e124d0fb96fa"
    sha256 cellar: :any,                 arm64_ventura: "6d486f3f64b3004b204c4d2f98ad9b80600c26eb724fcd69e72d3c17db8b1439"
    sha256 cellar: :any,                 sonoma:        "4738000060085f88555b16c4a8456ce53f11008924ae714b50a606178bffe1a0"
    sha256 cellar: :any,                 ventura:       "e334016fa6d66070e67092ba5366c977bb3a49ce37f4fe7cf38c448ec4cd2eb3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "78f502e10b5ec5b7bab2d1822cc0aa4db19cb017da86f4d2b1c7cd57091697e6"
  end

  depends_on "graphviz"
  depends_on "qt"

  def install
    args = %w[-config release]
    if OS.mac?
      spec = (ENV.compiler == :clang) ? "macx-clang" : "macx-g++"
      args += %W[-spec #{spec}]
    end

    qt = Formula["qt"]
    system qt.opt_bin/"qmake", *args
    system "make"

    if OS.mac?
      prefix.install "qcachegrind/qcachegrind.app"
      bin.install_symlink prefix/"qcachegrind.app/Contents/MacOS/qcachegrind"
    else
      bin.install "qcachegrind/qcachegrind"
    end
  end
end
