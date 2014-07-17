//
//  BaseRequest.m
//  PasteBinCopyPaster
//
//  Created by applecenterinua on 16.07.14.
//  Copyright (c) 2014 Eugene Zhuk. All rights reserved.
//

#import "BaseRequest.h"

#define DEFAULT_REQUEST_TIMOUT 20

NSString * const kBadResponseErrorPrefix = @"Bad API request,";
NSString * const kPostLimitErrorPrefix = @"Post limit,";

NSString * const kRequestErrorDomain = @"kRequestErrorDomain";
NSString * const kRequestErrorDescriptionKey = @"kErrorDescriptionKey";

NSString * const kDevKey = @"94a4009895c50596fe7dd0c4d6fd1e2a";

//name of value in NSUserDefalts
NSString * const kApiUserKeyPath = @"kApiUserKeyPath";

@implementation BaseRequest

+ (NSOperationQueue *)sharedQueue {
    static NSOperationQueue *sharedQueue;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        sharedQueue = [NSOperationQueue new];
        [sharedQueue setName:@"com.pastebinCopyPaster"];
    });
    return sharedQueue;
}

+ (NSString *)apiMethod {
    return nil;
}

+ (NSString *)apiAction {
    return nil;
}

+ (NSURL *)url {
    return [NSURL URLWithString:[@"http://pastebin.com/api/" stringByAppendingString:[[self class] apiMethod]]];
}

// if an invalid api_user_key or no key is used, the paste will be create as a guest
+ (NSString *)apiUserKey {
    return [[NSUserDefaults standardUserDefaults] stringForKey:kApiUserKeyPath];
}

+ (BOOL)apiUserKeyExist {
    return ([self apiUserKey] != nil);
}
+ (void)saveApiUserKey:(NSString *)apiUserKey {
    [[NSUserDefaults standardUserDefaults] setValue:apiUserKey forKey:kApiUserKeyPath];
}

- (void)sendWithCompletionBlock:(void (^)(BaseRequest *request))completion {
    __weak BaseRequest *request = self;
    [request setupRequest];
    [NSURLConnection sendAsynchronousRequest:request queue:[[self class] sharedQueue] completionHandler:^(NSURLResponse *response, NSData *data, NSError *connectionError) {
        if (!connectionError) {
            NSError *error;
            id result = [request resultFromData:data error:&error];
            if (!error) {
                [request parseResult:result];
                if (completion) {
                    completion(request);
                }
            } else {
                NSLog(@"Erro!r: %@", [error description]);
                //TODO: errors handling
                if (completion) {
                    completion(nil);
                }
            }
        } else {
            NSLog(@"Error: %@", [connectionError description]);
            //TODO: connection errors handling
            if (completion) {
                completion(nil);
            }
        }
    }];
}

#pragma mark - init
- (instancetype)init {
    NSLog(@"%@", [[self class] url]);
    return [super initWithURL:[[self class] url] cachePolicy:NSURLRequestUseProtocolCachePolicy timeoutInterval:DEFAULT_REQUEST_TIMOUT];
}

//override this method in the child clssses
- (void)setupParameters {
}

- (void)setupRequest {
    [self setupParameters];
    NSMutableString *postString = [NSMutableString new];
    [postString appendFormat:@"api_dev_key=%@", kDevKey];
    if ([[self class] apiUserKey]) {
        [postString appendFormat:@"&api_user_key=%@", [[self class] apiUserKey]];
    }
    if ([[self class] apiAction]) {
        [postString appendFormat:@"&api_option=%@", [[self class] apiAction]];
    }
    [_parameters enumerateKeysAndObjectsUsingBlock:^(NSString *key, NSString *value, BOOL *stop) {
        [postString appendFormat:@"&%@=%@", key, value];
    }];
    
#ifdef DEBUG
    NSLog(@"%@: REQUEST:\n%@", self.URL.absoluteString, postString);
#endif
    
    NSData *postData = [[postString stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding] dataUsingEncoding:NSUTF8StringEncoding];
    [self setHTTPMethod:@"POST"];
    [self setHTTPBody:postData];
}

#pragma mark - parse
//override this method in the child clssses
- (void)parseResult:(id)result {
}

- (id)resultFromData:(NSData *)data error:(NSError **)error {
    NSString *result = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
#ifdef DEBUG
    NSLog(@"%@: RESPONSE:\n%@", self.URL.absoluteString, result);
#endif
    *error = [self findError:result];
    if (*error != nil) {
        return nil;
    }
    return result;
}

- (NSError *)findError:(NSString *)result {
    NSError *error;
    if ([result hasPrefix:kBadResponseErrorPrefix]) {
        NSString *description = [[result stringByReplacingOccurrencesOfString:kBadResponseErrorPrefix withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        error = [NSError errorWithDomain:kRequestErrorDomain code:100500 userInfo:@{kRequestErrorDescriptionKey:(description)?description:@"no description"}];
    }
    if ([result hasPrefix:kPostLimitErrorPrefix]) {
        NSString *description = [[result stringByReplacingOccurrencesOfString:kPostLimitErrorPrefix withString:@""] stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
        error = [NSError errorWithDomain:kRequestErrorDomain code:100500 userInfo:@{kRequestErrorDescriptionKey:(description)?description:@"no description"}];
    }
    return error;
}

@end
