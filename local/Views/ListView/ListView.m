//
//  TitleView.m
//  Local
//
//  Created by Rostyslav.Stepanyak on 4/28/17.
//  Copyright © 2017 Tilf AB. All rights reserved.
//

#import "ListView.h"
#import "MTListViewCell.h"
#import "MTDataModel.h"
#import "MTPhoto.h"
#import "MTPlaceDetails.h"
#import "MTPlace.h"
#import "UIImageView+WebCache.h"
#import "MTGetPlaceDetailRequest.h"
#import "MTGetPlaceDetailsResponse.h"
#import "FilterListener.h"
#import "MTProgressHUD.h"

#define NUMBER_OF_CELLS_PER_SCREEN                 3.1

typedef void(^DetailsLargsetPhotoCompletion)(MTPhoto *largestPhoto);

@interface ListView()<UITabBarDelegate, UITableViewDataSource, UISearchBarDelegate>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSMutableArray *places;
@property (nonatomic, strong) FilterListener *filterListener;

@property (nonatomic, strong) NSArray *placesBeforeSort;
@property (nonatomic, strong) NSMutableArray *oldRowsBeforeSort;
@property (nonatomic, strong) NSMutableArray *updatedRowsAfterSort;
@property (nonatomic, weak) IBOutlet UIProgressView *progressView;
@property (nonatomic, strong) NSTimer *hideProgressViewTimer;
@property (nonatomic, weak) IBOutlet NSLayoutConstraint *progressViewHeight;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;

@property (nonatomic) CGFloat CELL_HEIGHT;
@end

NSString *const LIST_VIEW_CELL = @"MTListViewCell";

@implementation ListView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];

    [self subscribeForNewPlaces];
    [self registerCells];
    [self getAllPlaces];
    [self.activityIndicator startAnimating];
}

- (void)layoutSubviews {
    [super layoutSubviews];
    
    _CELL_HEIGHT = self.tableView.bounds.size.height / NUMBER_OF_CELLS_PER_SCREEN;
}

- (void)subscribeForNewPlaces {
    __weak typeof(self) weakSelf = self;
    self.filterListener.onKeyWordUpdatedHandler = ^{
        [weakSelf keyWordsChanged];
    };
    
    self.filterListener.onNewPlacesReceivedHandler = ^(BOOL finalPackOfPlaces){
        [weakSelf gotNewPlaces:finalPackOfPlaces];
    };
    
    self.filterListener.onLocationChangedHandler = ^{
        [weakSelf locationChanged];
    };
}

- (void)registerCells {
    [self.tableView registerNib:[UINib nibWithNibName:@"MTListViewCell"
                                               bundle:nil]
                               forCellReuseIdentifier:LIST_VIEW_CELL];
}

- (void)getAllPlaces {
    self.places = [[NSMutableArray alloc] initWithArray: [[MTDataModel sharedDatabaseStorage] getPlaces]];
}

