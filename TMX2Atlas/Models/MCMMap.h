@import Foundation;


@interface MCMMap : NSObject
@property NSString *version;
@property NSString *orientation; //Only supports "orthoganal" at the moment.
@property NSUInteger width, height;
@property CGFloat tileWidth, tileHeight;
@property NSColor *backgroundColor; //Unused.
@end
