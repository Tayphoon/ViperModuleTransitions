//
//  UIViewController+TCViperModuleTransitionHandlerProtocol.m
//  Tayphoon
//
//  Created by Tayphoon on 16.08.16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import <objc/runtime.h>

#import "UIViewController+TCViperModuleTransitionHandlerProtocol.h"
#import "TCViperOpenModulePromise.h"

@protocol TCTranditionalViperViewWithOutput <NSObject>
- (id)output;
@end

@implementation UIViewController(TCViperModuleTransitionHandlerProtocol)

- (id)moduleInput {
    id result = objc_getAssociatedObject(self, @selector(moduleInput));
    if (result == nil && [self respondsToSelector:@selector(output)]) {
        result = [(id<TCTranditionalViperViewWithOutput>)self output];
    }
    return result;
}

- (void)setModuleInput:(id<TCViperModuleInput>)moduleInput {
    objc_setAssociatedObject(self, @selector(moduleInput), moduleInput, OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (TCViperOpenModulePromise*)moduleOpenPromiseForController:(UIViewController*)destinationViewController {
    TCViperOpenModulePromise *openModulePromise = [[TCViperOpenModulePromise alloc] init];
    
    if ([destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController * navigationController = (UINavigationController*)destinationViewController;
        destinationViewController = navigationController.topViewController;
    }
    
    id<TCViperModuleTransitionHandlerProtocol> targetModuleTransitionHandler = destinationViewController;
    id<TCViperModuleInput> moduleInput = nil;
    if ([targetModuleTransitionHandler respondsToSelector:@selector(moduleInput)]) {
        moduleInput = [targetModuleTransitionHandler moduleInput];
    }
    
    openModulePromise.moduleInput = moduleInput;

    return openModulePromise;
}

// Method opens module controller
- (TCViperOpenModulePromise*)openModuleController:(UIViewController*)destinationViewController {
    TCViperOpenModulePromise *openModulePromise = [self moduleOpenPromiseForController:destinationViewController];
        
    [self.navigationController pushViewController:destinationViewController animated:YES];
    
    return openModulePromise;
}

// Method prsent module controller
- (TCViperOpenModulePromise*)presentModuleController:(UIViewController*)destinationViewController {
    TCViperOpenModulePromise *openModulePromise = [[TCViperOpenModulePromise alloc] init];
    
    id<TCViperModuleTransitionHandlerProtocol> targetModuleTransitionHandler = destinationViewController;
    if ([destinationViewController isKindOfClass:[UINavigationController class]]) {
        UINavigationController * navigationController = (UINavigationController*)destinationViewController;
        targetModuleTransitionHandler = navigationController.topViewController;
    }
    
    id<TCViperModuleInput> moduleInput = nil;
    if ([targetModuleTransitionHandler respondsToSelector:@selector(moduleInput)]) {
        moduleInput = [targetModuleTransitionHandler moduleInput];
    }
    
    openModulePromise.moduleInput = moduleInput;

    //Call present module controller in next chain, because loadView called immediately after presentViewController call 
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.navigationController presentViewController:destinationViewController
                                                animated:YES
                                              completion:nil];
    });
    
    return openModulePromise;
}

- (void)closeModalModule {
    [self dismissViewControllerAnimated:YES completion:nil];
}

// Method removes/closes module
- (void)closeCurrentModule {
    BOOL isInNavigationStack = [self.parentViewController isKindOfClass:[UINavigationController class]];
    BOOL hasManyControllersInStack = isInNavigationStack ? ((UINavigationController *)self.parentViewController).childViewControllers.count > 1 : NO;
    
    if (isInNavigationStack && hasManyControllersInStack) {
        UINavigationController *navigationController = (UINavigationController*)self.parentViewController;
        [navigationController popViewControllerAnimated:YES];
    }
    else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.view.superview != nil){
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }
}

- (void)closeAllBeforeCurrentModule {
    BOOL isInNavigationStack = [self.parentViewController isKindOfClass:[UINavigationController class]];
    BOOL hasManyControllersInStack = isInNavigationStack ? ((UINavigationController *)self.parentViewController).childViewControllers.count > 1 : NO;
    
    if (isInNavigationStack && hasManyControllersInStack) {
        UINavigationController *navigationController = (UINavigationController*)self.parentViewController;
        [navigationController popToViewController:self animated:YES];
    }
    else if (self.presentingViewController) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
    else if (self.view.superview != nil){
        [self removeFromParentViewController];
        [self.view removeFromSuperview];
    }
}

@end