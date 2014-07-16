//
//  BaseRequest.h
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 16.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BaseRequest : NSMutableURLRequest
{
    NSDictionary *_parameters;
}

+ (NSString *)apiMethod;
+ (NSString *)apiAction;

- (void)setupParameters;
- (void)sendWithCompletionBlock:(void (^)(id result))completion;

@end
