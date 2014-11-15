//
//  PTRXDetailViewController.h
//  StoreSearch
//
//  Created by Wang Long on 11/13/14.
//  Copyright (c) 2014 Wang Long. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, PTRXDetailViewControllerAnimationType)
{
    PTRXDetailViewControllerAnimationTypeSlide,
    PTRXDetailViewControllerAnimationTypeFade
};

@class  PTRXSearchResult;

@interface PTRXDetailViewController : UIViewController

@property (strong, nonatomic) PTRXSearchResult *searchResult;

- (void)presentInParentViewController:(UIViewController *)parentViewController;
- (void)dismissFromParentViewControllerWithAnimationType:(PTRXDetailViewControllerAnimationType)animationType;

@end
