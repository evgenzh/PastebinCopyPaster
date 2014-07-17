//
//  GlobalKeyLogger.h
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 17.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol GlobalKeyLoggerDelegate <NSObject>
- (void)systemDidReceiveCopyEvent;
- (void)systemDidReceivePasteEvent;
- (void)systemDidReceiveSpecialEvent;
@end

@interface GlobalKeyLogger : NSObject
@property (nonatomic, weak) id <GlobalKeyLoggerDelegate> delegate;
@end
