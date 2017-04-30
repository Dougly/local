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

#define CELL_HEIGHT                 220

typedef void(^DetailsLargsetPhotoCompletion)(MTPhoto *largestPhoto);

@interface ListView()<UITabBarDelegate, UITableViewDataSource>
@property (nonatomic, weak) IBOutlet UITableView *tableView;
@property (nonatomic, strong) NSArray *places;
@end

NSString *const LIST_VIEW_CELL = @"MTListViewCell";

@implementation ListView

- (void)awakeFromNib {
    [super awakeFromNib];
    
    [self registerCells];
    self.tableView.tableFooterView = [[UIView alloc] initWithFrame:CGRectZero];
    
    [self getAllPlaces];
}

- (void)registerCells {
    [self.tableView registerNib:[UINib nibWithNibName:@"MTListViewCell"
                                               bundle:nil]
                               forCellReuseIdentifier:LIST_VIEW_CELL];
}

- (void)getAllPlaces {
    self.places = [[MTDataModel sharedDatabaseStorage] getPlaces];
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
    
    int maxWidth = [[UIScreen mainScreen] scale] * [UIScreen mainScreen].bounds.size.width  *2;
    int maxHeight = [[UIScreen mainScreen] scale] * CELL_HEIGHT  *2;
    
    __weak typeof(cell) weakCell = cell;

    cell.mainImageView.image = nil;
    [self getDetails:place completion:^(MTPhoto *largestPhoto) {
        NSString *strinUrl = [NSString stringWithFormat:@"https://maps.googleapis.com/maps/api/place/photo?maxwidth=%d&maxheight=%d&photoreference=%@&key=%@", maxWidth, maxHeight, largestPhoto.reference, kGoogleMapAPIKey];
        
        
        [weakCell.mainImageView setImageWithURL:[NSURL URLWithString:strinUrl] completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType) {
            weakCell.mainImageView.alpha = 0.0;
            
            weakCell.mainImageView.image = image;
            weakCell.mainImageView.contentMode = UIViewContentModeScaleToFill;
            
            [UIView animateWithDuration:0.5 animations:^{
                weakCell.mainImageView.alpha = 1.0;
            }];
            
            [weakCell.contentView bringSubviewToFront:weakCell.bottomView];
            [weakCell.contentView bringSubviewToFront:weakCell.titleLabel];
            [weakCell.contentView bringSubviewToFront:weakCell.detailsLabel];
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
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return CELL_HEIGHT;
}

- (void)getDetails:(MTPlace *)place completion:(DetailsLargsetPhotoCompletion)completion {
    
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


@end
