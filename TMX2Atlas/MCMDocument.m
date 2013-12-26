#import "MCMDocument.h"

#import "MCMTMXParser.h"
#import "MCMMap.h"
#import "MCMTileset.h"
#import "MCMLayer.h"
#import "MCMMainCellView.h"


static NSString * const kTilesetTable = @"TilesetTable";
static NSString * const kLayerTable = @"LayerTable";
static NSString * const kTilesetCell = @"TilesetCell";



@interface MCMDocument ()
@property MCMMap *map;
@end


@implementation MCMDocument
#pragma mark - INIT/SETUP
-(id)init{
  if((self = [super init])){
    //
  }
  return self;
}


+(BOOL)autosavesInPlace{
  return NO;
}


-(NSString *)windowNibName{
  return @"MCMDocument";
}


#pragma mark - DOCUMENT METHODS
-(BOOL)readFromURL:(NSURL *)url ofType:(NSString *)typeName error:(NSError *__autoreleasing *)outError{
  BOOL success = YES;
  
  MCMTMXParser *parser = [[MCMTMXParser alloc] initWithURL:url];
  [self setMap:[parser parse]];
  
  if([self map]){
    [[self titleLabel] setStringValue:[url lastPathComponent]];
    [[self detailLabel] setStringValue:@"something"];
  } else{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Could not parse TMX file.", nil), NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Unknown error occured.", nil), NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Try exporting the TMX again with approved settings.", nil)};
    *outError = [NSError errorWithDomain:@"TMX2AtlasDomain"
                                    code:-100
                                userInfo:userInfo];
    success = NO;
  }
  return success;
}


-(void)windowControllerDidLoadNib:(NSWindowController *)windowController{
  [[self titleLabel] setStringValue:[self displayName]];
  [[self detailLabel] setStringValue:@"something"];
}

#pragma mark - TABLE VIEW DATA SOURCE
-(NSInteger)numberOfRowsInTableView:(NSTableView *)tableView{
  NSInteger numberOfRows = 0;
  if([kTilesetTable isEqualToString:[tableView identifier]]){
    numberOfRows = [[[self map] tilesets] count];
  } else if([kLayerTable isEqualToString:[tableView identifier]]){
    
  }
  return numberOfRows;
}


#pragma mark - TABLE VIEW DELEGATE
-(NSView *)tableView:(NSTableView *)tableView viewForTableColumn:(NSTableColumn *)tableColumn row:(NSInteger)row{
  NSView *cell = nil;
  if([kTilesetTable isEqualToString:[tableView identifier]]){
    cell = [self tilesetCellForTable:tableView atIndex:row];
  } else if([kLayerTable isEqualToString:[tableView identifier]]){
  }
  return cell;
}


#pragma mark - UTILITY
-(NSView *)tilesetCellForTable:(NSTableView *)tableView atIndex:(NSInteger)anIndex{
  NSTableCellView *cell = [tableView makeViewWithIdentifier:kTilesetCell owner:self];
  MCMTileset *tileset = [[[self map] tilesets] objectAtIndex:anIndex];
  [[cell imageView] setImage:[tileset image]];
  [[cell textField] setStringValue:[tileset name]];
  return cell;
}

@end
