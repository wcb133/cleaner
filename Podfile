#使用国内Spec源，终端执行以下命令
#cd ~/.cocoapods/repos
#pod repo remove master
#git clone https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git master
#自己工程的podFile第一行加上 source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

#恢复官方Spec源
#cd ~/.cocoapods/repos
#pod repo remove master
#git clone https://github.com/CocoaPods/Specs master
#自己工程的podFile第一行加上 sources 'https://github.com/CocoaPods/Specs'

source 'https://mirrors.tuna.tsinghua.edu.cn/git/CocoaPods/Specs.git'

platform :ios, '12.0'

target 'Cleaner' do
  use_frameworks!

  pod 'QMUIKit'
  pod 'iCarousel'
  pod 'RxSwift'
  pod 'RxCocoa'
  pod 'NSObject+Rx' #提供rx_disposeBag
  pod 'Moya'
  pod 'SnapKit'
  pod 'SnapKitExtend', '~> 1.0.7'
  pod 'BaiduMobStatCodeless' #无埋点
#  pod 'JPush'
  pod 'UMCCommon'

end
