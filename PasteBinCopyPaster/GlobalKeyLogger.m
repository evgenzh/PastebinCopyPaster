//
//  GlobalKeyLogger.m
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 17.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import "GlobalKeyLogger.h"

enum KeyCodes {
    keyCodeC = 8,
    keyCodeV = 9,
};

@interface GlobalKeyLogger ()
{
    id _eventMonitor;
    BOOL _canReceiveSpaecialEvent; //We`ll can receive special keyvoard event only after copy event
}
@end

@implementation GlobalKeyLogger
- (instancetype)init {
    self = [super init];
    if (self) {
        _canReceiveSpaecialEvent = NO;
#ifndef DEBUG
        if (!AXIsProcessTrusted()) {
            NSDictionary *options = @{(__bridge id)kAXTrustedCheckOptionPrompt: @YES};
            AXIsProcessTrustedWithOptions((__bridge CFDictionaryRef)options);
            [NSApp terminate: nil];
        } else {
            __weak GlobalKeyLogger *weakRef = self;
            _eventMonitor = [NSEvent addGlobalMonitorForEventsMatchingMask:NSKeyUpMask handler:^(NSEvent *event) {
                [weakRef handleEvent:event];
            }];
        }
#endif
    }
    return self;
}

- (void)dealloc {
    if (_eventMonitor) {
        [NSEvent removeMonitor:_eventMonitor];
        _eventMonitor = nil;
    }
}

#pragma mark - event handler
- (void)handleEvent:(NSEvent *)event {
    //copy&paste event handling
    if ([event modifierFlags] & NSCommandKeyMask) {
        if ([event modifierFlags] & NSAlternateKeyMask) {
            if (_canReceiveSpaecialEvent) {
                if (event.keyCode == keyCodeV) {
                    if (_delegate && [_delegate respondsToSelector:@selector(systemDidReceiveSpecialEvent)]) {
                        [_delegate systemDidReceiveSpecialEvent];
                    }
                }
                _canReceiveSpaecialEvent = NO;
            }
        } else {
            switch (event.keyCode) {
                case keyCodeC:
                    _canReceiveSpaecialEvent = YES;
                    if (_delegate && [_delegate respondsToSelector:@selector(systemDidReceiveCopyEvent)]) {
                        [_delegate systemDidReceiveCopyEvent];
                    }
                    break;
                case keyCodeV:
                    _canReceiveSpaecialEvent = NO;
                    if (_delegate && [_delegate respondsToSelector:@selector(systemDidReceivePasteEvent)]) {
                        [_delegate systemDidReceivePasteEvent];
                    }
                    break;
                default:
                    break;
            }
        }
    }
}
@end
