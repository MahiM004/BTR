//
//  BTRLoader.h
//  BeyondTheRack
//
//  Created by Ali Pourhadi on 2015-09-21.
//  Copyright (c) 2015 Hadi Kheyruri. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface BTRLoader : NSObject

+ (void)showLoaderInView:(UIView *)view;
+ (void)hideLoaderFromView:(UIView *)view;

+ (void)showLoaderWithViewDisabled:(UIView *)view withLoader:(BOOL)showLoader withTag:(NSInteger)tag;
+ (void)removeLoaderFromViewDisabled:(UIView *)view withTag:(NSInteger)tag;

@end
