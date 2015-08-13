//
//  TRVGuideProfileImageView.m
//  Indigenous
//
//  Created by Leo Kwan on 8/2/15.
//  Copyright (c) 2015 Bad Boys 3. All rights reserved.
//

#import "TRVGuideProfileImageView.h"
#import <Masonry/Masonry.h>
#import <QuartzCore/QuartzCore.h>


@interface TRVGuideProfileImageView ()

@property (strong, nonatomic) IBOutlet UIView *guideProfileView;
@property (weak, nonatomic) IBOutlet UIImageView *profileImageView;
@property (weak, nonatomic) IBOutlet UILabel *guideTagLineLabel;
@property (weak, nonatomic) IBOutlet UILabel *nameLabel;


@end

@implementation TRVGuideProfileImageView


-(id)initWithCoder:(NSCoder *)aDecoder
{
    self = [super initWithCoder:aDecoder];
    if(self) {
        [self commonInit];
    }
    
    return self;
}

-(instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if(self) {
        [self commonInit];
    }
    
    return self;
}

-(void)setUserForThisGuideProfileView:(TRVUser *)userForThisGuideProfileView {
    _userForThisGuideProfileView = userForThisGuideProfileView;
    
    self.profileImageView.image = userForThisGuideProfileView.userBio.profileImage;
    
    
    
    
    // SET TAGLINE LABEL AS BIO DESCRIPTION FOR NOW, 
    self.guideTagLineLabel.text = userForThisGuideProfileView.userBio.userTagline;
    NSLog(@"THIS IS THE TAG LINE %@" ,userForThisGuideProfileView.userBio.userTagline);
    self.nameLabel.text = userForThisGuideProfileView.userBio.firstName;
}


-(void)commonInit
{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class)
                                  owner:self
                                options:nil];
    
    [self addSubview:self.guideProfileView];
    
    // add TAP RECOGNIZER for image tap
    UITapGestureRecognizer *profileImageTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(imageTapped:)];
    [self.guideProfileView addGestureRecognizer:profileImageTap];
    self.guideProfileView.userInteractionEnabled = YES;

    

    // set constraints for imageView to superview
    [self.guideProfileView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(@0);
    }];
    
    [self createCircleImageViewMask];
}

- (void)imageTapped:(id)sender {
    //RETURN USER FOR THIS IMAGE
    TRVUser *userForThisNib = self.userForThisGuideProfileView;
    [self.delegate returnUserForThisImageNib:userForThisNib];
}


-(void)createCircleImageViewMask {
    
    CALayer *imageLayer = self.profileImageView.layer;
    //convert uicolor to CGColor
    imageLayer.borderColor = [[UIColor grayColor] CGColor];
    [imageLayer setCornerRadius:self.profileImageView.frame.size.width/2];
    [imageLayer setBorderWidth:2];
    // This carves the cirle
    [imageLayer setMasksToBounds:YES];

}

@end
