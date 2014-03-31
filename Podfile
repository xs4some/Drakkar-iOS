platform :ios, '7.0'

xcodeproj 'Drakkar.xcodeproj'

#pod 'AFOAuth1Client'
#pod 'FlurrySDK'
pod 'MKNetworkKit'
pod 'TYMProgressBarView'
pod 'ViewDeck'
pod 'Toast'	
pod 'RNCryptor'
pod 'KeychainItemWrapper'

post_install do | installer |
  require 'fileutils'
  FileUtils.cp_r('Pods/Pods-Acknowledgements.plist', 'Drakkar/Resources/Acknowledgements.plist', :remove_destination => true)
end

