//
// This file is subject to the terms and conditions defined in
// file 'LICENSE.md', which is part of this source code package.
//

#import "DummyAnnotation.h"

@implementation DummyAnnotation
- (BOOL)isEqual:(DummyAnnotation *)other {
    if (other == self)
        return YES;
    if (!other || ![other isKindOfClass:[self class]])
        return NO;
    if ( ![self.uniqueId isEqual: other.uniqueId])
        return NO;
    return YES;
}
@end
