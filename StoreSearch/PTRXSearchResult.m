//
//  PTRXSearchResult.m
//  StoreSearch
//
//  Created by Wang Long on 11/9/14.
//  Copyright (c) 2014 Wang Long. All rights reserved.
//

#import "PTRXSearchResult.h"

@implementation PTRXSearchResult

- (NSComparisonResult)compareName:(PTRXSearchResult *)other
{
    return [self.name localizedStandardCompare:other.name];
}

@end
