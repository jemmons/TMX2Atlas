#import "MCMDocument.h"

#import "MCMTMXParser.h"
#import "MCMMap.h"


@interface MCMDocument ()
@property MCMMap *map;
@end


@implementation MCMDocument
#pragma mark - INIT/SETUP
-(id)init{
  self = [super init];
  if (self) {
    // Add your subclass-specific initialization here.
  }
  return self;
}


-(NSString *)windowNibName{
  // Override returning the nib file name of the document
  // If you need to use a subclass of NSWindowController or if your document supports multiple NSWindowControllers, you should remove this method and override -makeWindowControllers instead.
  return @"MCMDocument";
}


-(void)windowControllerDidLoadNib:(NSWindowController *)aController{
  [super windowControllerDidLoadNib:aController];
  // Add any code here that needs to be executed once the windowController has loaded the document's window.
}


+(BOOL)autosavesInPlace{
  return NO;
}


-(NSData *)dataOfType:(NSString *)typeName error:(NSError **)outError{
  // Insert code here to write your document to data of the specified type. If outError != NULL, ensure that you create and set an appropriate error when returning nil.
  // You can also choose to override -fileWrapperOfType:error:, -writeToURL:ofType:error:, or -writeToURL:ofType:forSaveOperation:originalContentsURL:error: instead.
  NSException *exception = [NSException exceptionWithName:@"UnimplementedMethod" reason:[NSString stringWithFormat:@"%@ is unimplemented", NSStringFromSelector(_cmd)] userInfo:nil];
  @throw exception;
  return nil;
}


-(BOOL)readFromData:(NSData *)data ofType:(NSString *)typeName error:(NSError **)outError{
  BOOL success = YES;

  MCMTMXParser *parser = [[MCMTMXParser alloc] initWithData:data];
  [self setMap:[parser parse]];
  
  if([self map]){
    NSLog(@"map: %@", [self map]);
  } else{
    NSDictionary *userInfo = @{NSLocalizedDescriptionKey : NSLocalizedString(@"Could not parse TMX file.", nil), NSLocalizedFailureReasonErrorKey : NSLocalizedString(@"Unknown error occured.", nil), NSLocalizedRecoverySuggestionErrorKey : NSLocalizedString(@"Try exporting the TMX again with approved settings.", nil)};
    *outError = [NSError errorWithDomain:@"TMX2AtlasDomain"
                                         code:-100
                                     userInfo:userInfo];
    success = NO;
  }
  return success;
}


@end
