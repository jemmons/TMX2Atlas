@import Foundation;
@class MCMTileset, MCMLayer;

@interface MCMMap : NSObject
@property NSString *version;
@property NSString *orientation; //Only supports "orthoganal" at the moment.
@property NSUInteger width, height;
@property CGFloat tileWidth, tileHeight;
@property NSColor *backgroundColor; //Unused.
@property NSArray *tilesets;
@property NSArray *layers;

+(instancetype)mapWithAttributes:(NSDictionary *)att;
-(void)addTileset:(MCMTileset *)aTileset;
-(void)addLayer:(MCMLayer *)aLayer;
@end
