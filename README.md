# CTTimer

解决NSTimer强制持有的问题，使用也比NSTimer方便。

[![CI Status](http://img.shields.io/travis/ishaolin/CTTimer.svg?style=flat)](https://travis-ci.org/ishaolin/CTTimer)
[![Version](https://img.shields.io/cocoapods/v/CTTimer.svg?style=flat)](http://cocoapods.org/pods/CTTimer)
[![License](https://img.shields.io/cocoapods/l/CTTimer.svg?style=flat)](http://cocoapods.org/pods/CTTimer)
[![Platform](https://img.shields.io/cocoapods/p/CTTimer.svg?style=flat)](http://cocoapods.org/pods/CTTimer)

## Example

To run the example project, clone the repo, and run `pod install` from the Example directory first.

## Requirements

iOS 8以上，ARC

## Installation

CTTimer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```objectivec
#import "CTTimer.h"

_timer = [CTTimer taskTimerWithConfig:^(CTTimerConfig *config) {
    config.target = self;
    config.action = @selector(timerAction:);
    config.interval = 1.0;
    config.repeats = YES;
}];

[_timer fire]; // 启动定时器
[_timer pause]; // 暂停定时器
[_timer resume]; // 定时器继续
[_timer invalidate]; // 停止定时器

// 定时器调用方法
- (void)timerAction:(CTTimer *)timer{
    // 做事
}
```

## Author

ishaolin, ishaolin@163.com

## License

CTTimer is available under the MIT license. See the LICENSE file for more info.
