//
//  MTSubfilterViewController.m
//  Local
//
//  Created by Rostyslav Stepanyak on 5/10/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "MTSubfilterViewController.h"
#import "MTFilterViewCell.h"
#import "MTSettings.h"

@interface MTSubfilterViewController ()
@property (nonatomic, strong) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@property (nonatomic) BOOL isClosed;
@end

NSString *const SUB_FILTER_VIEW_CELL = @"MTFilterViewCell";

@implementation MTSubfilterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self calculateSelectedIndexPath];
    [self registerCells];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)calculateSelectedIndexPath {
    NSUInteger index = -1;
    
    for (NSUInteger subfiltersIndex = MTFilterViewCellHelthy; subfiltersIndex < MTFilterViewCellCount; subfiltersIndex++) {
        NSArray *subfilters = FILTERS_KEY_WORDS[subfiltersIndex];
        
        if ([subfilters containsObject:[MTSettings sharedSettings].filterKeyWords] && subfiltersIndex == self.filterGroupIndex) {
            index = [subfilters indexOfObject:[MTSettings sharedSettings].filterKeyWords];
            break;
        }
    }
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
}

- (void)registerCells {
    [self.tableView registerNib:[UINib nibWithNibName:@"MTFilterViewCell"
                                               bundle:nil]
         forCellReuseIdentifier:SUB_FILTER_VIEW_CELL];
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *titles = FILTER_TITLES[self.filterGroupIndex];
    return titles.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTFilterViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:SUB_FILTER_VIEW_CELL
                                    forIndexPath:indexPath];
    
    if (indexPath.row == self.selectedIndexPath.row) {
        cell.markImageView.hidden = false;
    }
    else {
        cell.markImageView.hidden = true;
    }
    
    NSArray *titles = FILTER_TITLES[self.filterGroupIndex];
    cell.leftImageLabel.text = @"";
    cell.captionLabel.text = titles[indexPath.row];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    NSArray *keywords = FILTERS_KEY_WORDS[self.filterGroupIndex];
    
    [MTSettings sharedSettings].filterKeyWords = keywords[indexPath.row];
     MTFilterViewCell *currentlySelectedCell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
     currentlySelectedCell.markImageView.hidden = true;
     
     MTFilterViewCell *newlySelectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
     newlySelectedCell.markImageView.hidden = false;
     
     self.selectedIndexPath = indexPath;
    
     [[NSNotificationCenter defaultCenter] postNotificationName:nHIDE_FILTER_VIEW_NOTIFICATION
                                                         object:nil
                                                       userInfo:nil];
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pullDistance = scrollView.contentOffset.y;
        
    if (pullDistance < -90) {
        if (!self.isClosed) {
            NSDictionary *userInfo = @{kRevertFilterViewToPreviousIndex : @(YES)};
            [[NSNotificationCenter defaultCenter] postNotificationName:nHIDE_FILTER_VIEW_NOTIFICATION
                                                                object:nil
                                                              userInfo:userInfo];
            self.isClosed = YES;
        }
    }
}


@end
