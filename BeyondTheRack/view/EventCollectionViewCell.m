//
//  EventCollectionViewCell.m
//  BeyondTheRack
//
//  Created by Hadi Kheyruri on 2014-12-22.
//  Copyright (c) 2014 Hadi Kheyruri. All rights reserved.
//

#import "EventCollectionViewCell.h"

@implementation EventCollectionViewCell

/*
@synthesize eventImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        eventImageView = [[UIImageView alloc] initWithFrame:frame];
        [self.contentView addSubview:eventImageView];
    }
    return self;
}
*/

@synthesize eventImageView = _eventImageView;

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // WRONG:
        // _imageView = [[UIImageView alloc] initWithFrame:frame];
        
        // RIGHT:
        _eventImageView = [[UIImageView alloc] initWithFrame:self.contentView.bounds];
        [self.contentView addSubview:_eventImageView];
    }
    return self;
}


- (void)prepareForReuse
{
    [super prepareForReuse];
    
    // reset image property of imageView for reuse
    self.eventImageView.image = nil;
    
    // update frame position of subviews
    self.eventImageView.frame = self.contentView.bounds;
}


@end
