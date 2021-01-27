//
//  CoreDataFeedStore.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import CoreData
 
public class CoreDataFeedStore: LocalFeedStore {
    private static let modelName = "Model"
    private static let model = NSManagedObjectModel.with(name: modelName, in: Bundle(for: CoreDataFeedStore.self))
    
    private let container: NSPersistentContainer
    private let context: NSManagedObjectContext
    
    enum StoreError: Error {
        case modelNotFound
        case failedToLoadPersistentContainer(Error)
    }
    
    public init(storeURL: URL) throws {
        guard let model = CoreDataFeedStore.model else {
            throw StoreError.modelNotFound
        }
        
        do {
            container = try NSPersistentContainer.load(name: CoreDataFeedStore.modelName, model: model, url: storeURL)
            context = container.newBackgroundContext()
        } catch {
            throw StoreError.failedToLoadPersistentContainer(error)
        }
    }
    
    
    public func insert(page: LocalFeedPage, with url: URL, completion: @escaping (InsertResult) -> Void) {
        perform { (context) in
            do {
                let cache = try ManagedCache.newUniqueInstance(with: url, in: context)
                cache.url = url
                cache.page = ManagedPage.page(from: page, in: context)
                
                try context.save()
                completion(.success(()))
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func deleteCacheFeed(for url: URL, completion: @escaping (DeleteResult) -> Void) {
        perform { (context) in
                do {
                    if let cache = try ManagedCache.find(with: url, in: context) {
                        context.delete(cache)
                        try context.save()
                    }
                    completion(.success(()))
                    
                } catch {
                    completion(.failure(error))
                }
        }
    }
    
    public func retrieve(with url: URL, completion: @escaping RetrievalCompletion) {
        perform { context in
            do {
                if let cache = try ManagedCache.find(with: url, in: context) {
                    completion(.success(cache.localPage))
                } else {
                    completion(.success(nil))
                }
            } catch {
                completion(.failure(error))
            }
        }
    }
    
    public func perform(_ action: @escaping (NSManagedObjectContext) -> Void) {
        let context = self.context
        context.perform { action(context) }
    }
}
