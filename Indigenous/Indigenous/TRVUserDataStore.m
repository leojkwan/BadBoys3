//
//  TRVUserDataStore.m
//  Indigenous
//
//  Created by Leo Kwan on 8/3/15.
//  Copyright (c) 2015 Bad Boys 3. All rights reserved.
//

#import "TRVUserDataStore.h"
#import <AFNetworking/UIKit+AFNetworking.h>
#import <Parse.h>
#import "TRVAFNetwokingAPIClient.h"
#import <AFNetworkReachabilityManager.h>
#import "TRVNetworkRechabilityMonitor.h"

@interface TRVUserDataStore()
@property (nonatomic, strong) NSDictionary *parseUserInfo;

@end

@implementation TRVUserDataStore


+ (instancetype)sharedUserInfoDataStore {
    static TRVUserDataStore *_sharedTasksDataStore = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedTasksDataStore = [[TRVUserDataStore alloc] init];
    });
    
    return _sharedTasksDataStore;
}


-(instancetype)init {
    self = [super init];
    if (self) {
        [TRVNetworkRechabilityMonitor startNetworkReachabilityMonitoring];
        [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
            NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
            _currentInternetStatus = AFStringFromNetworkReachabilityStatus(status);
            NSLog(@" WHAT IS THIS??    %ld", (long)status);
        }];
    }
    return self;
}



- (void) setCurrentUser:(PFUser *)currentUser {

        _parseUser = currentUser;
        PFQuery *query = [PFQuery queryWithClassName:@"UserBio"];
         PFObject *object = currentUser[@"userBio"];
         [object pinInBackground];

//        // IF WE ARE OFFLINE
//        if (_currentInternetStatus == 0) {
//            [query fromLocalDatastore];
//            [query getObjectInBackgroundWithId:object.objectId];
//            NSLog(@"ARE YOU EVER IN HERE? IF SO WHAT IS YOUR OBJECT ID?: %@", object.objectId);
//            }
//    
    
    
    // SET EQUAL TO AS LOGGED IN USER
    [query whereKey:@"objectId" equalTo:object.objectId];
    NSLog(@"YOU'RE QUERY FROM PARSE DB ... WHAT IS YOUR OBJECT ID?: %@", object.objectId);
    
    [query findObjectsInBackgroundWithBlock:^(NSArray *objects,NSError *error) {
        if (error) {
            NSLog(@"Error: %@ %@", error, [error userInfo]);
        } else {
            TRVBio *bioForLoggedInUser = [[TRVBio alloc] init];
            bioForLoggedInUser.firstName = objects[0][@"first_name"];
            bioForLoggedInUser.lastName = objects[0][@"last_name"];
            bioForLoggedInUser.birthday = objects[0][@"birthday"];
            bioForLoggedInUser.email = objects[0][@"email"];
            bioForLoggedInUser.homeCity = @"";
            bioForLoggedInUser.homeCountry = @"";
            bioForLoggedInUser.isGuide = objects[0][@"isGuide"];
           bioForLoggedInUser.language = objects[0][@"languagesSpoken"];
           // bioForLoggedInUser.language = @"English, Chinese, French";
            

            // HARDCODED USER TAGLINE, UNCOMMMENT LINE BELOW ONCE THERE IS PLACE TO INPUT TAGLINE
//            bioForLoggedInUser.userTagline = objects[0][@"oneLineBio"];
            bioForLoggedInUser.userTagline = @"I'm the damn best guide you ever done seen.";

            // HARDCODED USER BIO, UNCOMMMENT LINE BELOW ONCE THERE IS PLACE TO USER BIO
//            bioForLoggedInUser.bioDescription = objects[0][@"bioTextField"];
            bioForLoggedInUser.bioDescription = @"Hi, my name is X and I like to take people on tours. I am such a good tour that New York Times Magazine rated me best tour of all time.";
            
            
            // DEPENDS ON IF FACEBOOK OR EMAIL LOGGED IN
            if (objects[0][@"picture"]){
                
                [TRVAFNetwokingAPIClient getImagesWithURL:objects[0][@"picture"] withCompletionBlock:^(UIImage *response) {
                    
                    // Setting profile Image with AFNetworking request
                    bioForLoggedInUser.profileImage = response;
                }];
                
            } else {

                // CONVERT EMAIL PFFILE IMAGE TO UIIMAGE
                
                PFFile *pictureFile = objects[0][@"emailPicture"];
                [pictureFile getDataInBackgroundWithBlock:^(NSData *data, NSError *error) {
                    if (!error) {
                        bioForLoggedInUser.profileImage = [UIImage imageWithData:data];
                        
                    } else {
                        // error block
                    }
                }];
            }
            
            // set logged in user to Parse query
    
            _loggedInUser = [[TRVUser alloc] initWithBio:bioForLoggedInUser];
            NSLog(@"Welcome %@. ", _loggedInUser.userBio.firstName);
        }
    }];

}


@end
