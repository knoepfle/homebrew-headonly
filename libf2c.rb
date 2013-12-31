require 'formula'

# Follows the procedures from http://www.webmo.net/support/f2c_linux.html

class F2cHttpDownloadStrategy < CurlDownloadStrategy
  def stage
    super
    safe_system 'unzip', '-dlibf2c', 'libf2c.zip'
  end
end

class Libf2c < Formula
  homepage 'http://www.netlib.org/f2c/'
  head 'http://netlib.sandia.gov/cgi-bin/netlib/netlibfiles.tar?filename=netlib/f2c',
      :using => F2cHttpDownloadStrategy

  def install
    bin.install 'fc' => 'f77'

    chdir 'libf2c'
    system 'make', '-fmakefile.u'
    include.install 'f2c.h'
    lib.install 'libf2c.a'
  end
end
