//
//  TCViperModuleTransitionHandlerProtocol.h
//  Tayphoon
//
//  Created by Tayphoon on 16.08.16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TCViperOpenModulePromise;
@protocol TCViperModuleInput;
@protocol TCViperModuleTransitionHandlerProtocol;


@protocol TCViperModuleTransitionHandlerProtocol <NSObject>

@optional

// Module input object
@property (nonatomic, strong) id<TCViperModuleInput> moduleInput;

- (TCViperOpenModulePromise*)moduleOpenPromiseForController:(UIViewController*)destinationViewController;

// Method opens module controller
- (TCViperOpenModulePromise*)openModuleController:(UIViewController*)controller;

// Method prsent module controller
- (TCViperOpenModulePromise*)presentModuleController:(UIViewController*)controller;

- (void)closeModalModule;

// Method removes/closes module
- (void)closeCurrentModule;

- (void)closeAllBeforeCurrentModule;

@end
