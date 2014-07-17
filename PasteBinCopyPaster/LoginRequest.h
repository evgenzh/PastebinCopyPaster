//
//  LoginRequest.h
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 17.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import "BaseRequest.h"

@interface LoginRequest : BaseRequest
@property (nonatomic, readonly) NSString *apiUserKey;
- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password;
@end
