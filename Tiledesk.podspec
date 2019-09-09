Pod::Spec.new do |s|

s.platform = :ios
s.ios.deployment_target = '10.0'
s.name = "Tiledesk"
s.summary = "Tiledesk adds a Live Chat to your iOS App."

s.description  = <<-DESC
Tiledesk SDK adds Live Chat messaging to your App. Swift and Objc supported.
                   DESC

s.requires_arc = true

s.version = "0.1.3"

s.license = { :type => "MIT", :file => "LICENSE" }

s.author = { "Andrea Sponziello" => "andreasponziello@tiledesk.com" }

s.homepage = "https://www.tiledesk.com"

s.source = { :git => "https://github.com/tiledesk/tiledesk-ios-sdk.git", :tag => "#{s.version}" }

s.static_framework = true
s.dependency 'Chat21'

s.source_files  = "Tiledesk/**/*.{h,m}"

s.resources = "Resources/**/*.{png,jpeg,jpg,storyboard,xib,xcassets,caf,plist,lproj}"

s.public_header_files = 'Tiledesk/**/*.h'

end
