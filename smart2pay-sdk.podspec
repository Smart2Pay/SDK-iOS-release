Pod::Spec.new do |s|
  s.name                        = "smart2pay-sdk"
  s.version                     = '1.0.0'
  s.summary                     = "Mobile SDK to connect to Smart2Pay – a Nuvei Company – payment platform"
  s.description                 = <<-DESC
                                   By using Smart2Pay SDK for mobile, you can quickly integrate more payment options directly in your mobile application. Our SDK provides one unique interface to Cards, Alipay and WeChat in-app payments.
                                  DESC
  s.homepage                    = "https://docs.smart2pay.com/category/smart2pay-mobile-sdk"
  s.license                     = { :type => 'Commercial', :file => 'LICENSE.md' }
  s.author                      = "Smart2Pay – a Nuvei Company"
  s.source                      = { :git => "https://github.com/Smart2Pay/SDK-iOS-release.git", :tag => s.version.to_s }
  s.module_name                 = 'Smart2Pay'
  s.platform                    = :ios, '13.0'
  s.requires_arc                = true
  s.ios.deployment_target       = '12.1'
  s.swift_version               = ['5.0', '5.1', '5.2']
  s.libraries                   = 'c++','sqlite3.0','z'
  s.vendored_frameworks         = "Smart2Pay.framework"
  s.frameworks                  = 'CFNetwork','CoreMotion','CoreTelephony','Security','SystemConfiguration','UIKit'

  s.xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
  s.pod_target_xcconfig = { 'EXCLUDED_ARCHS[sdk=iphonesimulator*]' => 'arm64' }
end
