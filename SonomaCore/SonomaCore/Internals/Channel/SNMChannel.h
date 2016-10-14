/*
 * Copyright (c) Microsoft Corporation. All rights reserved.
 */

#import "SNMChannelConfiguration.h"
#import "SNMConstants+Internal.h"
#import "SNMEnable.h"
#import "SNMLog.h"
#import "SNMSender.h"
#import "SNMSenderDelegate.h"
#import "SNMStorage.h"
#import <Foundation/Foundation.h>
@protocol SNMChannelDelegate;

NS_ASSUME_NONNULL_BEGIN

/**
 Defines a channel which manages a queue of log items.
 */
@protocol SNMChannel <NSObject, SNMSenderDelegate, SNMEnable>

@required

/*
 * The configuration used by this channel.
 */
@property(nonatomic, strong) SNMChannelConfiguration *configuration;

/**
 * Initializes a new `SNMChannelDefault` instance.
 *
 * @param sender A sender instance that is used to send batches of log items to
 * the backend.
 * @param storage A storage instance to store and read enqueued log items.
 * @param configuration The configuration used by this channel.
 * @param callbackQueue A queue on which the handler is called on.
 *
 * @return A new `SNMChannelDefault` instance.
 */
- (instancetype)initWithSender:(id<SNMSender>)sender
                       storage:(id<SNMStorage>)storage
                 configuration:(SNMChannelConfiguration *)configuration
                 callbackQueue:(dispatch_queue_t)callbackQueue;

/**
 * Enqueues a new log item.
 *
 * @param item The log item that should be enqueued.
 */
- (void)enqueueItem:(id<SNMLog>)item;

/**
 * Delete all logs from storage.
 */
- (void)deleteAllLogs;

/**
 * Flushes all logs from the storage.
 */
- (void)flushQueue;

/**
 *  Add delegate.
 *
 *  @param delegate delegate.
 */
- (void)addDelegate:(id<SNMChannelDelegate>)delegate;

/**
 *  Remove delegate.
 *
 *  @param delegate delegate.
 */
- (void)removeDelegate:(id<SNMChannelDelegate>)delegate;


@end

NS_ASSUME_NONNULL_END