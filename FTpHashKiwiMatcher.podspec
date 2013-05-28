Pod::Spec.new do |s|
  s.name         = "FTpHashKiwiMatcher"
  s.version      = "0.0.1"
  s.summary      = "A Kiwi matcher that uses pHash to check for differences between images."
  s.homepage     = "http://github.com/Fingertips/FTpHashKiwiMatcher"
  s.license      = 'MIT' # cimg and phash have GPL type of licenses...
  s.author       = { "Eloy Durán" => "eloy.de.enige@gmail.com" }
  s.source       = { :git => "http://github.com/Fingertips/FTpHashKiwiMatcher.git", :tag => "0.0.1" }
  s.platform     = :osx

  s.source_files = 'FTpHashKiwiMatcher.{h,m}'
  s.preserve_paths = "install-dependencies"

  s.requires_arc = true

  homebrew_prefix = `brew --prefix`.strip
  raise "No homebrew installation found!" if homebrew_prefix.empty?
  s.xcconfig = {
    'HEADER_SEARCH_PATHS' => File.join(homebrew_prefix, 'include'),
    'LIBRARY_SEARCH_PATHS' => File.join(homebrew_prefix, 'lib')
  }
  s.libraries = 'jpeg', 'pHash'

  s.dependency 'Kiwi', '~> 2.0'
end