#pragma mark - UITableView delegate

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView
 numberOfRowsInSection:(NSInteger)section {
    return self.places.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView
         cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    MTListViewCell *cell =
    [tableView dequeueReusableCellWithIdentifier:LIST_VIEW_CELL
                                    forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    MTPlace *place = [self.places objectAtIndex:indexPath.row];
    
    cell.titleLabel.text = place.name;
    cell.detailsLabel.text = [place getDetailsString];
    
    //int maxWidth = [[UIScreen mainScreen] scale] * [UIScreen mainScreen].bounds.size.width * 2;
    //int maxHeight = [[UIScreen mainScreen] scale] * self.CELL_HEIGHT*2;
    
    __weak typeof(cell) weakCell = cell;

    cell.mainImageView.image = nil;
    [self getDetails:place completion:^(MTPhoto *largestPhoto) {
        if (!largestPhoto) {
            NSLog(@"No Photo: %@", place.name);
        }
        NSString *strinUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxheight=%d&photoreference=%@&key=%@", 1600, largestPhoto.reference, kGoogleMapAPIKey];
        
        
        [weakCell.mainImageView setImageWithURL:[NSURL URLWithString:strinUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            
            if (image) {
                weakCell.mainImageView.image = image;
                weakCell.mainImageView.contentMode = UIViewContentModeScaleAspectFill;
                
                [weakCell.contentView bringSubviewToFront:weakCell.bottomView];
                [weakCell.contentView bringSubviewToFront:weakCell.titleLabel];
                [weakCell.contentView bringSubviewToFront:weakCell.detailsLabel];
            }
        }];
    }];
    
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    MTPlace *selectedPlace = self.places[indexPath.row];
    
    [self.delegate didSelectItemForPlace:selectedPlace];
}

- (void)tableView:(UITableView *)tableView didDeselectRowAtIndexPath:(NSIndexPath *)indexPath {
    MTListViewCell *cell = [self.tableView cellForRowAtIndexPath:indexPath];
    
    [cell.contentView bringSubviewToFront:cell.bottomView];
    [cell.contentView bringSubviewToFront:cell.titleLabel];
    [cell.contentView bringSubviewToFront:cell.detailsLabel];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return self.CELL_HEIGHT;
}

- (void)getDetails:(MTPlace *)place completion:(DetailsLargsetPhotoCompletion)completion {
    MTPlaceDetails *placeDetails = [[MTDataModel sharedDatabaseStorage] getPlaceDetialsForId:place.placeId];
    
    if (placeDetails) {
        completion([placeDetails getLargestPhoto]);
    }
    else {
        MTGetPlaceDetailRequest *request = [MTGetPlaceDetailRequest requestWithOwner:self];
        request.placeId = place.placeId;
        
        request.completionBlock = ^(SDRequest *request, SDResult *response)
        {
            if ([response isSuccess]) {
                MTGetPlaceDetailsResponse *detailsResponse = (MTGetPlaceDetailsResponse *)response;
                MTPlaceDetails *placeDetails = detailsResponse.placeDetails;
                MTPhoto *largestPhoto = [placeDetails getLargestPhoto];
                completion(largestPhoto);
            }
            else {
                completion(nil);
            }
        };
        [request run];
    }
}

#pragma mark - new places listener

- (void)keyWordsChanged {
    self.places = nil;
    [self.tableView reloadData];
    [[MTProgressHUD sharedHUD] showOnView:self percentage:false];
}

- (void)gotNewPlaces:(BOOL)isFinalPackOfPlaces {
    [self updateProgressView:isFinalPackOfPlaces];
    [[MTProgressHUD sharedHUD] dismiss];
    
    if (!self.places || self.places.count == 0) {
        [self.hideProgressViewTimer invalidate];
        
        NSMutableArray *places = [[NSMutableArray alloc] initWithArray: [[MTDataModel sharedDatabaseStorage] getPlaces]];
        
        NSMutableArray *sortedPlaces = [self sortPlacesByDistance:places];
        self.places = sortedPlaces;
        [self.tableView reloadData];
    }
    else {
        NSMutableArray *newPlaces = [[NSMutableArray alloc] initWithArray: [[MTDataModel sharedDatabaseStorage] getPlaces]];
        
        //remove the places that we already have in datasource from the array with new places
        [newPlaces removeObjectsInArray:self.places];
        newPlaces = [self sortPlacesByDistance:newPlaces];
        
        //Get the indexes of new rows
        NSMutableArray *newIndexes = [NSMutableArray new];
        for (int i=0; i<newPlaces.count; i++) {
            [newIndexes addObject:[NSIndexPath indexPathForRow:(self.places.count + i) inSection:0]];
        }
        
        self.placesBeforeSort = [NSArray arrayWithArray:self.places];
        //add new unique objects one by one
        [self.places addObjectsFromArray:newPlaces];
        NSMutableArray *sortedPlaces = [self sortPlacesByDistance:self.places];
        self.places = sortedPlaces;
        
        [self.tableView beginUpdates];
        [self.tableView insertRowsAtIndexPaths:newIndexes withRowAnimation:UITableViewRowAnimationNone];
        [self.tableView endUpdates];
        
        [self.tableView beginUpdates];
        [self animateSortedRows];
        [self.tableView endUpdates];
    }
}

- (void)locationChanged {
    self.places = nil;
    [self.tableView reloadData];
    self.activityIndicator.hidden = NO;
    [self.activityIndicator startAnimating];
}

- (void)updateProgressView:(BOOL)isFinalPackOfPlaces {
    if (isFinalPackOfPlaces) {
        self.progressViewHeight.constant = 2;
        [self.progressView setProgress:1.0 animated:YES];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.hideProgressViewTimer = [NSTimer scheduledTimerWithTimeInterval:1.4 target:self selector:@selector(hideProgressView) userInfo:nil repeats:NO];
        });
    }
    else {
        self.progressView.progress = 0;
        self.progressViewHeight.constant = 2;
        [self.activityIndicator stopAnimating];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.7 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.progressView updateConstraints];
            [self.progressView layoutSubviews];
            [self.progressView setProgress:0.6 animated:YES];
        });
    }
}

- (void)hideProgressView {
    self.progressViewHeight.constant = 0;
}

- (void)animateSortedRows {
    self.oldRowsBeforeSort = [NSMutableArray new];
    self.updatedRowsAfterSort = [NSMutableArray new];
    
    for (int i = 0; i < self.placesBeforeSort.count; i++)
    {
        // newRow will get the new row of an object.  i is the old row.
        NSInteger newRow = [self.places indexOfObject:self.placesBeforeSort[i]];
        
        NSIndexPath *oldRowIndexPath = [NSIndexPath indexPathForRow:i inSection:0];
        NSIndexPath *updatedRowIndexPath = [NSIndexPath indexPathForRow:newRow inSection:0];
        
        [self.oldRowsBeforeSort addObject:oldRowIndexPath];
        [self.updatedRowsAfterSort addObject:updatedRowIndexPath];
        [self.tableView moveRowAtIndexPath:oldRowIndexPath toIndexPath:updatedRowIndexPath];
    }
}

- (NSMutableArray *)sortPlacesByDistance:(NSArray *)places {
    NSSortDescriptor* sortOrder = [NSSortDescriptor sortDescriptorWithKey: @"distance"
                                                                ascending: YES];
    NSArray *sortedPlaces = [places sortedArrayUsingDescriptors: [NSArray arrayWithObject: sortOrder]];
    return [[NSMutableArray alloc] initWithArray:sortedPlaces];
}

#pragma mark - UISearchBarDelegate

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText {
    if (searchText.length > 0) {
        NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"name CONTAINS[cd]%@", searchText];
        
        NSArray *allStoredPlaces = [[MTDataModel sharedDatabaseStorage] getPlaces];
        self.places = [[NSMutableArray alloc] initWithArray:[allStoredPlaces filteredArrayUsingPredicate:namePredicate]];
        self.places = [self sortPlacesByDistance:self.places];
    }
    else {
        self.places = [[NSMutableArray alloc] initWithArray:[[MTDataModel sharedDatabaseStorage] getPlaces]];
        self.places = [self sortPlacesByDistance:self.places];
        [searchBar performSelector: @selector(resignFirstResponder)
                        withObject: nil
                        afterDelay: 0.1];
    }
    
    [self.tableView reloadData];
}

#pragma mark - access overrides

- (FilterListener *)filterListener {
    if (!_filterListener) {
        _filterListener = [FilterListener new];
    }
    
    return _filterListener;
}


@end
