//
//  RemoteResource.h
//  RemoteResource
//
//  Created by Mateusz Stankiewicz on 3/20/13.
//  Copyright (c) 2013 Mateusz Stankiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRRemoteResource : NSObject

@property (strong, nonatomic) id identifier;
@property (strong, nonatomic) NSDictionary * data;
@property (strong, nonatomic) NSMutableDictionary * updatedData;

- (id)initWithIdentifier:(id)identifier andData:(NSDictionary*)data;

+ (NSString*)pathForIdentifier:(id)identifier;

typedef void (^FetchResponseHandler)(id resource, NSError * error);
+ (void) fetch:(id)identifier completionHandler:(FetchResponseHandler)handler;
+ (id) fetch:(id)identifier withError:(NSError**)error;

typedef void (^SaveResponseHandler)(BOOL success, NSError * error);
- (void) saveWithCompletionHandler:(SaveResponseHandler)handler;
- (BOOL) saveWithError:(NSError**)error;

@end
