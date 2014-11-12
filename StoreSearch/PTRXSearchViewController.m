//
//  PTRXSearchViewController.m
//  StoreSearch
//
//  Created by Wang Long on 11/9/14.
//  Copyright (c) 2014 Wang Long. All rights reserved.
//

#import "PTRXSearchViewController.h"
#import "PTRXSearchResult.h"
#import "PTRXSearchResultCell.h"

static NSString * const SearchResultCellIdentifier = @"SearchResultCell";
static NSString * const NothongFoundCellIdentifier = @"NothingFoundCell";
static NSString * const LoadingCellIdentifier = @"LoadingCell";

@interface PTRXSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PTRXSearchViewController
{
    NSMutableArray *_searchResults;
    BOOL _isLoading;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.tableView.contentInset = UIEdgeInsetsMake(64, 0, 0, 0);
    self.tableView.rowHeight = 80;
    
    UINib *cellNib = [UINib nibWithNibName:@"PTRXSearchResultCell" bundle:nil];
    UINib *notFoundNib = [UINib nibWithNibName:@"PTRXNothingFoundCell" bundle:nil];
    UINib *loadingNib = [UINib nibWithNibName:@"PTRXLoadingCell" bundle:nil];
    
    [self.tableView registerNib:cellNib forCellReuseIdentifier:SearchResultCellIdentifier];
    [self.tableView registerNib:notFoundNib forCellReuseIdentifier:NothongFoundCellIdentifier];
    [self.tableView registerNib:loadingNib forCellReuseIdentifier:LoadingCellIdentifier];
    
    [self.searchBar becomeFirstResponder];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_isLoading) {
        return 1;
    } else if(_searchResults == nil)
    {
        return 0;
    } else if([_searchResults count] == 0) {
        return 1;
    } else {
        return [_searchResults count];
    }
}

/*
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    UITableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:@"SearchResultCell"];
    
    if([_searchResults count] == 0)
    {
        cell.textLabel.text = @"(Nothing found)";
        cell.detailTextLabel.text = @"";
    } else {
    
        PTRXSearchResult *searchResult = _searchResults[indexPath.row];
        cell.textLabel.text = searchResult.name;
        cell.detailTextLabel.text = searchResult.artistName;
    }
    return cell;
}
*/

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    PTRXSearchResultCell *cell = (PTRXSearchResultCell *)[self.tableView dequeueReusableCellWithIdentifier:SearchResultCellIdentifier];
    
    if(_isLoading)
    {
        UITableViewCell *loadingCell = [self.tableView dequeueReusableCellWithIdentifier:LoadingCellIdentifier forIndexPath:indexPath];
        
        UIActivityIndicatorView *spinner = (UIActivityIndicatorView *)[loadingCell viewWithTag:100];
        [spinner startAnimating];
        
        return loadingCell;
    } else if([_searchResults count] == 0) {
        return [self.tableView dequeueReusableCellWithIdentifier:NothongFoundCellIdentifier forIndexPath:indexPath];
    } else {
        PTRXSearchResult *searchResult = _searchResults[indexPath.row];
        cell.nameLabel.text = searchResult.name;
        cell.artistNameLabel.text = searchResult.artistName;
        
        NSString *artistName = searchResult.artistName;
        if(artistName == nil)
        {
            artistName = @"Unknown";
        }
        
        NSString *kind = [self kindForDisplay:searchResult.kind];
        cell.artistNameLabel.text = [NSString stringWithFormat:@"%@ (%@)", artistName, kind];
        
        return cell;
    }
    
    //return cell;
}

- (NSString *)kindForDisplay:(NSString *)kind
{
    if([kind isEqualToString:@"album"])
    {
        return @"Album";
    } else if([kind isEqualToString:@"audiobook"]) {
        return @"Audio Book";
    } else if([kind isEqualToString:@"book"]) {
        return @"Book";
    } else if([kind isEqualToString:@"ebook"]) {
        return @"E-Book";
    } else if([kind isEqualToString:@"feature-movie"]) {
        return @"Movie";
    } else if([kind isEqualToString:@"music-video"]) {
        return @"Music Video";
    } else if([kind isEqualToString:@"podcast"]) {
        return @"Podcast";
    } else if([kind isEqualToString:@"software"]) {
        return @"App";
    } else if([kind isEqualToString:@"song"]) {
        return @"Song";
    } else if([kind isEqualToString:@"tv-episode"]) {
        return @"TV Episode";
    } else {
        return kind;
    }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_searchResults count] == 0 || _isLoading)
    {
        return nil;
    } else {
        return indexPath;
    }
}


