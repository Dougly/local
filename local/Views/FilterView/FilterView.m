//
//  TitleView.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/28/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "FilterView.h"
#import "MTFilterViewCell.h"

typedef NS_ENUM(NSInteger, MTFilterViewCellIndex) {
    MTLocationViewCellBrunch = 0,
    MTLocationViewCellWine,
    MTLocationViewCellCoffee
};

@interface FilterView()<UITabBarDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

NSString *const FILTER_VIEW_CELL = @"MTFilterViewCell";

@implementation FilterView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self registerCells];
    self.tableView.allowsSelection = false;
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
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

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pullDistance = (scrollView.contentOffset.y + scrollView.frame.size.height) - scrollView.contentSize.height;
    if (pullDistance < -22) {
        [self.delegate hideFilterView];
        self.delegate = nil;
    }
}

@end
