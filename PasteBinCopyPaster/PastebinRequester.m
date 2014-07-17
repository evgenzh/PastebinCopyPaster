//
//  PastebinRequester.m
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 17.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import "PastebinRequester.h"
#import "PasteRequest.h"

@implementation PastebinRequester
+ (void)sendPaste:(NSString *)paste withComletion:(void (^)(NSURL *url))completion {
    PasteRequest *request = [[PasteRequest alloc] initWithPaste:paste];
    [request sendWithCompletionBlock:^(BaseRequest *request) {
        PasteRequest *req = (PasteRequest *)request;
        if (completion) {
            completion(req.pastebinURL);
        }
    }];
}
@end
