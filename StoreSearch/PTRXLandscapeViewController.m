//
//  PTRXLandscapeViewController.m
//  StoreSearch
//
//  Created by Wang Long on 11/14/14.
//  Copyright (c) 2014 Wang Long. All rights reserved.
//

#import "PTRXLandscapeViewController.h"
#import "PTRXSearchResult.h"
#import "PTRXSearch.h"
#import "PTRXDetailViewController.h"

#import <AFNetworking/UIButton+AFNetworking.h>

@interface PTRXLandscapeViewController () <UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@end

@implementation PTRXLandscapeViewController
{
    BOOL _firstTime;
}

- (void)hideSpinner
{
    [[self.view viewWithTag:1000] removeFromSuperview];
}

- (void)searchResultsReceived
{
    [self hideSpinner];
    
    if([self.search.searchResults count] == 0)
    {
        [self showNothingFoundLabel];
    } else {
        [self tileButtons];
    }
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
    
    //[self testButtonImage];
}

- (void)showNothingFoundLabel
{
    UILabel *label = [[UILabel alloc] initWithFrame:CGRectZero];
    label.text = @"Nothing Found";
    label.backgroundColor = [UIColor clearColor];
    label.textColor = [UIColor whiteColor];
    
    [label sizeToFit];
    CGRect rect = label.frame;
    rect.size.width = ceilf(rect.size.width / 2.0f) * 2.0f;
    rect.size.height = ceilf(rect.size.height / 2.0f) * 2.0f;
    label.frame = rect;
    label.center = CGPointMake(CGRectGetMidX(self.scrollView.bounds), CGRectGetMidY(self.scrollView.bounds));
    
    [self.view addSubview:label];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    if(_firstTime)
    {
        _firstTime = NO;
        
        if(self.search != nil)
        {
            if(self.search.isLoading)
            {
                [self showSpinner];
            } else if([self.search.searchResults count] == 0) {
                [self showNothingFoundLabel];
            } else {
                [self tileButtons];
            }
        }
        //[self tileButtons];
    }
}

- (void)showSpinner
{
    UIActivityIndicatorView *spinner = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleWhiteLarge];
    
    spinner.center = CGPointMake(CGRectGetMidX(self.scrollView.bounds) + 0.5f, CGRectGetMidY(self.scrollView.bounds) + 0.5f);
    
    spinner.tag = 1000;
    [self.view addSubview:spinner];
    [spinner startAnimating];
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

- (void)downloadImageForSearchResult:(PTRXSearchResult *)searchResult andPlaceOnButton:(UIButton *)button
{
    NSURL *url = [NSURL URLWithString:searchResult.artworkURL60];
    
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __weak UIButton *weakButton = button;
    
    [button setImageForState:UIControlStateNormal
              withURLRequest:request
            placeholderImage:nil
                     success:^(NSURLRequest *request, NSURLResponse *response, UIImage *image) {
                         
                         UIImage *unscaledImage = [UIImage imageWithCGImage:image.CGImage scale:1.0 orientation:image.imageOrientation];
                         [weakButton setImage:unscaledImage forState:UIControlStateNormal];
                     } failure:nil];
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
    
    for(PTRXSearchResult *searchResult in self.search.searchResults)
    {
        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
        
        button.tag = 2000 + index;
        [button addTarget:self action:@selector(buttonPressed:) forControlEvents:UIControlEventTouchUpInside];
        
        [button setBackgroundImage:[UIImage imageNamed:@"LandscapeButton"] forState:UIControlStateNormal];
        
        [self downloadImageForSearchResult:searchResult andPlaceOnButton:button];
        
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
    int numPages = ceilf([self.search.searchResults count] / (float)tilesPerPage);
    self.scrollView.contentSize = CGSizeMake(numPages * scrollViewWidth, self.scrollView.bounds.size.height);
    
    NSLog(@"Number of pages: %d", numPages);
    
    self.pageControl.numberOfPages = numPages;
    self.pageControl.currentPage = 0;
}

- (void)buttonPressed:(UIButton *)sender
{
    PTRXDetailViewController *controller = [[PTRXDetailViewController alloc] initWithNibName:@"PTRXDetailViewController" bundle:nil];
    
    PTRXSearchResult *searchResult = self.search.searchResults[sender.tag - 2000];
    controller.searchResult = searchResult;
    
    [controller presentInParentViewController:self];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)dealloc
{
    NSLog(@"dealloc %@", self);
    
    for(id object in self.scrollView.subviews)
    {
        if([object isKindOfClass:[UIButton class]])
        {
            [(UIButton *)object cancelImageRequestOperationForState:UIControlStateNormal];
        }
    }
}

@end
