//
//  CoreMacros.h
//  Core
//
//  Created by Jerry on 2017/8/2.
//  Copyright © 2017年 com.yhd. All rights reserved.
//

#ifndef CoreMacros_h
#define CoreMacros_h

//weak strong self for retain cycle
#define WEAK_SELF __weak typeof(self)weakSelf = self
#define STRONG_SELF __strong typeof(weakSelf)self = weakSelf

//单例
#undef	DEF_SINGLETON
#define DEF_SINGLETON( __class ) \
+ (instancetype)sharedInstance { \
    static dispatch_once_t once; \
    static __class * __singleton__; \
    dispatch_once(&once, ^{\
        __singleton__ = [[__class alloc] init];\
    });\
    return __singleton__; \
}

//log
#ifdef DEBUG
    #define PBLog(format, ...) NSLog((@"%s@%d: " format), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__)
#else
    #define PBLog(format, ...)
#endif

#define PBFuncLog PBLog(@"[%@ call %@]", [self class], NSStringFromSelector(_cmd))

//remove perform selector leak warning
#define PBSuppressPerformSelectorLeakWarning(Stuff) \
do { \
_Pragma("clang diagnostic push") \
_Pragma("clang diagnostic ignored \"-Warc-performSelector-leaks\"") \
Stuff; \
_Pragma("clang diagnostic pop") \
} while (0)

#endif /* CoreMacros_h */

