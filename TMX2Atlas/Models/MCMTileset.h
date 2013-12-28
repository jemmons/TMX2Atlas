@import Foundation;

FOUNDATION_EXPORT NSString * const TMXTilesetNameKey;
FOUNDATION_EXPORT NSString * const TMXTilesetFirstGIDKey;
FOUNDATION_EXPORT NSString * const TMXTilesetCountKey;
FOUNDATION_EXPORT NSString * const TMXTilesetTileWidthKey;
FOUNDATION_EXPORT NSString * const TMXTilesetTileHeightKey;

@interface MCMTileset : NSObject
@property NSString *name;
@property NSUInteger firstGID;
@property CGFloat tileWidth;
@property CGFloat tileHeight;
@property NSUInteger spacing; //Used to crop image into atlas. Not exported.
@property NSUInteger margin; //Used to crop image into atlas. Not exported.
@property NSImage *image; //Exported as atlas.

+(instancetype)tilesetWithAttributes:(NSDictionary *)att;
-(NSDictionary *)serialize;
@end
