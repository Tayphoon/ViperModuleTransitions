//
//  TCViperModuleInput.h
//  Tayphoon
//
//  Created by Tayphoon on 16.08.16.
//  Copyright © 2016 Tayphoon. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol TCViperModuleOutput;

@protocol TCViperModuleInput <NSObject>

@optional
- (void)setModuleOutput:(id<TCViperModuleOutput>)moduleOutput;

@end
