# CTTimer

解决NSTimer强制持有的问题，使用也比NSTimer方便。

[![Version](https://img.shields.io/cocoapods/v/CTTimer.svg?style=flat)](http://cocoapods.org/pods/CTTimer)
[![License](https://img.shields.io/cocoapods/l/CTTimer.svg?style=flat)](http://cocoapods.org/pods/CTTimer)
[![Platform](https://img.shields.io/cocoapods/p/CTTimer.svg?style=flat)](http://cocoapods.org/pods/CTTimer)

## Requirements

iOS 8以上，ARC

## Installation

CTTimer is available through [CocoaPods](http://cocoapods.org). To install
it, simply add the following line to your Podfile:

```ruby
pod 'CTTimer'
```

## Example
```objectivec
// 头文件引入
#import <CTTimer/CTTimer.h>

// 创建定时器
_timer = [CTTimer taskTimerWithConfig:^(CTTimerConfig *config) {
    config.target = self;
    config.action = @selector(timerAction:);
    config.interval = 1.0;
    config.repeats = YES;
}];

// 启动定时器
[_timer fire];
// 暂停定时器
[_timer pause];
// 定时器继续
[_timer resume];
// 停止定时器
[_timer invalidate];

// 定时器调用方法
- (void)timerAction:(CTTimer *)timer{
    // 做事
}

- (void)dealloc{
    if(_timer.isValid){
        [_timer invalidate];
    }
    
    _timer = nil;
}
```

## Author

ishaolin, ishaolin@163.com

## License

CTTimer is available under the MIT license. See the LICENSE file for more info.
