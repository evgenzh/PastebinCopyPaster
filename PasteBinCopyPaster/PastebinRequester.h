//
//  PastebinRequester.h
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 17.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PastebinRequester : NSObject
//paste
+ (void)sendPaste:(NSString *)paste withComletion:(void (^)(NSURL *url))completion;

//profile
//will be in future
@end
