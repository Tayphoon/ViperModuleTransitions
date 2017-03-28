//
//  TCViperOpenModulePromise.h
//  Tayphoon
//
//  Created by Tayphoon on 16.08.16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCViperModuleOutput;
@protocol TCViperModuleInput;

typedef void(^PostLinkActionBlock)();

/**
 This module is used to link modules one to another. ModuleInput is typically presenter of module.
 Block can be used to return module output.
 */
typedef id<TCViperModuleOutput>(^TCViperModuleLinkBlock)(id<TCViperModuleInput> moduleInput);

/**
 Promise used to configure module input.
 */
@interface TCViperOpenModulePromise : NSObject

@property (nonatomic,strong) id<TCViperModuleInput> moduleInput;
@property (nonatomic,strong) PostLinkActionBlock postLinkActionBlock;

- (void)thenChainUsingBlock:(TCViperModuleLinkBlock)linkBlock;

@end
