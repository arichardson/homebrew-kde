require "formula"

class Kf5BreezeIcons < Formula
  desc "Breeze icon themes"
  homepage "http://www.kde.org/"
  url "http://download.kde.org/stable/frameworks/5.39/breeze-icons-5.39.0.tar.xz"
  sha256 "bd4077f88d106f7dcdefd8f260edbee597e72572e17f443ccd10d3a0eabb4b8c"

  head "git://anongit.kde.org/breeze-icons.git"

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt"

  def install
    args = std_cmake_args
    args << "-DBINARY_ICONS_RESOURCE=TRUE"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install "install_manifest.txt"
    end
  end

  def caveats; <<-EOS.undent
    You need to take some manual steps in order to make this formula work:
      ln -sf "#{HOMEBREW_PREFIX}/share/icons" "~/Library/Application Support/"
    EOS
  end
end
