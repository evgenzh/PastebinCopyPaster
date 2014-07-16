//
//  AppDelegate.m
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 16.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import "AppDelegate.h"

@implementation AppDelegate

- (void)awakeFromNib
{
    NSStatusBar *statusBar = [NSStatusBar systemStatusBar];
    _statusItem = [statusBar statusItemWithLength:NSVariableStatusItemLength];
    [_statusItem setTitle:@"PastebinCopyPaster"];
    [_statusItem setToolTip:@"This is our tool tip text"];
    [_statusItem setHighlightMode:YES];
    [_statusItem setMenu:_statusMenu];
}
- (IBAction)doSomething:(NSMenuItem *)sender {
    NSLog(@"Do something...");
}

@end
