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

- (NSURLRequest*)createRequestWithMethod:(HTTPMethod)method andPath:(NSString*)path andParameters:(NSDictionary*)params andError:(NSError**)error;

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

- (NSURLRequest*)createRequestWithMethod:(HTTPMethod)method andPath:(NSString*)path andParameters:(NSDictionary*)params andError:(NSError **)error {
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
        NSData * data = [_converter dataFromObject:params withError:error];
        if(data == nil) {
            return nil;
        }
        [request setHTTPBody:data];
    }
    
    if(_authenticator != nil && [_authenticator isAuthenticated]) {
        [_authenticator addAuthenticationToRequest:request];
    }
    
    return request;
}

- (void) executeAsynchronousRequestWithMethod:(HTTPMethod)method andPath:(NSString*)path andParameters:(NSDictionary*)params completionHandler:(ExecuteResponseHandler)handler {
    NSParameterAssert(handler);
    
    NSError * error;
    NSURLRequest * request = [self createRequestWithMethod:method andPath:path andParameters:params andError:&error];
    
    if(request == nil) {
        handler(nil, error);
        return;
    }
    
    [NSURLConnection sendAsynchronousRequest:request queue:_queue completionHandler:^(NSURLResponse * response, NSData * data, NSError * error) {
        if(data == nil) {
            handler(nil, error);
        }
        else {
            NSError * error;
            NSObject * object = [_converter objectFromData:data withError:&error];
            if(object == nil) {
                handler(nil, error);
            }
            else {
                handler(object, nil);
            }
        }
    }];
}

- (NSObject*) executeSynchronousRequestWithMethod:(HTTPMethod)method andPath:(NSString*)path andParameters:(NSDictionary*)params andError:(NSError**)error {
    NSURLRequest * request = [self createRequestWithMethod:method andPath:path andParameters:params andError:error];
    if(request == nil) {
        return nil;
    }
    
    NSData * data = [NSURLConnection sendSynchronousRequest:request returningResponse:nil error:error];
    if(data == nil) {
        return nil;
    }
    else {
        return [_converter objectFromData:data withError:error];
    }
}

@end
