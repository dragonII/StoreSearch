//
//  PTRXSearch.h
//  StoreSearch
//
//  Created by Wang Long on 11/16/14.
//  Copyright (c) 2014 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void (^SearchBlock)(BOOL success);

@interface PTRXSearch : NSObject

@property (assign, nonatomic) BOOL isLoading;
@property (strong, readonly, nonatomic) NSMutableArray *searchResults;

- (void)performSearchForText:(NSString *)text category:(NSInteger)category completion:(SearchBlock)block;

@end
