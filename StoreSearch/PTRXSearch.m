//
//  PTRXSearch.m
//  StoreSearch
//
//  Created by Wang Long on 11/16/14.
//  Copyright (c) 2014 Wang Long. All rights reserved.
//

#import "PTRXSearch.h"
#import "PTRXSearchResult.h"

#import <AFNetworking/AFNetworking.h>

static NSOperationQueue *queue = nil;

@interface PTRXSearch ()

@property (strong, readwrite, nonatomic) NSMutableArray *searchResults;

@end

@implementation PTRXSearch

+ (void)initialize
{
    if(self == [PTRXSearch class])
    {
        queue = [[NSOperationQueue alloc] init];
    }
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

- (void)performSearchForText:(NSString *)text category:(NSInteger)category completion:(SearchBlock)block
{
    if([text length] > 0)
    {
        [queue cancelAllOperations];
        
        self.isLoading = YES;
        self.searchResults = [NSMutableArray arrayWithCapacity:10];
        
        NSURL *url = [self urlWithSearchText:text category:category];
        
        NSURLRequest *request = [NSURLRequest requestWithURL:url];
        
        AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
        operation.responseSerializer = [AFJSONResponseSerializer serializer];
        
        [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
            [self parseDictionary:responseObject];
            [self.searchResults sortUsingSelector:@selector(compareName:)];
            self.isLoading = NO;
            block(YES);
            //NSLog(@"Success!");
        } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
            if(!operation.isCancelled)
            {
                self.isLoading = NO;
                //NSLog(@"Failure!");
                block(NO);
            }
        }];
        
        [queue addOperation:operation];
    }
}

- (NSURL *)urlWithSearchText:(NSString *)searchText category:(NSInteger)category
{
    NSString *categoryName;
    switch(category)
    {
        case 0: categoryName = @""; break;
        case 1: categoryName = @"musicTrack"; break;
        case 2: categoryName = @"software"; break;
        case 3: categoryName = @"ebook"; break;
    }
    
    NSLocale *locale = [NSLocale autoupdatingCurrentLocale];
    NSString *language = [locale localeIdentifier];
    NSString *countryCode = [locale objectForKey:NSLocaleCountryCode];
    
    NSString *escapeSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    
    //NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&limit=200&entity=%@", escapeSearchText, categoryName];
    
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@&limit=200&entity=%@&lang=%@&country=%@", escapeSearchText, categoryName, language, countryCode];
    
    NSLog(@"urlString: '%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

- (void)parseDictionary:(NSDictionary *)dictionary
{
    NSArray *array = dictionary[@"results"];
    if(array == nil)
    {
        NSLog(@"Expected 'results' array");
        return;
    }
    
    for(NSDictionary *resultDict in array)
    {
        //NSLog(@"wrapperType: %@, kind: %@", resultDict[@"wrapperType"], resultDict[@"kind"]);
        
        PTRXSearchResult *searchResult;
        
        NSString *wrapperType = resultDict[@"wrapperType"];
        NSString *kind = resultDict[@"kind"];
        
        if([wrapperType isEqualToString:@"track"])
        {
            searchResult = [self parseTrack:resultDict];
        } else if([wrapperType isEqualToString:@"audiobook"]) {
            searchResult = [self parseAudioBook:resultDict];
        } else if([wrapperType isEqualToString:@"software"]) {
            searchResult = [self parseSoftware:resultDict];
        } else if([kind isEqualToString:@"ebook"]) {
            searchResult = [self parseEBook:resultDict];
        }
        
        if(searchResult != nil)
        {
            [self.searchResults addObject:searchResult];
        }
    }
}


- (PTRXSearchResult *)parseTrack:(NSDictionary *)dictionary
{
    PTRXSearchResult *searchResult = [[PTRXSearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"trackPrice"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    return searchResult;
}

- (PTRXSearchResult *)parseAudioBook:(NSDictionary *)dictionary
{
    PTRXSearchResult *searchResult = [[PTRXSearchResult alloc] init];
    searchResult.name = dictionary[@"collectionName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"collectionViewUrl"];
    searchResult.kind = @"audiobook";
    searchResult.price = dictionary[@"collectionPrice"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    return searchResult;
}

- (PTRXSearchResult *)parseSoftware:(NSDictionary *)dictionary
{
    PTRXSearchResult *searchResult = [[PTRXSearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"price"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = dictionary[@"primaryGenreName"];
    return searchResult;
}

- (PTRXSearchResult *)parseEBook:(NSDictionary *)dictionary
{
    PTRXSearchResult *searchResult = [[PTRXSearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkUrl60"];
    searchResult.artworkURL100 = dictionary[@"artworkUrl100"];
    searchResult.storeURL = dictionary[@"trackViewUrl"];
    searchResult.kind = dictionary[@"kind"];
    searchResult.price = dictionary[@"price"];
    searchResult.currency = dictionary[@"currency"];
    searchResult.genre = [(NSArray *)dictionary[@"genres"] componentsJoinedByString:@", "];
    return searchResult;
}

@end
