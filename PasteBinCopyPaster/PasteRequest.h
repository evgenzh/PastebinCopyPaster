//
//  PasteRequest.h
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 16.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import "BaseRequest.h"

@interface PasteRequest : BaseRequest
@property (nonatomic, readonly) NSURL *pastebinURL;

- (instancetype)initWithPaste:(NSString *)paste;
@end
