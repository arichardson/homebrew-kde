class Kf5Kdelibs4support < Formula
  desc "Porting aid from KDELibs4"
  homepage "https://www.kde.org"
  url "https://download.kde.org/stable/frameworks/5.40/portingAids/kdelibs4support-5.40.0.tar.xz"
  sha256 "f9d7508aa6a72a186ba7d922e82ca49a5ac5d76e1fa02af995d17208128995df"

  head "git://anongit.kde.org/kdelibs4support.git"

  depends_on "cmake" => :build
  depends_on "KDE-mac/kde/kf5-extra-cmake-modules" => :build
  depends_on "KDE-mac/kde/kf5-kdesignerplugin" => :build
  depends_on "KDE-mac/kde/kf5-kdoctools" => :build

  depends_on "qt"
  depends_on "openssl"
  depends_on "docbook"
  depends_on "KDE-mac/kde/kf5-kded"
  depends_on "KDE-mac/kde/kf5-kemoticons"
  depends_on "KDE-mac/kde/kf5-kinit"
  depends_on "KDE-mac/kde/kf5-kitemmodels"
  depends_on "KDE-mac/kde/kf5-kunitconversion"
  depends_on "KDE-mac/kde/kf5-kparts"

  patch :DATA

  def install
    args = std_cmake_args
    args << "-DBUILD_TESTING=OFF"
    args << "-DBUILD_QCH=ON"
    args << "-DKDE_INSTALL_QMLDIR=lib/qt5/qml"
    args << "-DKDE_INSTALL_PLUGINDIR=lib/qt5/plugins"
    args << "-DCMAKE_INSTALL_BUNDLEDIR=#{bin}"

    mkdir "build" do
      system "cmake", "..", *args
      system "make", "install"
      prefix.install "install_manifest.txt"
      system "/usr/libexec/PlistBuddy",
        "-c", "Add :LSEnvironment:QT_PLUGIN_PATH string \"#{HOMEBREW_PREFIX}/lib/qt5/plugins\"",
        "#{bin}/kdebugdialog5.app/Contents/Info.plist"
    end
  end

  def caveats; <<-EOS.undent
    You need to take some manual steps in order to make this formula work:
      mkdir -p ~/Applications/KDE
      ln -sf "#{prefix}/bin/kdebugdialog5.app" ~/Applications/KDE/
    EOS
  end
end

# Patch based from
# https://github.com/KDE/kdoctools/blob/master/cmake/FindDocBookXML4.cmake
# Also fix typo(?)

__END__
diff --git a/cmake/FindDocBookXML4.cmake b/cmake/FindDocBookXML4.cmake
index dcc0cf66..6fbf4ebb 100644
--- a/cmake/FindDocBookXML4.cmake
+++ b/cmake/FindDocBookXML4.cmake
@@ -11,8 +11,29 @@
 
 # Copyright (c) 2010, 2014 Luigi Toscano, <luigi.toscano@tiscali.it>
 #
-# Redistribution and use is allowed according to the terms of the BSD license.
-# For details see the accompanying COPYING-CMAKE-SCRIPTS file.
+# Redistribution and use in source and binary forms, with or without
+# modification, are permitted provided that the following conditions
+# are met:
+# 1. Redistributions of source code must retain the above copyright
+#    notice, this list of conditions and the following disclaimer.
+# 2. Redistributions in binary form must reproduce the above copyright
+#    notice, this list of conditions and the following disclaimer in the
+#    documentation and/or other materials provided with the distribution.
+# 3. Neither the name of the University nor the names of its contributors
+#    may be used to endorse or promote products derived from this software
+#    without specific prior written permission.
+#
+# THIS SOFTWARE IS PROVIDED BY THE REGENTS AND CONTRIBUTORS ``AS IS'' AND
+# ANY EXPRESS OR IMPLIED WARRANTIES, INCLUDING, BUT NOT LIMITED TO, THE
+# IMPLIED WARRANTIES OF MERCHANTABILITY AND FITNESS FOR A PARTICULAR PURPOSE
+# ARE DISCLAIMED.  IN NO EVENT SHALL THE REGENTS OR CONTRIBUTORS BE LIABLE
+# FOR ANY DIRECT, INDIRECT, INCIDENTAL, SPECIAL, EXEMPLARY, OR CONSEQUENTIAL
+# DAMAGES (INCLUDING, BUT NOT LIMITED TO, PROCUREMENT OF SUBSTITUTE GOODS
+# OR SERVICES; LOSS OF USE, DATA, OR PROFITS; OR BUSINESS INTERRUPTION)
+# HOWEVER CAUSED AND ON ANY THEORY OF LIABILITY, WHETHER IN CONTRACT, STRICT
+# LIABILITY, OR TORT (INCLUDING NEGLIGENCE OR OTHERWISE) ARISING IN ANY WAY
+# OUT OF THE USE OF THIS SOFTWARE, EVEN IF ADVISED OF THE POSSIBILITY OF
+# SUCH DAMAGE.
 
 
 if (NOT DocBookXML_FIND_VERSION)
@@ -30,10 +51,12 @@ set_package_properties(DocBookXML4 PROPERTIES DESCRIPTION "DocBook XML 4"
 function (locate_version version found_dir)
 
     set (DTD_PATH_LIST
-        share/xml/docbook/schema/dtd/${version}
-        share/xml/docbook/xml-dtd-${version}
-        share/sgml/docbook/xml-dtd-${version}
-        share/xml/docbook/${version}
+        ${CMAKE_INSTALL_DATAROOTDIR}/xml/docbook/schema/dtd/${version}
+        ${CMAKE_INSTALL_DATAROOTDIR}/xml/docbook/xml-dtd-${version}
+        ${CMAKE_INSTALL_DATAROOTDIR}/sgml/docbook/xml-dtd-${version}
+        ${CMAKE_INSTALL_DATAROOTDIR}/xml/docbook/${version}
+        #for building on Mac with docbook installed by homebrew
+        opt/docbook/docbook/xml/${version}
     )
 
     find_path (searched_dir docbookx.dtd
diff --git a/src/CMakeLists.txt b/src/CMakeLists.txt
index 469cc58a..3c8cee1a 100644
--- a/src/CMakeLists.txt
+++ b/src/CMakeLists.txt
@@ -376,7 +376,7 @@ target_link_libraries(kf5deprecatedwidgets KF5::KDELibs4Support
                                     KF5::Auth
                                     )
 
-install(TARGETS kf5deprecatedwidgets DESTINATION ${KDE_INSTALL_QTPLUGINDIR}/designer)
+install(TARGETS kf5deprecatedwidgets DESTINATION ${KDE_INSTALL_PLUGINDIR}/designer)
 
 ##########
 

