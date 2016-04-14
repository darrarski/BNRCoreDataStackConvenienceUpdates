//
//  Created by Dariusz Rybicki on 15/04/16.
//

import Foundation
import CoreData
import BNRCoreDataStack

@objc(Book)
class Book: NSManagedObject, CoreDataModelable {
    
    @NSManaged var title: String?
    @NSManaged var authors: Set<Author>
    
    var firstInitial: String? {
        willAccessValueForKey("title")
        defer { didAccessValueForKey("title") }
        guard let title = title,
            let first = title.characters.first else {
                return nil
        }
        let initial = String(first)
        
        return initial
    }
    
    // MARK: - CoreDataModelable
    
    static let entityName = "Book"
}
