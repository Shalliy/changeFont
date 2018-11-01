//
//  UILabel+FontChange.m
//  ChangeUIKitFont
//
//  Created by liyy on 2017/10/25.
//  Copyright © 2017年 ccdc. All rights reserved.
//

#import "UILabel+FontChange.h"
#import <objc/runtime.h>

#define CustomFontName @"CaiYunHanMaoBi-LiShu"

@implementation UILabel (FontChange)

+ (void)load {
    //方法交换应该被保证，在程序中只会执行一次
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        //获得viewController的生命周期方法的selector
        SEL systemSel = @selector(willMoveToSuperview:);
        //自己实现的将要被交换的方法的selector
        SEL swizzSel = @selector(myWillMoveToSuperview:);
        //两个方法的Method
        Method systemMethod = class_getInstanceMethod([self class], systemSel);
        Method swizzMethod = class_getInstanceMethod([self class], swizzSel);
        /**
         *  我们在这里使用class_addMethod()函数对Method Swizzling做了一层验证，如果self没有实现被交换的方法，会导致失败。
         而且self没有交换的方法实现，但是父类有这个方法，这样就会调用父类的方法，结果就不是我们想要的结果了。
         所以我们在这里通过class_addMethod()的验证，如果self实现了这个方法，class_addMethod()函数将会返回NO，我们就可以对其进行交换了。
         */
        
        
        
        /**
         * Adds a new method to a class with a given name and implementation.
         *
         * @param cls The class to which to add a method.
         * @param name A selector that specifies the name of the method being added.
         * @param imp A function which is the implementation of the new method. The function must take at least two arguments—self and _cmd.
         * @param types An array of characters that describe the types of the arguments to the method.
         *
         * @return YES if the method was added successfully, otherwise NO
         *  (for example, the class already contains a method implementation with that name).
         *
         * @note class_addMethod will add an override of a superclass's implementation,
         *  but will not replace an existing implementation in this class.
         *  To change an existing implementation, use method_setImplementation.
         */
        
        BOOL isAdd = class_addMethod([self class], systemSel, method_getImplementation(swizzMethod), method_getTypeEncoding(swizzMethod));
        if (isAdd) {
            class_replaceMethod([self class], swizzSel, method_getImplementation(systemMethod), method_getTypeEncoding(systemMethod));
        } else {
            //否则，交换两个方法的实现
            method_exchangeImplementations(systemMethod, swizzMethod);
        }
        
        
        //交换Set方法
//        SEL sysSetFont = @selector(setFont:);
//        SEL swizzSetFont = @selector(mySetFont:);
//
//        Method sysSetFontMethod = class_getInstanceMethod([self class], sysSetFont);
//        Method swizzSetFontMethod = class_getInstanceMethod([self class], swizzSetFont);
//
//        method_exchangeImplementations(sysSetFontMethod, swizzSetFontMethod);
    });
}

- (void)myWillMoveToSuperview:(UIView *)newSuperview {
    self.font = [UIFont fontWithName:CustomFontName size:self.font.pointSize];
    
    [self myWillMoveToSuperview:newSuperview];

}

- (void)mySetFont:(UIFont *)font {
    UIFont *swizzFont = [UIFont fontWithName:CustomFontName size:font.pointSize];
    [self mySetFont:swizzFont];
}

@end
