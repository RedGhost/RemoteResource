//
//  RemoteResource.m
//  RemoteResource
//
//  Created by Mateusz Stankiewicz on 3/20/13.
//  Copyright (c) 2013 Mateusz Stankiewicz. All rights reserved.
//

#import "RRRemoteResource.h"

@implementation RRRemoteResource

- (id)initWithIdentifier:(id)identifier andData:(NSDictionary*)data {
    if(self = [super init]) {
        _identifier = identifier;
        _data = data;
        _updatedData = [[NSMutableDictionary alloc] initWithCapacity:[_data count]];
    }
    return self;
}

+ (void) fetch:(id)identifier completionHandler:(FetchResponseHandler)handler {
    
}

+ (RRRemoteResource*) fetch:(id)identifier withError:(NSError**)error {
    
}

- (void) saveWithCompletionHandler:(SaveResponseHandler)handler {
    
}

- (BOOL) saveWithError:(NSError**)error {
    
}

@end
