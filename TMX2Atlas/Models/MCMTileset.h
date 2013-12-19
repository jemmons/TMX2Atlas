@import Foundation;


@interface MCMTileset : NSObject
@property NSUInteger firstGID;
@property NSString *name;
@property CGFloat tileWidth;
@property CGFloat tileHeight;
@property NSUInteger spacing;
@property NSUInteger margin;
@property NSImage *image;

+(instancetype)tilesetWithAttributes:(NSDictionary *)att;
@end
