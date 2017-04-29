//
//  TitleView.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/28/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "LocationView.h"
#import "MTLocationViewTextfieldCell.h"
#import "MTLocationViewCurrentLocationCell.h"

typedef NS_ENUM(NSInteger, MTLocationViewCellIndex) {
    MTLocationViewCellTextfield = 0,
    MTLocationViewCellCurrent,
};

@interface LocationView()<UITabBarDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@end

NSString *const LOCATION_VIEW_CELL_TEXTFIELD = @"MTLocationViewTextfieldCell";
NSString *const LOCATION_VIEW_CELL_CURRENT = @"MTLocationViewCurrentLocationCell";

@implementation LocationView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self registerCells];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
}

- (void)registerCells {
    [self.tableView registerNib:[UINib nibWithNibName:@"MTLocationViewTextfieldCell"
                                               bundle:nil]
                               forCellReuseIdentifier:LOCATION_VIEW_CELL_TEXTFIELD];
    [self.tableView registerNib:[UINib nibWithNibName:@"MTLocationViewCurrentLocationCell"
                                               bundle:nil]
                               forCellReuseIdentifier:LOCATION_VIEW_CELL_CURRENT];
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return 2;
}


- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    UITableViewCell *finalCell = nil;

    if(indexPath.row == MTLocationViewCellTextfield) {
        MTLocationViewTextfieldCell *cell =
        [tableView dequeueReusableCellWithIdentifier:LOCATION_VIEW_CELL_TEXTFIELD
                                        forIndexPath:indexPath];
        cell.containerView = self;
        
        finalCell = cell;
    }
    
    if(indexPath.row == MTLocationViewCellCurrent) {
        MTLocationViewCurrentLocationCell *cell =
        [tableView dequeueReusableCellWithIdentifier:LOCATION_VIEW_CELL_CURRENT
                                        forIndexPath:indexPath];
        
        finalCell = cell;
    }
    
    return finalCell;
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    CGFloat pullDistance = scrollView.contentOffset.y;
    if (pullDistance > 50) {
        [self.delegate hideLocationView];
        self.delegate = nil;
    }
}


@end
