class Mpir < Formula
  desc "Multiple Precision Integers and Rationals (fork of GMP)"
  homepage "https://web.archive.org/web/20221207200514/https://mpir.org/"
  url "https://web.archive.org/web/20220224004857/https://mpir.org/mpir-3.0.0.tar.bz2"
  sha256 "52f63459cf3f9478859de29e00357f004050ead70b45913f2c2269d9708675bb"
  license "GPL-3.0-or-later"

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "c4461a370b046be222b3df2bd7632e3d0148760b6ff93dacc81884a51e6a8e9e"
    sha256 cellar: :any,                 arm64_ventura:  "d0d0de5cb3a2d67576674b5057c408e6f539fb3a330a8edffae0bfeefe90d9af"
    sha256 cellar: :any,                 arm64_monterey: "047110a0c73f2c6224609727d07e6e581b4e7f3f57de477971b0d4e795a9af29"
    sha256 cellar: :any,                 arm64_big_sur:  "dcfb7c5e0b679f0d3cc14ec76fa3a565f8b521ba19a2d6212e6f39b27f220a6c"
    sha256 cellar: :any,                 sonoma:         "bcc8e5538db5d3fd1defbe8c4e472803df5472ce1ce2621e52487b163dd77335"
    sha256 cellar: :any,                 ventura:        "14481c170832dd53b3c268c9e7d7ae469db95e1bcffe8497902b3951db386766"
    sha256 cellar: :any,                 monterey:       "8b2b3fe7672e36b0323c3fefff3cac5e68eb48b249829a23ffac5c60056b75f6"
    sha256 cellar: :any,                 big_sur:        "2364f0bb79cf8a0ef739f077eaacc7228fd89d39d18d0b9f1e135a2577472684"
    sha256 cellar: :any,                 catalina:       "884e9e0b62c809c531c55d6da43fbebadd5428976afbf95d2dc8968599e6e013"
    sha256 cellar: :any,                 mojave:         "1b930468cbd16840c9c689b8b24c91ce45a136b7512ccd06b6c13a14cd5405e2"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "255666a3f9f3520885fba30dbe76714a89a10d914473e6cf834f55caba125a2a"
  end

  disable! date: "2024-02-12", because: :unmaintained

  depends_on "autoconf" => :build
  depends_on "automake" => :build
  depends_on "libtool" => :build
  depends_on "yasm" => :build

  # Fix Xcode 12 build: https://github.com/wbhart/mpir/pull/292
  patch do
    url "https://github.com/wbhart/mpir/commit/bbc43ca6ae0bec4f64e69c9cd4c967005d6470eb.patch?full_index=1"
    sha256 "8c0ec267c62a91fe6c21d43467fee736fb5431bd9e604dc930cc71048f4e3452"
  end

  def install
    # Regenerate ./configure script due to patch above
    system "autoreconf", "--force", "--install", "--verbose"
    system "./configure", "--disable-silent-rules", "--enable-cxx", *std_configure_args
    system "make", "install"
  end

  test do
    (testpath/"test.c").write <<~C
      #include <mpir.h>
      #include <stdlib.h>

      int main() {
        mpz_t i, j, k;
        mpz_init_set_str (i, "1a", 16);
        mpz_init (j);
        mpz_init (k);
        mpz_sqrtrem (j, k, i);
        if (mpz_get_si (j) != 5 || mpz_get_si (k) != 1) abort();
        return 0;
      }
    C
    system ENV.cc, "test.c", "-I#{include}", "-L#{lib}", "-lmpir", "-o", "test"
    system "./test"
  end
end
