class Kf5ExtraCmakeModules < Formula
  desc "Extra modules and scripts for CMake"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.40/extra-cmake-modules-5.40.0.tar.xz"
  sha256 "83e48889c84474e4f560e10e4eea0cc529f8511b3bd0415fcb898ac0496e630a"

  head "git://anongit.kde.org/extra-cmake-modules"

  depends_on "cmake" => :build
  depends_on "qt" => :build

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install "install_manifest.txt"
    end
  end

  def caveats; <<-EOS.undent
    You need to take some manual steps in order to make this formula work:
      ln -sf "$(brew --prefix)/share/kf5" ~/Library/"Application Support"
      ln -sf "$(brew --prefix)/share/kxmlgui5" ~/Library/"Application Support"
    EOS
  end
end
