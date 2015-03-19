//
//  UIDevice+ScreenSize.m
//  UIDevice-Helpers
//
//  Created by Bruno Furtado on 13/12/13.
//  Copyright (c) 2013 No Zebra Network. All rights reserved.
//

#import "UIDevice+ScreenSizeV2.h"

@implementation UIDevice (ScreenSizeV2)

- (UIDScreenSize)screenSizeLatest
{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad) {
        return UIDScreenSizePad;
    }
    
    UIDScreenSize screen = UIDScreenSize35Inch;
    
    if ([[UIScreen mainScreen] bounds].size.height == 480.f) {
        screen = UIDScreenSize35Inch;
    }else if ([[UIScreen mainScreen] bounds].size.height == 568.f) {
        screen = UIDScreenSize4Inch;
    }else if ([[UIScreen mainScreen] bounds].size.height == 667.f) {
        screen = UIDScreenSize47Inch;
    }else if ([[UIScreen mainScreen] bounds].size.height == 736.f) {
        screen = UIDScreenSize55Inch;
    }
    
    return screen;
}

@end 