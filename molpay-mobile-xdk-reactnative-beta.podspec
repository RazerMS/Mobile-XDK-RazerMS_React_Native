require 'json'

package = JSON.parse(File.read(File.join(__dir__, 'package.json')))

Pod::Spec.new do |s|
  s.name	 = "molpay-mobile-xdk-reactnative-beta"
  s.version      = package['version']
  s.summary      = "Razer Merchant Services mobile payment for React Native (BETA)"

  s.authors      = { "MOLPay Mobile Team" => "mobile-sa@razer.com" }
  s.homepage     = "https://github.com/MOLPay/rms-mobile-xdk-reactnative-beta#readme"
  s.license      = "MIT"
  s.platform     = :ios, "8.0"

  s.source       = { :git => "https://github.com/MOLPay/rms-mobile-xdk-reactnative-beta" }
  s.source_files  = "ios/*.{h,m}"
  s.resource = 'ios/MOLPayXDK.bundle' 

  s.dependency 'React'
end
