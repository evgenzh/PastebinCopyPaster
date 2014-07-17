//
//  AppDelegate.m
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 16.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalKeyLogger.h"

@interface AppDelegate () <GlobalKeyLoggerDelegate>
{
    GlobalKeyLogger *_globalKeyLogger;
}
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    _globalKeyLogger = [[GlobalKeyLogger alloc] init];
    _globalKeyLogger.delegate = self;
}

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
}

#pragma mark - GlobalKeyLoggerDelegate
- (void)systemDidReceiveCopyEvent {
    [_statusItem setTitle:[NSString stringWithFormat:@"COPY!!!"]];
}

- (void)systemDidReceivePasteEvent {
    [_statusItem setTitle:[NSString stringWithFormat:@"PASTE!!!"]];
}

- (void)systemDidReceiveSpecialEvent {
    [_statusItem setTitle:[NSString stringWithFormat:@"BOOO!!!"]];
}

@end
