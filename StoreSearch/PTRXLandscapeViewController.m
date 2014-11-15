//
//  PTRXLandscapeViewController.m
//  StoreSearch
//
//  Created by Wang Long on 11/14/14.
//  Copyright (c) 2014 Wang Long. All rights reserved.
//

#import "PTRXLandscapeViewController.h"
#import "PTRXSearchResult.h"

@interface PTRXLandscapeViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation PTRXLandscapeViewController
{
    BOOL _firstTime;
}

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        _firstTime = YES;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.scrollView.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"LandscapeBackground"]];
    
    self.pageControl.numberOfPages = 0;
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if(_firstTime)
    {
        _firstTime = NO;
        
        [self tileButtons];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat width = self.scrollView.bounds.size.width;
    int currentPage = (self.scrollView.contentOffset.x + width / 2.0f) / width;
    self.pageControl.currentPage = currentPage;
}

- (IBAction)pageChanged:(UIPageControl *)sender
{
    [UIView animateWithDuration:0.3
                          delay:0
                        options:UIViewAnimationOptionCurveEaseInOut
                     animations:^{
                         self.scrollView.contentOffset = CGPointMake(self.scrollView.bounds.size.width * sender.currentPage, 0);
                     } completion:nil];
}

- (void)tileButtons
{
    int columnsPerPage = 5;
    CGFloat itemWidth = 96.0f;
    CGFloat x = 0.0f;
    CGFloat extraSpace = 0.0f;
    
    CGFloat scrollViewWidth = self.scrollView.bounds.size.width;
    if(scrollViewWidth > 480.0f)
    {
        columnsPerPage = 6;
        itemWidth = 94.0f;
        extraSpace = 4.0f;
        x = 2.0f;
    }
    
    const CGFloat itemHeight = 88.0f;
    const CGFloat buttonWidth = 82.0f;
    const CGFloat buttonHeight = 82.0f;
    const CGFloat marginHorz = (itemWidth - buttonWidth) / 2.0f;
    const CGFloat marginVerz = (itemHeight - buttonHeight) / 2.0f;
    
    int index = 0;
    int row = 0;
    int column = 0;
    
    for(PTRXSearchResult *searchResult in self.searchResults)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
        
        button.backgroundColor = [UIColor whiteColor];
        [button setTitle:[NSString stringWithFormat:@"%d", index] forState:UIControlStateNormal];
        button.frame = CGRectMake(x + marginHorz, 20.0 + row * itemHeight + marginVerz, buttonWidth, buttonHeight);
        
        [self.scrollView addSubview:button];
        
        index++;
        row++;
        if(row == 3)
        {
            row = 0;
            column++;
            x += itemWidth;
            
            if(column == columnsPerPage)
            {
                column = 0;
                x += extraSpace;
            }
        }
    }
    
    int tilesPerPage = columnsPerPage * 3;
    int numPages = ceilf([self.searchResults count] / (float)tilesPerPage);
    self.scrollView.contentSize = CGSizeMake(numPages * scrollViewWidth, self.scrollView.bounds.size.height);
    
    NSLog(@"Number of pages: %d", numPages);
    
    self.pageControl.numberOfPages = numPages;
    self.pageControl.currentPage = 0;
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
}

@end
