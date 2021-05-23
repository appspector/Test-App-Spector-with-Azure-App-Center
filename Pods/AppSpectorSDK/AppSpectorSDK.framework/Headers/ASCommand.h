//
//  ASCommand.h
//  AppSpectorSDK
//
//  Created by Deszip on 20.08.2019.
//  Copyright © 2019 Techery. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@class ASCommand;

/// Block called once command was executed from the frontend.
/// To complete the command you should call either `complete()` or `fail()` blocks on the command.
typedef void(^ASCommandBlock)(__kindof ASCommand *command);

/// Completion callback of the command. Calling it marks command as finished on the frontend.
/// You can pass any object as a result but only KVC compliant properties will be displayed.
typedef void(^ASCommandCompletion)(_Nullable id result);

/// Failure callback to mark command as failed
typedef void(^ASCommandFailure)(void);



/// Base class for commands subtypes to use with Commands monitor.
/// All commands you use should inherit from `ASCommand`, using other types will have no effect.
/// To add custom field to the command you should declare it as `@objc dynamic var` and make it optional.
/// Supported types are `NSDate`, `NSNumber`, `NSString` and `BOOL`.
@interface ASCommand : NSObject

/// Name of the command will be displayed in commands list on the frontend and should be unique for a command class.
/// Default value is a command class name.
@property (class, copy, nonatomic, readonly) NSString *name;

/// Command category is used to group commands on the frontend.
/// Commands with the same `category` will be displayed under one section.
/// Default category is `Other`
@property (class, copy, nonatomic, readonly) NSString *category;

/// To finish the command you have to call one of the following blocks anytime after command was triggered
@property (copy, nonatomic) ASCommandCompletion complete;
@property (copy, nonatomic) ASCommandFailure fail;

@end

NS_ASSUME_NONNULL_END
