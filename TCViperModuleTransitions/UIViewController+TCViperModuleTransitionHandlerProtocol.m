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
    TCViperOpenModulePromise * openModulePromise = [[TCViperOpenModulePromise alloc] init];
    
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

    return openModulePromise;
}

// Method opens module controller
- (TCViperOpenModulePromise*)openModuleController:(UIViewController*)destinationViewController {
    TCViperOpenModulePromise * openModulePromise = [self moduleOpenPromiseForController:destinationViewController];
        
    [self.navigationController pushViewController:destinationViewController animated:YES];
    
    return openModulePromise;
}

// Method prsent module controller
- (TCViperOpenModulePromise*)presentModuleController:(UIViewController*)destinationViewController {
    TCViperOpenModulePromise * openModulePromise = [self moduleOpenPromiseForController:destinationViewController];

    //Call present module controller in next chain, because loadView called immediately after presentViewController call 
    dispatch_async(dispatch_get_main_queue(), ^{
        [self presentViewController:destinationViewController
                           animated:YES
                         completion:nil];
    });
    
    return openModulePromise;
}

- (TCViperOpenModulePromise*)openSubmoduleController:(UIViewController*)destinationViewController
                                         inContainer:(UIView*)containerView {
    TCViperOpenModulePromise * openModulePromise = [self moduleOpenPromiseForController:destinationViewController];
    
    dispatch_async(dispatch_get_main_queue(), ^{
        [self addChildViewController:destinationViewController];
        destinationViewController.view.translatesAutoresizingMaskIntoConstraints = NO;
        [containerView addSubview:destinationViewController.view];
        [self configureLayoutConstraintsForView:destinationViewController.view inContainerView:containerView];
        [destinationViewController didMoveToParentViewController:self];
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

#pragma mark - Private methods

- (void)configureLayoutConstraintsForView:(UIView*)view inContainerView:(UIView*)containerView {
    [view.topAnchor constraintEqualToAnchor:containerView.topAnchor].active = YES;
    [view.leadingAnchor constraintEqualToAnchor:containerView.leadingAnchor].active = YES;
    [view.trailingAnchor constraintEqualToAnchor:containerView.trailingAnchor].active = YES;
    [view.bottomAnchor constraintEqualToAnchor:containerView.bottomAnchor].active = YES;
}

@end
