//
//  TCViperOpenModulePromise.m
//  Tayphoon
//
//  Created by Tayphoon on 16.08.16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import "TCViperOpenModulePromise.h"
#import "TCViperModuleInput.h"

@interface TCViperOpenModulePromise()

@property (nonatomic,strong) __nullable TCViperModuleLinkBlock linkBlock;
@property (nonatomic,assign) BOOL linkBlockWasSet;
@property (nonatomic,assign) BOOL moduleInputWasSet;

@end

@implementation TCViperOpenModulePromise

- (void)setModuleInput:(id<TCViperModuleInput> __nullable)moduleInput {
    _moduleInput = moduleInput;
    self.moduleInputWasSet = YES;
    [self tryPerformLink];
}

- (void)thenChainUsingBlock:(__nullable TCViperModuleLinkBlock)linkBlock {
    self.linkBlock = linkBlock;
    self.linkBlockWasSet = YES;
    [self tryPerformLink];
}

- (void)tryPerformLink {
    if (self.linkBlockWasSet && self.moduleInputWasSet) {
        [self performLink];
    }
}

- (void)performLink {
    if (self.linkBlock != nil) {
        id<TCViperModuleOutput> moduleOutput = self.linkBlock(self.moduleInput);
        if ([self.moduleInput respondsToSelector:@selector(setModuleOutput:)]) {
            [self.moduleInput setModuleOutput:moduleOutput];
        }
        if (self.postLinkActionBlock) {
            self.postLinkActionBlock();
        }
    }
}

@end
