require "formula"

class Kf5Kdbusaddons < Formula
  desc "Addons to QtDBus"
  homepage "http://www.kde.org/"
  url "http://download.kde.org/stable/frameworks/5.39/kdbusaddons-5.39.0.tar.xz"
  sha256 "23477be1a3271d599be896477253fbcd9895ca8688ecb6771b290c5b522ae842"

  head "git://anongit.kde.org/kdbusaddons.git"

  depends_on "cmake" => :build
  depends_on "haraldf/kf5/kf5-extra-cmake-modules" => :build
  depends_on "qt"
  depends_on "shared-mime-info"
  depends_on "dbus"

  def install
    args = std_cmake_args

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install "install_manifest.txt"
    end
  end
end
