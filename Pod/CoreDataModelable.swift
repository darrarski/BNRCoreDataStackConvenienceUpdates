//
//  Created by Dariusz Rybicki on 15/04/16.
//

import BNRCoreDataStack

extension CoreDataModelable where Self: NSManagedObject {
    
    // MARK: - Creating Objects
    
    /**
     Creates a new instance of the Entity within the specified `NSManagedObjectContext` and configures it using provided closure.
     
     - parameter context: `NSManagedObjectContext` to create object within.
     - parameter configure: A closure that configures new entity.
     
     returns: `[Self]`: The array of updated entities.
     */
    static public func createInContext(context: NSManagedObjectContext, @noescape configure: Self -> ()) -> Self {
        let entity = self.init(managedObjectContext: context)
        configure(entity)
        return entity
    }
    
    // MARK: - Updating Objects
    
    /**
     Updates Entities that matches the optional predicate within the specified `NSManagedObjectContext` using provided closure.
     
     - parameter context: `NSManagedObjectContext` to update objects within.
     - parameter predicate: An optional `NSPredicate` for filtering.
     - parameter configure: A closure that updates each of the entities.
     
     returns: `[Self]`: The array of updated entities.
     */
    static public func updateInContext(context: NSManagedObjectContext, predicate: NSPredicate?, @noescape configure: Self -> ()) throws -> [Self] {
        return try allInContext(context, predicate: predicate).map {
            configure($0)
            return $0
        }
    }
    
    /**
     Updates Entities that matches the optional predicate or (if there are no such Entities) creates a new Entity and configures it using provided closure.
     
     - parameter context: `NSManagedObjectContext` to update or create objects within.
     - parameter predicate: An optional `NSPredicate` for filtering.
     - parameter configure: A closure that updates existing entities or configures new entity.
     
     returns: `[Self]`: The array of updated entities or array with created entity.
     */
    static public func updateOrCreateInContext(context: NSManagedObjectContext, predicate: NSPredicate?, @noescape configure: Self -> ()) throws -> [Self] {
        let updatedEntities = try updateInContext(context, predicate: predicate, configure: configure)
        guard updatedEntities.count == 0 else { return updatedEntities }
        let insertedEntity = createInContext(context, configure: configure)
        return [insertedEntity]
    }
}