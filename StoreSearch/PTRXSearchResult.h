//
//  PTRXSearchResult.h
//  StoreSearch
//
//  Created by Wang Long on 11/9/14.
//  Copyright (c) 2014 Wang Long. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface PTRXSearchResult : NSObject

@property (copy, nonatomic) NSString *name;
@property (copy, nonatomic) NSString *artistName;
@property (copy, nonatomic) NSString *artworkURL60;
@property (copy, nonatomic) NSString *artworkURL100;
@property (copy, nonatomic) NSString *storeURL;
@property (copy, nonatomic) NSString *kind;
@property (copy, nonatomic) NSString *currency;
@property (copy, nonatomic) NSDecimalNumber *price;
@property (copy, nonatomic) NSString *genre;

- (NSComparisonResult)compareName:(PTRXSearchResult *)other;

@end
