//
//  RemoteService.m
//  RemoteResource
//
//  Created by Mateusz Stankiewicz on 3/20/13.
//  Copyright (c) 2013 Mateusz Stankiewicz. All rights reserved.
//

#import "RRRemoteService.h"

static RRRemoteService * instance;

@interface RRRemoteService ()

@property (strong, nonatomic) NSOperationQueue * queue;

- (NSURLRequest*)createRequestWithMethod:(Method)method andPath:(NSString*)path andParameters:(NSDictionary*)params;

@end

@implementation RRRemoteService

+ (void) initialize {
    instance = [[RRRemoteService alloc] init];
}

+(RRRemoteService*) instance {
    return instance;
}

- (id) init {
    if(self = [super init]) {
        _timeoutInterval = 60.0;
        _endpointURL = nil;
        _queue = [[NSOperationQueue alloc] init];
    }
    return self;
}

- (void)setEndpointURLWithString:(NSString*)string {
    NSParameterAssert(string);
    
    _endpointURL = [NSURL URLWithString:string];
}

- (NSURLRequest*)createRequestWithMethod:(Method)method andPath:(NSString*)path andParameters:(NSDictionary*)params {
    NSParameterAssert(_endpointURL);
    NSParameterAssert(_converter);
    
    NSURL * url = (path != nil) ? [_endpointURL URLByAppendingPathComponent:path] : _endpointURL;
    NSMutableURLRequest * request = [NSMutableURLRequest requestWithURL:url cachePolicy:NSURLRequestReloadIgnoringLocalCacheData timeoutInterval:_timeoutInterval];
    
    switch (method) {
        case GET:
            [request setHTTPMethod:@"GET"];
            break;
        case POST:
            [request setHTTPMethod:@"POST"];
            break;
        case PUT:
            [request setHTTPMethod:@"PUT"];
            break;
        case DELETE:
            [request setHTTPMethod:@"DELETE"];
            break;
        default:
            [request setHTTPMethod:@"GET"];
            break;
    }
    
    if(params != nil) {
        [request addValue:[_converter contentType] forHTTPHeaderField:@"Content-Type"];
        [request setHTTPBody:[_converter dataFromObject:params]];
    }
    
    if(_authenticator != nil && [_authenticator isAuthenticated]) {
        [_authenticator addAuthenticationToRequest:request];
    }
    
    return request;
}

- (void) executeAsynchronousRequestWithMethod:(Method)method andPath:(NSString*)path andParameters:(NSDictionary*)params completionHandler:(ExecuteResponseHandler)handler {
    NSParameterAssert(handler);
    
    NSURLRequest * request = [self createRequestWithMethod:method andPath:path andParameters:params];
    
    [NSURLConnection sendAsynchronousRequest:request queue:_queue completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        if(data == nil) {
            handler(nil, error);
        }
        else {
            handler([_converter objectFromData:data], nil);
        }
    }];
}

- (NSObject*) executeSynchronousRequestWithMethod:(Method)method andPath:(NSString*)path andParameters:(NSDictionary*)params andError:(NSError**)error {
    NSURLRequest * request = [self createRequestWithMethod:method andPath:path andParameters:params];
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:error];
    if(data == nil) {
        return nil;
    }
    else {
        return [_converter objectFromData:data];
    }
}

@end
