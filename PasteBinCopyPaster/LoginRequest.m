//
//  LoginRequest.m
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 17.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import "LoginRequest.h"

@interface LoginRequest ()
{
    NSString *_username;
    NSString *_password;
}
@end

@implementation LoginRequest
+ (NSString *)apiMethod {
    return @"api_login.php";
}

- (instancetype)initWithUsername:(NSString *)username password:(NSString *)password {
    self = [super init];
    if (self) {
        _username = username;
        _password = password;
    }
    return self;
}

- (void)setupParameters {
    if (_username.length > 0 && _password.length > 0) {
        _parameters = @{
                        @"api_user_name"        :_username,
                        @"api_user_password"    :_password,
                        };
    }
}

- (void)parseResult:(id)result {
    if (result && [result isKindOfClass:[NSString class]]) {
        _apiUserKey = result;
    }
}
@end