/*
- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([self.searchBar.text length] > 0)
    {
        [self.searchBar resignFirstResponder];
        
        _isLoading = YES;
        [self.tableView reloadData];
        
        _searchResults = [NSMutableArray arrayWithCapacity:10];
        
        NSURL *url = [self urlWithSearchText:self.searchBar.text];
        
        NSString *jsonString = [self performStoreRequestWithURL:url];
        
        if(jsonString == nil)
        {
            [self showNetworkError];
            return;
        }
        
        NSDictionary *dictionary = [self parseJSON:jsonString];
        if(dictionary == nil)
        {
            [self showNetworkError];
            return;
        }
        
        NSLog(@"Dictionary '%@'", dictionary);
        
        [self parseDictionary:dictionary];
        [_searchResults sortUsingSelector:@selector(compareName:)];
        
        _isLoading = NO;
        [self.tableView reloadData];
    }
} */

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if([searchBar.text length] > 0)
    {
        [searchBar resignFirstResponder];
        
        _isLoading = YES;
        [self.tableView reloadData];
        
        _searchResults = [NSMutableArray arrayWithCapacity:10];
        
        dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
        dispatch_async(queue, ^{
            NSURL *url = [self urlWithSearchText:searchBar.text];
            NSString *jsonString = [self performStoreRequestWithURL:url];
            
            if(jsonString == nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showNetworkError];
                });
                return;
            }
            
            NSDictionary *dictionary = [self parseJSON:jsonString];
            if(dictionary == nil)
            {
                dispatch_async(dispatch_get_main_queue(), ^{
                    [self showNetworkError];
                });
                return;
            }
            
            [self parseDictionary:dictionary];
            [_searchResults sortUsingSelector:@selector(compareName:)];
            
            dispatch_async(dispatch_get_main_queue(), ^{
                _isLoading = NO;
                [self.tableView reloadData];
            });
            
            NSLog(@"DONE!");
        });
    }
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
        NSLog(@"wrapperType: %@, kind: %@", resultDict[@"wrapperType"], resultDict[@"kind"]);
        
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
            [_searchResults addObject:searchResult];
        }
    }
}

- (PTRXSearchResult *)parseTrack:(NSDictionary *)dictionary
{
    PTRXSearchResult *searchResult = [[PTRXSearchResult alloc] init];
    searchResult.name = dictionary[@"trackName"];
    searchResult.artistName = dictionary[@"artistName"];
    searchResult.artworkURL60 = dictionary[@"artworkURL60"];
    searchResult.artworkURL100 = dictionary[@"artworkURL100"];
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

- (NSString *)performStoreRequestWithURL:(NSURL *)url
{
    NSError *error;
    NSString *resultString = [NSString stringWithContentsOfURL:url encoding:NSUTF8StringEncoding error:&error];
    if(resultString == nil)
    {
        NSLog(@"Download Error: %@", error);
        return nil;
    }
    return resultString;
}

- (NSDictionary *)parseJSON:(NSString *)jsonString
{
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSError *error;
    id resultObject = [NSJSONSerialization JSONObjectWithData:data options:kNilOptions error:&error];
    if(resultObject == nil)
    {
        NSLog(@"JSON Error: %@", error);
        return nil;
    }
    
    if(![resultObject isKindOfClass:[NSDictionary class]])
    {
        NSLog(@"JSON Error: Expected dictionary");
        return nil;
    }
    
    return resultObject;
}

- (void)showNetworkError
{
    UIAlertView *alertView = [[UIAlertView alloc]
                              initWithTitle:@"Whoops..."
                              message:@"There was an error reading from the iTunes Store. Please try again."
                              delegate:nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
    [alertView show];
}

- (NSURL *)urlWithSearchText:(NSString *)searchText
{
    NSString *escapeSearchText = [searchText stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    NSString *urlString = [NSString stringWithFormat:@"http://itunes.apple.com/search?term=%@", escapeSearchText];
    NSLog(@"urlString: '%@", urlString);
    NSURL *url = [NSURL URLWithString:urlString];
    return url;
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

@end
