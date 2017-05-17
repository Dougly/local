//
//  MTFilterViewController.m
//  Local
//
//  Created by Rostyslav Stepanyak on 5/10/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTFilterViewController.h"
#import "MTFilterViewCell.h"
#import "MTSettings.h"
#import "MTSubfilterViewController.h"
#import "MTFilterPriceCell.h"

@interface MTFilterViewController()
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic) NSUInteger subfilterIndex;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic) BOOL isClosed;
@end

NSString *const FILTER_VIEW_CELL = @"MTFilterViewCell";
NSString *const FILTER_PRICE_CELL = @"MTFilterPriceCell";

@implementation MTFilterViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    
    [self addBorder];
    [self registerCells];
    
    // Remove first cell top separator
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    // Remove last cell bottom separator
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.tableView.frame.size.width, 1)];
}

- (void)prepareForShow {
    [self calculateSelectedIndexPath];
    [self.tableView reloadData];
    self.isClosed = false;
}

- (void)disableSwipe {
    /*if ([self.navigationController respondsToSelector:@selector(interactivePopGestureRecognizer)]) {
        self.navigationController.interactivePopGestureRecognizer.enabled = NO;
        self.navigationController.interactivePopGestureRecognizer.delegate = nil;
    }*/
}

- (void)addBorder {
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = UIColorFromHex(0x939598).CGColor;
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.view.frame), 1.0f);
    [self.view.layer addSublayer:upperBorder];
}

- (void)calculateSelectedIndexPath {
    NSUInteger index = -1;
    if ([FILTERS_KEY_WORDS containsObject:[MTSettings sharedSettings].filterKeyWords]) {
        index = [FILTERS_KEY_WORDS indexOfObject:[MTSettings sharedSettings].filterKeyWords];
    }
    else {
        self.subfilterIndex = -1;
        for (NSUInteger filterIndex = MTFilterViewCellHelthy; filterIndex < MTFilterViewCellPrice; filterIndex++) {
            NSArray *subfilters = FILTERS_KEY_WORDS[filterIndex];
            
            if ([subfilters containsObject:[MTSettings sharedSettings].filterKeyWords]) {
                index = filterIndex;
                self.subfilterIndex = [subfilters indexOfObject:[MTSettings sharedSettings].filterKeyWords];
                break;
            }
        }
    }
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
}

- (void)registerCells {
    [self.tableView registerNib:[UINib nibWithNibName:@"MTFilterViewCell"
                                               bundle:nil]
                               forCellReuseIdentifier:FILTER_VIEW_CELL];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"MTFilterPriceCell"
                                               bundle:nil]
         forCellReuseIdentifier:FILTER_PRICE_CELL];
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return MTFilterViewCellCount;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *finalCell = nil;
    
    // all the filter cells
    if (indexPath.row < MTFilterViewCellPrice) {
        MTFilterViewCell *cell =
        [tableView dequeueReusableCellWithIdentifier:FILTER_VIEW_CELL
                                        forIndexPath:indexPath];
        if (indexPath.row == self.selectedIndexPath.row) {
            cell.markImageView.hidden = false;
        }
        else {
            cell.markImageView.hidden = true;
        }
        
        NSString *subfilterString = @"";
        
        if (self.selectedIndexPath.row < FILTER_TITLES.count && indexPath.row == self.selectedIndexPath.row) {
            if (self.selectedIndexPath.row >= MTFilterViewCellHelthy) {
                NSArray *subfilters = FILTER_TITLES[self.selectedIndexPath.row];
                
                subfilterString = [subfilters objectAtIndex:self.subfilterIndex];
                subfilterString = [NSString stringWithFormat:@" [%@]", subfilterString];
            }
        }
        
        
        if(indexPath.row == MTFilterViewCellCoffee) {
            [cell.leftImageButton.titleLabel setFont: [UIFont fontWithName:@"FontAwesome" size:14]];
            [cell.leftImageButton setTitle:@"" forState:UIControlStateNormal];
            cell.captionLabel.text = @"Caffeine";
            finalCell = cell;
        }
        
        if(indexPath.row == MTFilterViewCellHardStuff) {
            [cell.leftImageButton.titleLabel setFont: [UIFont fontWithName:@"FontAwesome" size:14]];
            [cell.leftImageButton setTitle:@"\U0000f000" forState:UIControlStateNormal];
            cell.captionLabel.text = @"The Hard Stuff";
            finalCell = cell;
        }
        
        if(indexPath.row == MTFilterViewCellHelthy) {
            [cell.leftImageButton setTitle:@"\U0000e09e" forState:UIControlStateNormal];
            cell.captionLabel.text = [@"Helthy-ish" stringByAppendingString:subfilterString];
            finalCell = cell;
        }
        
        if(indexPath.row == MTFilterViewCellComfort) {
            [cell.leftImageButton setTitle:@"\U0000e04d" forState:UIControlStateNormal];
            cell.captionLabel.text = [@"Comfort Food" stringByAppendingString:subfilterString];
            finalCell = cell;
        }
        
        if(indexPath.row == MTFilterViewCellSweet) {
            [cell.leftImageButton setTitle:@"\U0000e073" forState:UIControlStateNormal];
            cell.captionLabel.text = [@"Sweet Treats" stringByAppendingString:subfilterString];
            finalCell = cell;
        }
    }
    // filter price cell
    else {
        MTFilterPriceCell *cell =
        [tableView dequeueReusableCellWithIdentifier:FILTER_PRICE_CELL
                                        forIndexPath:indexPath];
        finalCell = cell;
    }
    
    
    return finalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    if (indexPath.row <= MTFilterViewCellHardStuff) {
        [MTSettings sharedSettings].filterKeyWords = FILTERS_KEY_WORDS[indexPath.row];
        MTFilterViewCell *currentlySelectedCell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
        currentlySelectedCell.markImageView.hidden = true;
        
        MTFilterViewCell *newlySelectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
        newlySelectedCell.markImageView.hidden = false;
        
        self.selectedIndexPath = indexPath;
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [[NSNotificationCenter defaultCenter] postNotificationName:nHIDE_FILTER_VIEW_NOTIFICATION
                                                                object:nil
                                                              userInfo:false];
        });
    }
    else {
        UIStoryboard *main = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
        MTSubfilterViewController *subfilterViewController = [main instantiateViewControllerWithIdentifier:@"MTSubfilterViewController"];
        subfilterViewController.filterGroupIndex = (MTFilterViewCellIndex)indexPath.row;
        [self.navigationController pushViewController:subfilterViewController animated:YES];
    }
    
    [self.tableView deselectRowAtIndexPath:[self.tableView indexPathForSelectedRow] animated:YES];
}


- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pullDistance = scrollView.contentOffset.y;
    
    if (pullDistance < -70) {
        if (!self.isClosed) {
            NSDictionary *userInfo = @{kRevertFilterViewToPreviousIndex : @(YES)};
            [[NSNotificationCenter defaultCenter] postNotificationName:nHIDE_FILTER_VIEW_NOTIFICATION
                                                                object:nil
                                                              userInfo:userInfo];
            self.isClosed = true;
        }
    }
}

@end
