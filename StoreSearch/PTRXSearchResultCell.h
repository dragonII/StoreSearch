//
//  PTRXSearchResultCell.h
//  StoreSearch
//
//  Created by Wang Long on 11/10/14.
//  Copyright (c) 2014 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

@class PTRXSearchResult;

@interface PTRXSearchResultCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
@property (weak, nonatomic) IBOutlet UILabel *artistNameLabel;
@property (weak, nonatomic) IBOutlet UIImageView *artworkImageView;

- (void)configureForSearchResult:(PTRXSearchResult *)searchResult;

@end
