Pod::Spec.new do |s|
  s.name                        = "Smart2Pay"
  s.version                     = '0.1.0'
  s.summary                     = "Mobile SDK to connect to Smart2Pay – a Nuvei Company – payment platform"
  s.description                 = <<-DESC
                                   By using Smart2Pay SDK for mobile, you can quickly integrate more payment options directly in your mobile application. Our SDK provides one unique interface to Cards, Alipay and WeChat in-app payments.
                                  DESC
  s.homepage                    = "https://docs.smart2pay.com/category/smart2pay-mobile-sdk"
  s.license                     = 'Commercial license'
  s.author                      = "Smart2Pay – a Nuvei Company"
  s.source                      = { :git => "git@github.com:Smart2Pay/SDK-iOS-release.git", :tag => s.version.to_s }
  s.platform                    = :ios, '13.0'
  s.requires_arc                = true
  s.ios.deployment_target       = "13.0"
  s.swift_version               = '5.1'
  s.libraries                   = 'c++','sqlite3.0','z'
  s.vendored_frameworks         = "Smart2Pay.framework"
  s.frameworks                  = 'CFNetwork','CoreMotion','CoreTelephony','Security','SystemConfiguration','UIKit'

  s.dependency 'SwiftyJSON'
  s.dependency 'Alamofire'
end
