//
//  PasteRequest.m
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 16.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

//Required Params
/*
 1. api_dev_key - which is your unique API Developers Key.
 2. api_option - set as 'paste', this will indicate you want to create a new paste.
 3. api_paste_code - this is the text that will be written inside your paste.
 */

//Optional Params
/*
 1. api_user_key - this paramater is part of the login system, which is explained further down the page.
 2. api_paste_name - this will be the name / title of your paste.
 3. api_paste_format - this will be the syntax highlighting value, which is explained in detail further down the page.
 4. api_paste_private - this makes a paste public or private, public = 0, unlisted = 1, private = 2
 5. api_paste_expire_date - this sets the expiration date of your paste, the values are explained futher down the page.
 */

#import "PasteRequest.h"

@interface PasteRequest ()
{
    NSString *_paste;
}
@end

@implementation PasteRequest
+ (NSString *)apiMethod {
    return @"api_post.php";
}

+ (NSString *)apiAction {
    return @"paste";
}

- (instancetype)initWithPaste:(NSString *)paste {
    self = [super init];
    if (self) {
        _paste = paste;
    }
    return self;
}

- (void)setupParameters {
    if (_paste.length > 0) {
        _parameters = @{
                        @"api_paste_code"   : _paste,
                        };
    }
}

- (void)parseResult:(id)result {
    if (result && [result isKindOfClass:[NSString class]]) {
        _pastebinURL = [NSURL URLWithString:[result stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding]];
    }
}

@end
