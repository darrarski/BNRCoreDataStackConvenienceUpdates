//
//  Created by Dariusz Rybicki on 15/04/16.
//

import Foundation
import CoreData
import BNRCoreDataStack

@objc(Author)
class Author: NSManagedObject, CoreDataModelable {
    
    @NSManaged var firstName: String?
    @NSManaged var lastName: String?
    @NSManaged var books: Set<Book>
    
    // MARK: - CoreDataModelable
    
    static let entityName = "Author"
}
