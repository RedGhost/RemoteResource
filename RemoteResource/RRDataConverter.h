//
//  RRDataCoder.h
//  RemoteResource
//
//  Created by Mateusz Stankiewicz on 3/20/13.
//  Copyright (c) 2013 Mateusz Stankiewicz. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface RRDataConverter : NSObject

- (NSString*) contentType;
- (NSObject*) objectFromData:(NSData*)data;
- (NSData*) dataFromObject:(NSObject*)object;

@end
