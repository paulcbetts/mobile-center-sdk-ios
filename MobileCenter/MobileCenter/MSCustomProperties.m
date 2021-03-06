#import "MSCustomProperties.h"
#import "MSCustomPropertiesPrivate.h"
#import "MSMobileCenterInternal.h"

static NSString *const kKeyPattern = @"^[a-zA-Z][a-zA-Z0-9]*$";
static const int maxPropertiesCount = 60;
static const int maxPropertyKeyLength = 128;
static const int maxPropertyValueLength = 128;

@implementation MSCustomProperties

@synthesize properties = _properties;

- (instancetype)init {
  if ((self = [super init])) {
    _properties = [NSMutableDictionary new];
  }
  return self;
}

- (instancetype)setString:(NSString *)value forKey:(NSString *)key {
  return [self setObject:value forKey:key];
}

- (instancetype)setNumber:(NSNumber *)value forKey:(NSString *)key {
  return [self setObject:value forKey:key];
}

- (instancetype)setBool:(BOOL)value forKey:(NSString *)key {
  return [self setObject:[NSNumber numberWithBool:value] forKey:key];
}

- (instancetype)setDate:(NSDate *)value forKey:(NSString *)key {
  return [self setObject:value forKey:key];
}

- (instancetype)setObject:(NSObject *)value forKey:(NSString *)key {
  if ([self isValidKey:key] && [self isValidValue:value]) {
    [self.properties setObject:value forKey:key];
  }
  return self;
}

- (instancetype)clearPropertyForKey:(NSString *)key {
  if ([self isValidKey:key]) {
    [self.properties setObject:[NSNull null] forKey:key];
  }
  return self;
}

- (BOOL) isValidKey:(NSString *)key {
  static NSRegularExpression *regex = nil;
  if (!regex) {
    NSError *error = nil;
    regex = [NSRegularExpression regularExpressionWithPattern:kKeyPattern options:(NSRegularExpressionOptions)0 error:&error];
    if (!regex) {
      MSLogError([MSMobileCenter logTag], @"Couldn't create regular expression with pattern\"%@\": %@", kKeyPattern, error.localizedDescription);
      return NO;
    }
  }
  if (!key || ![regex matchesInString:key options:(NSMatchingOptions)0 range:NSMakeRange(0, key.length)].count) {
    MSLogError([MSMobileCenter logTag], @"Custom property \"%@\" must match \"%@\"", key, kKeyPattern);
    return NO;
  }
  if (key.length > maxPropertyKeyLength) {
    MSLogError([MSMobileCenter logTag], @"Custom property \"%@\" length cannot be longer than \"%d\" characters.", key, maxPropertyKeyLength);
    return NO;
  }
  if ([self.properties objectForKey:key]) {
    MSLogWarning([MSMobileCenter logTag], @"Custom property \"%@\" is already set or cleared and will be overridden.", key);
  } else if ([self properties].count >= maxPropertiesCount) {
    MSLogError([MSMobileCenter logTag], @"Custom properties cannot contain more than \"%d\" items.", maxPropertiesCount);
    return NO;
  }
  return YES;
}

- (BOOL) isValidValue:(NSObject *)value {
  if (value) {
    if ([value isKindOfClass:[NSString class]]) {
      NSString *stringValue = (NSString *) value;
      if (stringValue.length > maxPropertyValueLength) {
        MSLogError([MSMobileCenter logTag], @"Custom property value length cannot be longer than \"%d\" characters.", maxPropertyValueLength);
        return NO;
      }
    }
  } else {
    MSLogError([MSMobileCenter logTag], @"Custom property value cannot be null, did you mean to call clear?");
    return NO;
  }
  return YES;
}
@end
