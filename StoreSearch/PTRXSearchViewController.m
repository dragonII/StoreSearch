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

@interface PTRXSearchViewController () <UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate>

@property (weak, nonatomic) IBOutlet UISearchBar *searchBar;
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@end

@implementation PTRXSearchViewController
{
    NSMutableArray *_searchResults;
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
    
    [self.tableView registerNib:cellNib forCellReuseIdentifier:SearchResultCellIdentifier];
    [self.tableView registerNib:notFoundNib forCellReuseIdentifier:NothongFoundCellIdentifier];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    if(_searchResults == nil)
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
    
    if([_searchResults count] == 0)
    {
        return [self.tableView dequeueReusableCellWithIdentifier:NothongFoundCellIdentifier];
        //cell.nameLabel.text = @"(Nothing found)";
        //cell.artistNameLabel.text = @"";
    } else {
        PTRXSearchResult *searchResult = _searchResults[indexPath.row];
        cell.nameLabel.text = searchResult.name;
        cell.artistNameLabel.text = searchResult.artistName;
        
        return cell;
    }
    
    //return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [self.tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (NSIndexPath *)tableView:(UITableView *)tableView willSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    if([_searchResults count] == 0)
    {
        return nil;
    } else {
        return indexPath;
    }
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    [self.searchBar resignFirstResponder];
    _searchResults = [NSMutableArray arrayWithCapacity:10];
    
    if(![self.searchBar.text isEqualToString:@"justin bieber"])
    {
    
        for(int i = 0; i < 3; i++)
        {
            PTRXSearchResult *searchResult = [[PTRXSearchResult alloc] init];
            searchResult.name = [NSString stringWithFormat:@"Fake Result %d for", i];
            searchResult.artistName = self.searchBar.text;
            [_searchResults addObject:searchResult];
        }
    }
    
    [self.tableView reloadData];
}

- (UIBarPosition)positionForBar:(id<UIBarPositioning>)bar
{
    return UIBarPositionTopAttached;
}

@end
