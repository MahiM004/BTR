//
//  UIImageView+AFNetworkingFadeIn.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-11-11.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AFNetworking.h>

@interface UIImageView (AFNetworkingFadeIn)
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage fadeInWithDuration:(CGFloat)duration;
@end
