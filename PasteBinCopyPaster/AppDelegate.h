//
//  AppDelegate.h
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 16.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface AppDelegate : NSObject <NSApplicationDelegate>
{
    IBOutlet NSMenu *_statusMenu;
    NSStatusItem *_statusItem;
}


@end
