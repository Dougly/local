//
//  TitleView.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/28/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "FilterView.h"
#import "MTFilterViewCell.h"
#import "MTSettings.h"

typedef NS_ENUM(NSInteger, MTFilterViewCellIndex) {
    MTLocationViewCellBrunch = 0,
    MTLocationViewCellWine,
    MTLocationViewCellCoffee
};

@interface FilterView()<UITabBarDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSIndexPath *selectedIndexPath;
@end

NSString *const FILTER_VIEW_CELL = @"MTFilterViewCell";

@implementation FilterView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self addBorder];
    [self registerCells];
    [self calculateSelectedIndexPath];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)addBorder {
    CALayer *upperBorder = [CALayer layer];
    upperBorder.backgroundColor = UIColorFromHex(0x939598).CGColor;
    upperBorder.frame = CGRectMake(0, 0, CGRectGetWidth(self.frame), 1.0f);
    [self.layer addSublayer:upperBorder];
}

- (void)calculateSelectedIndexPath {
    NSUInteger index = -1;
    if ([FILTERS_KEY_WORDS containsObject:[MTSettings sharedSettings].filterKeyWords]) {
        index = [FILTERS_KEY_WORDS indexOfObject:[MTSettings sharedSettings].filterKeyWords];
    }
    
    self.selectedIndexPath = [NSIndexPath indexPathForRow:index inSection:0];
}

- (void)registerCells {
    [self.tableView registerNib:[UINib nibWithNibName:@"MTFilterViewCell"
                                               bundle:nil]
                               forCellReuseIdentifier:FILTER_VIEW_CELL];
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 3;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *finalCell = nil;

    MTFilterViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:FILTER_VIEW_CELL
                                    forIndexPath:indexPath];
    if (indexPath.row == self.selectedIndexPath.row) {
        cell.markImageView.hidden = false;
    }
    
    if(indexPath.row == MTLocationViewCellBrunch) {
        cell.leftImageLabel.text = @"";
        cell.captionLabel.text = @"Brunch";
        finalCell = cell;
    }
    
    if(indexPath.row == MTLocationViewCellWine) {
        cell.leftImageLabel.text = @"";
        cell.captionLabel.text = @"Wine, Beeer & Cocktails";
        finalCell = cell;
    }
    
    if(indexPath.row == MTLocationViewCellCoffee) {
        cell.leftImageLabel.text = @"";
        cell.captionLabel.text = @"Coffee & Tea";
        finalCell = cell;
    }
    
    return finalCell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [MTSettings sharedSettings].filterKeyWords = FILTERS_KEY_WORDS[indexPath.row];
    MTFilterViewCell *currentlySelectedCell = [self.tableView cellForRowAtIndexPath:self.selectedIndexPath];
    currentlySelectedCell.markImageView.hidden = true;
    
    MTFilterViewCell *newlySelectedCell = [self.tableView cellForRowAtIndexPath:indexPath];
    newlySelectedCell.markImageView.hidden = false;
    
    self.selectedIndexPath = indexPath;
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self.delegate hideFilterView:false];
        self.delegate = nil;
    });
    
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pullDistance = (scrollView.contentOffset.y + scrollView.frame.size.height) - scrollView.contentSize.height;
    if (pullDistance < -22) {
        [self.delegate hideFilterView:true];
        self.delegate = nil;
    }
}

@end
