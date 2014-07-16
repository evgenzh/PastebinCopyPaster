//
//  PasteRequest.h
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 16.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import "BaseRequest.h"

@interface PasteRequest : BaseRequest
+ (void)sendPaste:(NSString *)paste withComletion:(void (^)(NSURL *url))completion;
@end
