fastlane documentation
================
# Installation

Make sure you have the latest version of the Xcode command line tools installed:

```
xcode-select --install
```

Install _fastlane_ using
```
[sudo] gem install fastlane -NV
```
or alternatively using `brew install fastlane`

# Available Actions
## iOS
### ios prepare
```
fastlane ios prepare
```
打包前的准备工作
### ios summary
```
fastlane ios summary
```
信息确认
### ios update_version
```
fastlane ios update_version
```
更新版本号
### ios release
```
fastlane ios release
```
打包发布
### ios release_appstore
```
fastlane ios release_appstore
```
发布到appstore
### ios release_development
```
fastlane ios release_development
```
发布development
### ios release_adhoc
```
fastlane ios release_adhoc
```
发布ad-hoc
### ios release_enterprise
```
fastlane ios release_enterprise
```
发布企业Inhouse
### ios deliver_pgyer
```
fastlane ios deliver_pgyer
```
上传到蒲公英
### ios deliver_firm
```
fastlane ios deliver_firm
```
上传到Firm
### ios deliver_appstore
```
fastlane ios deliver_appstore
```
上传到appstore
### ios build
```
fastlane ios build
```
打包

----

This README.md is auto-generated and will be re-generated every time [_fastlane_](https://fastlane.tools) is run.
More information about fastlane can be found on [fastlane.tools](https://fastlane.tools).
The documentation of fastlane can be found on [docs.fastlane.tools](https://docs.fastlane.tools).
