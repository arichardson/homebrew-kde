class Kf5Krunner < Formula
  desc "Process launcher to speed up launching KDE applications"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.40/krunner-5.40.0.tar.xz"
  sha256 "4c389cc9e7338b72b986bfd247448290f21758c65eeb87cc762245f1ce14e0a5"

  head "git://anongit.kde.org/krunner.git"

  depends_on "cmake" => :build
  depends_on "gettext" => :build
  depends_on "doxygen" => :build
  depends_on "graphviz" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "KDE-mac/kde/kf5-kdoctools" => :build

  depends_on "qt"
  depends_on "KDE-mac/kde/kf5-threadweaver"

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
end
