//
//  SKFetchRequest.h
//  StackKit
/**
  Copyright (c) 2011 Dave DeLong
 
 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in
 all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
 THE SOFTWARE.
 **/

#import <Foundation/Foundation.h>
#import "SKObject.h"
#import "SKFetchRequestDelegate.h"

@class SKCallback;

@interface SKFetchRequest : SKObject {
	Class entity;
	NSSortDescriptor * sortDescriptor;
	NSUInteger fetchLimit;
	NSUInteger fetchOffset;
	NSNumber * fetchTotal;
	NSPredicate * predicate;
	
	NSError * error;
	id<SKFetchRequestDelegate> delegate;
	NSURL * fetchURL;
	
	SKCallback *callback;
}

@property (assign) Class entity;
@property (retain) NSSortDescriptor * sortDescriptor;
@property NSUInteger fetchLimit;
@property NSUInteger fetchOffset;
@property (readonly) NSNumber * fetchTotal;
@property (retain) NSPredicate * predicate;
@property (readonly, retain) NSError * error;
@property (assign) id<SKFetchRequestDelegate> delegate;
@property (retain) SKCallback *callback;

@end
