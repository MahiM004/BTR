//
//  UIImageView+AFNetworkingFadeIn.m
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-11-11.
//  Copyright © 2015 Hadi Kheyruri. All rights reserved.
//

#import "UIImageView+AFNetworkingFadeIn.h"

@implementation UIImageView (AFNetworkingFadeIn)
- (void)setImageWithURL:(NSURL *)url placeholderImage:(UIImage *)placeholderImage fadeInWithDuration:(CGFloat)duration {
    NSMutableURLRequest *request = [NSMutableURLRequest requestWithURL:url];
    [request setHTTPShouldHandleCookies:NO];
    [request addValue:@"image/*" forHTTPHeaderField:@"Accept"];
    
    __weak typeof (self) weakSelf = self;
    
    [self setImageWithURLRequest:request placeholderImage:placeholderImage success:^(NSURLRequest *request, NSHTTPURLResponse *response, UIImage *image) {
        UIImage *cachedImage = [[[weakSelf class] sharedImageCache] cachedImageForRequest:request];
        if (cachedImage)
            [weakSelf setImage:image];
        else
            [UIView transitionWithView:weakSelf duration:duration options:UIViewAnimationOptionTransitionCrossDissolve animations:^{
                [weakSelf setImage:image];
            } completion:nil];
    } failure:nil];
}
@end
