//
//  SKFetchRequest.m
//  StackKit
//
//  Created by Dave DeLong on 12/31/11.
//  Copyright (c) 2011 __MyCompanyName__. All rights reserved.
//

#import <StackKit/SKFetchRequest_Internal.h>
#import <StackKit/SKConstants.h>
#import <StackKit/SKFunctions.h>
#import <StackKit/SKSite_Internal.h>

#import <StackKit/SKObject_Internal.h>
#import <StackKit/SKUser.h>
#import <StackKit/SKTag.h>
#import <StackKit/SKBadge.h>
#import <objc/runtime.h>

static void *NSFetchRequestStackKitFetchRequestKey;

@implementation NSFetchRequest (StackKit)

- (SKFetchRequest *)stackKitFetchRequest {
    return objc_getAssociatedObject(self, &NSFetchRequestStackKitFetchRequestKey);
}

- (void)setStackKitFetchRequest:(SKFetchRequest *)stackKitFetchRequest {
    objc_setAssociatedObject(self, &NSFetchRequestStackKitFetchRequestKey, stackKitFetchRequest, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

@end

@implementation SKFetchRequest

@synthesize sortKey=_sortKey;
@synthesize ascending=_ascending;

+ (SKUserFetchRequest *)requestForFetchingUsers {
    if (self != [SKFetchRequest class]) {
        [NSException raise:NSInternalInconsistencyException 
                    format:@"+%@ may only be invoked on SKFetchRequest", NSStringFromSelector(_cmd)];
    }
    
    return [[[SKUserFetchRequest alloc] init] autorelease];
}

+ (SKTagFetchRequest *)requestForFetchingTags {
    if (self != [SKFetchRequest class]) {
        [NSException raise:NSInternalInconsistencyException 
                    format:@"+%@ may only be invoked on SKFetchRequest", NSStringFromSelector(_cmd)];
    }
    
    return [[[SKTagFetchRequest alloc] init] autorelease];
}

+ (SKBadgeFetchRequest *)requestForFetchingBadges {
    if (self != [SKFetchRequest class]) {
        [NSException raise:NSInternalInconsistencyException 
                    format:@"+%@ may only be invoked on SKFetchRequest", NSStringFromSelector(_cmd)];
    }
    
    return [[[SKBadgeFetchRequest alloc] init] autorelease];
}

+ (Class)_targetClass {
    [NSException raise:NSInternalInconsistencyException 
                format:@"+%@ must be overridden by subclasses", NSStringFromSelector(_cmd)];
    return nil;
}

- (Class)_targetClass {
    return [[self class] _targetClass];
}

- (NSFetchRequest *)_generatedFetchRequest {
    NSFetchRequest *r = [[NSFetchRequest alloc] initWithEntityName:[[self _targetClass] _entityName]];
    
    if ([_sortKey length] > 0) {
        NSString *property = SKInferPropertyNameFromAPIKey(_sortKey);
        NSSortDescriptor *sort = [NSSortDescriptor sortDescriptorWithKey:property ascending:_ascending];
        [r setSortDescriptors:[NSArray arrayWithObject:sort]];
    }
    
    [r setResultType:NSManagedObjectResultType];
    
    [r setStackKitFetchRequest:self];
    
    return [r autorelease];
}

- (NSString *)_path {
    [NSException raise:NSInternalInconsistencyException 
                format:@"-%@ must be overridden by subclasses", NSStringFromSelector(_cmd)];
    return nil;
}

- (NSMutableDictionary *)_queryDictionary {
    NSMutableDictionary *d = [NSMutableDictionary dictionary];
    
    [d setObject:(_ascending ? SKQueryKeys.sortOrder.ascending : SKQueryKeys.sortOrder.descending) forKey:SKQueryKeys.order];
    
    if ([_sortKey length] > 0) {
        [d setObject:_sortKey forKey:SKQueryKeys.sort];
    }
    
    return d;
}

- (NSURL *)_apiURLWithSite:(SKSite *)site {
    NSMutableDictionary *query = [self _queryDictionary];
    [query setObject:[site APISiteParameter] forKey:SKQueryKeys.site];
    
    NSString *path = [self _path];
    
    return SKConstructAPIURL(path, query);
}

- (id)inAscendingOrder {
    [self setAscending:YES];
    return self;
}

- (id)inDescendingOrder {
    [self setAscending:NO];
    return self;
}

- (void)dealloc {
    [_sortKey release];
    [super dealloc];
}

@end
