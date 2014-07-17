//
//  PastebinRequester.m
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 17.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import "PastebinRequester.h"
#import "PasteRequest.h"
#import "LoginRequest.h"

@implementation PastebinRequester
+ (void)sendPaste:(NSString *)paste withCompletion:(void (^)(NSURL *url))completion {
    PasteRequest *request = [[PasteRequest alloc] initWithPaste:paste];
    [request sendWithCompletionBlock:^(BaseRequest *request) {
        PasteRequest *req = (PasteRequest *)request;
        if (completion) {
            completion(req.pastebinURL);
        }
    }];
}

+ (BOOL)canLogin {
    return [BaseRequest apiUserKeyExist];
}

+ (void)loginWithUserName:(NSString *)username passwoed:(NSString *)password withCompletion:(void (^)())completion {
    
    if ([self canLogin]) {
        if (completion) {
            completion();
        }
        return;
    }
    
    LoginRequest *request = [[LoginRequest alloc] initWithUsername:username password:password];
    [request sendWithCompletionBlock:^(BaseRequest *request) {
        LoginRequest *req = (LoginRequest *)request;
        if (req.apiUserKey.length > 0) {
            [BaseRequest saveApiUserKey:req.apiUserKey];
        }
        if (completion) {
            completion();
        }
    }];
}
@end
