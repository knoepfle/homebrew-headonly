require 'formula'

# Follows the procedures from http://www.webmo.net/support/f2c_linux.html

class F2cHttpDownloadStrategy < CurlDownloadStrategy
  def stage
    super
    safe_system 'unzip', '-dlibf2c', 'libf2c.zip'
  end
end

class F2c < Formula
  homepage 'http://www.netlib.org/f2c/'
  url 'http://netlib.sandia.gov/cgi-bin/netlib/netlibfiles.tar?filename=netlib/f2c',
      :using => F2cHttpDownloadStrategy

  def install
    bin.install 'fc' => 'f77'

    chdir 'libf2c'
    system 'make', '-fmakefile.u'
    include.install 'f2c.h'
    lib.install 'libf2c.a'

    chdir '../src'
    system 'make', '-fmakefile.u'
    bin.install 'f2c'
    man.install 'f2c.1t'
  end

  test do
    open("hello.f", "w") do |file|
      file.write <<-EOS.undent
        C1234567890
        C    Hello world
              program hello
              print *, 'Hello!'
              end
      EOS
    end
    system "#{bin}/f2c", 'hello.f'
    system ENV.cc, 'hello.c', '-lf2c', '-o hello'
  end

end
