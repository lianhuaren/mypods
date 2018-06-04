//
//  CrashHopper.m
//  CrashHopper
//
//  Created by guoyuan on 2017/4/13.
//  Copyright © 2017年 guoyuan. All rights reserved.
//

#import "CrashHopper.h"
#import "NSObject+CrashHopper.h"
#import "CrashHopperFileHandler.h"

void methodSwizzling(void) {
    // Unrecognized selector
    [NSObject swizzleInstanceMethod:@selector(forwardingTargetForSelector:) with:@selector(hopper_forwardingTargetForSelector:)];
}

@implementation CrashHopper

+ (instancetype)sharedInstance {
    static CrashHopper *hopper = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        hopper = [CrashHopper new];
    });
    return hopper;
}

- (void)start {
    if (self.isStart) {
        return;
    }
    self.isStart = YES;
    methodSwizzling();
}

- (void)stop {
    if (!self.isStart) {
        return;
    }
    self.isStart = NO;
    methodSwizzling();
}

- (void)dealWithLog:(CrashHopperLog *)log {
    [[CrashHopperFileHandler sharedInstance] saveWithLog:log];
    [log outputToConsole];
}

@end
