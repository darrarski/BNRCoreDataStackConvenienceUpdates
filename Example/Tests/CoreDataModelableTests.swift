//
//  Created by Dariusz Rybicki on 15/04/16.
//

import XCTest

import CoreData
import BNRCoreDataStack
import BNRCoreDataStackConvenienceUpdates

class CoreDataModelableTests: XCTestCase {
    var stack: CoreDataStack!
    
    override func setUp() {
        super.setUp()
        
        weak var expectation = expectationWithDescription("callback")
        CoreDataStack.constructSQLiteStack(withModelName: "Sample", inBundle: unitTestBundle, withStoreURL: tempStoreURL) { result in
            switch result {
            case .Success(let stack):
                self.stack = stack
            case .Failure(let error):
                XCTFail("Error constructing stack: \(error)")
            }
            expectation?.fulfill()
        }
        
        waitForExpectationsWithTimeout(10, handler: nil)
    }
    
    override func tearDown() {
        removeTempDir()
        super.tearDown()
    }
    
    func testCreateNewObject() {
        let title = "Swift Programming: The Big Nerd Ranch Guide"
        let book = Book.createInContext(stack.mainQueueContext) {
            $0.title = title
        }
        XCTAssertEqual(book.title, title)
    }
    
    func testUpdateObject() {
        let iOSBook = Book(managedObjectContext: stack.mainQueueContext)
        iOSBook.title = "iOS Programming: The Big Nerd Ranch Guide"
        
        let swiftBook = Book(managedObjectContext: stack.mainQueueContext)
        swiftBook.title = "Swift Programming: The Big Nerd Ranch Guide"
        
        let warAndPeace = Book(managedObjectContext: stack.mainQueueContext)
        warAndPeace.title = "War and Peace"
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", "The Big Nerd Ranch Guide")
        
        do {
            let updatedBooks = try Book.updateInContext(stack.mainQueueContext, predicate: predicate) {
                $0.title = ($0.title ?? "") + " - UPDATED"
            }
            
            XCTAssertEqual(updatedBooks.count, 2)
            
            let updatedBooksTitles = updatedBooks.flatMap { $0.title }
            let updatedBooksTitlesExpectation = [
                "iOS Programming: The Big Nerd Ranch Guide - UPDATED",
                "Swift Programming: The Big Nerd Ranch Guide - UPDATED"
            ]
            XCTAssertEqual(updatedBooksTitles.sort(), updatedBooksTitlesExpectation.sort())
        } catch {
            failingOn(error)
        }
    }
    
    func testUpdateOrCreateNewObjectShouldCreate() {
        do {
            let createdBooks = try Book.updateOrCreateInContext(stack.mainQueueContext, predicate: nil) {
                $0.title = "iOS Programming: The Big Nerd Ranch Guide"
            }
            
            XCTAssertEqual(createdBooks.count, 1)
            XCTAssertEqual(createdBooks.first?.title, "iOS Programming: The Big Nerd Ranch Guide")
        } catch {
            failingOn(error)
        }
    }
    
    func testUpdateOrCreateNewObjectShouldUpdate() {
        let iOSBook = Book(managedObjectContext: stack.mainQueueContext)
        iOSBook.title = "iOS Programming: The Big Nerd Ranch Guide"
        
        let swiftBook = Book(managedObjectContext: stack.mainQueueContext)
        swiftBook.title = "Swift Programming: The Big Nerd Ranch Guide"
        
        let warAndPeace = Book(managedObjectContext: stack.mainQueueContext)
        warAndPeace.title = "War and Peace"
        
        let predicate = NSPredicate(format: "title CONTAINS[cd] %@", "The Big Nerd Ranch Guide")
        
        do {
            let updatedBooks = try Book.updateOrCreateInContext(stack.mainQueueContext, predicate: predicate) {
                $0.title = ($0.title ?? "") + " - UPDATED"
            }
            
            XCTAssertEqual(updatedBooks.count, 2)
            
            let updatedBooksTitles = updatedBooks.flatMap { $0.title }
            let updatedBooksTitlesExpectation = [
                "iOS Programming: The Big Nerd Ranch Guide - UPDATED",
                "Swift Programming: The Big Nerd Ranch Guide - UPDATED"
            ]
            XCTAssertEqual(updatedBooksTitles.sort(), updatedBooksTitlesExpectation.sort())
        } catch {
            failingOn(error)
        }
    }
    
    // MARK: - Helpers
    
    private var unitTestBundle: NSBundle {
        return NSBundle(forClass: self.dynamicType)
    }
    
    private func failingOn(error: ErrorType) {
        XCTFail("Failing with error: \(error) in: \(self)")
    }
    
    private lazy var tempStoreURL: NSURL? = {
        return self.tempStoreDirectory?.URLByAppendingPathComponent("testmodel.sqlite")
    }()
    
    private lazy var tempStoreDirectory: NSURL? = {
        let baseURL = NSURL.fileURLWithPath(NSTemporaryDirectory(), isDirectory: true)
        let tempDir = baseURL.URLByAppendingPathComponent("XXXXXX")
        do {
            try NSFileManager.defaultManager().createDirectoryAtURL(tempDir,
                                                                    withIntermediateDirectories: true,
                                                                    attributes: nil)
            return tempDir
        } catch {
            assertionFailure("\(error)")
        }
        return nil
    }()
    
    private func removeTempDir() {
        if let tempStoreDirectory = tempStoreDirectory {
            do {
                try NSFileManager.defaultManager().removeItemAtURL(tempStoreDirectory)
            } catch {
                assertionFailure("\(error)")
            }
        }
    }
}
