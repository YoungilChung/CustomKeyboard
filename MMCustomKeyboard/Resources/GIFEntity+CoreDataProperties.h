//
//  GIFEntity+CoreDataProperties.h
//  
//
//  Created by Tom Atterton on 15/03/16.
//
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

#import "GIFEntity.h"

NS_ASSUME_NONNULL_BEGIN

@interface GIFEntity (CoreDataProperties)

@property (nullable, nonatomic, retain) NSString *gifCategory;
@property (nullable, nonatomic, retain) NSString *gifURL;

@end

NS_ASSUME_NONNULL_END
