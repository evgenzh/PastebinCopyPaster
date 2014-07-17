//
//  AppDelegate.m
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 16.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import "AppDelegate.h"
#import "GlobalKeyLogger.h"
#import "PastebinRequester.h"

@interface AppDelegate () <GlobalKeyLoggerDelegate>
{
    GlobalKeyLogger *_globalKeyLogger;
    NSPasteboard *_pasteboard;
}
@end

@implementation AppDelegate

- (void)applicationDidFinishLaunching:(NSNotification *)notification {
    _globalKeyLogger = [[GlobalKeyLogger alloc] init];
    _globalKeyLogger.delegate = self;
    
    _pasteboard = [NSPasteboard generalPasteboard];
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
#ifdef DEBUG
    [self sendPasteToThePastebin];
#endif
}

#pragma mark - GlobalKeyLoggerDelegate
- (void)systemDidReceiveCopyEvent {
    [_statusItem setTitle:[NSString stringWithFormat:@"Press Cmd+Option+V"]];
}

- (void)systemDidReceivePasteEvent {
    [_statusItem setTitle:[NSString stringWithFormat:@"PastebinCopyPaster"]];
}

- (void)systemDidReceiveSpecialEvent {
    [self sendPasteToThePastebin];
}

#pragma mark - actions
- (void)sendPasteToThePastebin {
    [PastebinRequester loginWithUserName:@"EugeneZhuk" passwoed:@"mozerfucker666" withCompletion:^{
        [_statusItem setTitle:@"Loading..."];
        NSString *paste = [[_pasteboard readObjectsForClasses:@[[NSString class]] options:nil] lastObject];
        [PastebinRequester sendPaste:paste withCompletion:^(NSURL *url) {
            if (url) {
                [self writeToPasteBoard:url.absoluteString];
                [_statusItem setTitle:@"Your PASTEBIN url copied to the clipboard"];
            }
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                [_statusItem setTitle:[NSString stringWithFormat:@"PastebinCopyPaster"]];
            });
        }];
    }];
}

- (BOOL)writeToPasteBoard:(NSString *)stringToWrite
{
    [_pasteboard declareTypes:[NSArray arrayWithObject:NSStringPboardType] owner:nil];
    return [_pasteboard setString:stringToWrite forType:NSStringPboardType];
}

@end
