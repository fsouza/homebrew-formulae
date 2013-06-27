require 'formula'

# Use the official github mirror, it is easier to find tags there
# .even versions are stable, .odd releases are devel. Kind of:
# https://code.google.com/p/v8/issues/detail?id=2545
# http://omahaproxy.appspot.com/

class V8Static < Formula
  homepage 'http://code.google.com/p/v8/'
  url 'https://github.com/v8/v8/archive/3.18.5.tar.gz'
  sha1 'd11c925898c5a0480aa947b1ed03b8f039d7e5d2'

  devel do
    url 'https://github.com/v8/v8/archive/3.19.16.tar.gz'
    sha1 'fa9862f805ce07d1dbaf5a9229ebbbbe616298f2'
  end

  head 'https://github.com/v8/v8.git'

  # gyp currently depends on a full xcode install
  # https://code.google.com/p/gyp/issues/detail?id=292
  depends_on :xcode

  def install
    system 'make dependencies'
    system 'make', 'native',
                   "-j#{ENV.make_jobs}",
                   "snapshot=on",
                   "console=readline"

    prefix.install 'include'
    cd 'out/native' do
      lib.install Dir['lib*']
      bin.install 'd8', 'lineprocessor', 'preparser', 'process', 'shell' => 'v8'
      bin.install Dir['mksnapshot.*']
    end
  end
end
