#import "MCMTileset.h"

struct GridSize {
  NSUInteger width;
  NSUInteger height;
};
typedef struct GridSize GridSize;


NSString * const TMXTilesetNameKey = @"TMXTilesetName";
NSString * const TMXTilesetFirstGIDKey = @"TMXTilesetFirstGID";
NSString * const TMXTilesetCountKey = @"TMXTilesetCount";
NSString * const TMXTilesetTileWidthKey = @"TMXTilesetTileWidth";
NSString * const TMXTilesetTileHeightKey = @"TMXTilesetTileHeight";

@implementation MCMTileset
#pragma mark - INIT/SETUP
+(instancetype)tilesetWithAttributes:(NSDictionary *)att{
  NSParameterAssert(att[@"firstgid"] && att[@"tilewidth"] && att[@"tileheight"]);
  NSParameterAssert(nil == att[@"source"]);
  
  MCMTileset *tileset = [MCMTileset new];
  [tileset setName:att[@"name"]];
  [tileset setFirstGID:[att[@"firstgid"] integerValue]];
  [tileset setTileWidth:[att[@"tilewidth"] floatValue]];
  [tileset setTileHeight:[att[@"tileheight"] floatValue]];
  [tileset setSpacing:[att[@"spacing"] integerValue]];
  [tileset setMargin:[att[@"margin"] integerValue]];
  return tileset;
}


#pragma mark - ACCESSORS
-(NSString *)description{
  return [NSString stringWithFormat:@"%@: %lu", [self name], (unsigned long)[self firstGID]];
}


-(NSUInteger)tileCount{
  GridSize grid = [self tileGridSize];
  return grid.height * grid.width;
}


-(NSDictionary *)images{
  NSMutableDictionary *images = [NSMutableDictionary dictionaryWithCapacity:[self tileCount]];
  [self forEachTileRect:^(int i, CGRect rect) {
    NSString *name = [NSString stringWithFormat:@"%lu", [self firstGID] + i];
    //Have to drop out to Core Graphics as the only reliable way to process pixel coordinates in a mix of retina and non-retina outputs.
    CGImageRef original = [[self image] CGImageForProposedRect:NULL context:nil hints:nil];
    CGImageRef cropped = CGImageCreateWithImageInRect(original, rect);
    images[name] = [[NSImage alloc] initWithCGImage:cropped size:rect.size];
    CGImageRelease(cropped);
  }];
  return images;
}


#pragma mark - ACTIONS
-(NSDictionary *)serialize{
  return @{TMXTilesetNameKey: [self name],
           TMXTilesetFirstGIDKey: @([self firstGID]),
           TMXTilesetCountKey: @([self tileCount]),
           TMXTilesetTileWidthKey: @([self tileWidth]),
           TMXTilesetTileHeightKey: @([self tileHeight])};
}


#pragma mark - UTILITY
-(GridSize)tileGridSize{
  GridSize gridSize;
  CGSize size = [[self image] size];
  gridSize.width = size.width / [self tileWidth];
  gridSize.height = size.height / [self tileHeight];
  return gridSize;
}


-(void)forEachTileRect:(void (^)(int i, CGRect rect))block{
  GridSize grid = [self tileGridSize];
  int i=0;
  for(int h=0; h<grid.height; h++){
    for(int w=0; w<grid.width; w++){
      CGRect tileRect = CGRectMake(w*[self tileWidth], h*[self tileHeight], [self tileWidth], [self tileHeight]);
      block(i++, tileRect);
    }
  }
}
@end
