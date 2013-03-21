//
//  RemoteService.h
//  RemoteResource
//
//  Created by Mateusz Stankiewicz on 3/20/13.
//  Copyright (c) 2013 Mateusz Stankiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RemoteService : NSObject

typedef enum {
    GET,
    POST,
    DELETE,
    PUT
} Method;

+ (RemoteService*)instance;

typedef void (^ExecuteResponseHandler)(NSObject * resource, NSError * error);
- (void) executeAsynchronousRequestWithMethod:(Method)method andParameters:(NSDictionary*)params completionHandler:(ExecuteResponseHandler)handler;
- (NSObject*) executeSynchronousRequestWithMethod:(Method)method andParameters:(NSDictionary*)params andError:(NSError**)error;

@end
