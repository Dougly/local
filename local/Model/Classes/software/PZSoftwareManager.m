//
//  PZSoftware.m
//  Proz
//
//  Created by RostyslavStepanyak on 1/22/16.
//  Copyright © 2016 Tilf AB. All rights reserved.
//

#import "PZSoftwareManager.h"
#import "PZSoftware.h"

@interface PZSoftwareManager()
@property (nonatomic, strong) NSMutableArray *softwares;
@end

@implementation PZSoftwareManager

- (id)init {
    self = [super init];
    NSString *jsonPath = [[NSBundle mainBundle] pathForResource:@"software" ofType:@"json"];
    NSError *error;
    NSString *jsonString = [NSString stringWithContentsOfFile:jsonPath encoding:NSUTF8StringEncoding error:&error];
    NSData *data = [jsonString dataUsingEncoding:NSUTF8StringEncoding];
    NSArray *softwareIds = [NSJSONSerialization JSONObjectWithData:data
                                                        options:kNilOptions
                                                          error:&error];
    /*Create the array if not yet created*/
    if(!_softwares) {
        _softwares = [[NSMutableArray alloc] init];
    }

    for(NSDictionary *softwareId in softwareIds) {
        /*Parse the software object*/
        PZSoftware *pzSoft = [[PZSoftware alloc] init];
        pzSoft.name = softwareId[@"software_name"];
        pzSoft.softId = (int)[softwareId[@"software_id"] integerValue];
        
        /*Add the software object*/
        [_softwares addObject:pzSoft];
    }
    return self;
}

/*Find the software object with the id*/
- (PZSoftware *)getSoftById:(int)softId {
    for(PZSoftware *soft in self.softwares) {
        if(soft.softId == softId) {
            return soft;
        }
    }
    
    return nil;
}

/*Get all the softwares names*/
- (NSMutableArray *)allSoftwares {
    NSMutableArray *names = [[NSMutableArray alloc] init];
    
    for(PZSoftware *software in self.softwares) {
        [names addObject:software.name];
    }
    
    return names;
}

- (NSString *)idsByElementNames:(NSArray *)names {
    NSArray* softwares = [self.softwares filteredArrayUsingPredicate:[NSPredicate predicateWithFormat:@"name IN %@", names]];

    NSMutableArray *onlyIds = [[NSMutableArray alloc] init];
    for(PZSoftware *software in softwares) {
        [onlyIds addObject: [NSString stringWithFormat:@"%d", software.softId]];
    }
    
    return [onlyIds componentsJoinedByString:@","];
}

@end
