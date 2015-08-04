//
//  TRVUserContactView.m
//  Indigenous
//
//  Created by Leo Kwan on 8/4/15.
//  Copyright (c) 2015 Bad Boys 3. All rights reserved.
//

#import "TRVUserContactView.h"

@implementation TRVUserContactView



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

-(void)commonInit
{
    [[NSBundle mainBundle] loadNibNamed:NSStringFromClass(self.class)
                                  owner:self
                                options:nil];
    
    [self addSubview:self.userSnippetContentView];
    //    [self.userSnippetContentView addSubview:self.firstNameLabel];
    
}

-(void)setUserForThisSnippetView:(TRVUser *)userForThisSnippetView {
    
    _userForThisSnippetView = userForThisSnippetView;
    
    self.firstNameLabel.text = userForThisSnippetView.userBio.firstName;
    self.lastNameLabel.text = userForThisSnippetView.userBio.lastName;
    self.oneLinerLabel.text = userForThisSnippetView.userBio.bioDescription;
    NSLog(@"%@!!!!!!!!!!!", userForThisSnippetView.userBio.firstName);
    NSLog(@"%@!!!!!!!!!!!",  self.firstNameLabel.text);
    
}

@end
