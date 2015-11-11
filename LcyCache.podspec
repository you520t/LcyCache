Pod::Spec.new do |s|
  s.name         = "LcyCache"
  s.version      = “1.0.2”
  s.summary      = "Cache data."
  s.homepage     = "https://github.com/you520t/LcyCache"
  s.license      = 'MIT'
  s.author       = { "Chenyu Liao" => "you520t@163.com" }
  s.platform     = :ios, "7.0"
  s.ios.deployment_target = "7.0"
  s.source       = { :git => "https://github.com/you520t/LcyCache.git", :tag => s.version}
  s.source_files  = 'LcyCache/Classes/*.{h,m}'
  s.requires_arc = true
end
