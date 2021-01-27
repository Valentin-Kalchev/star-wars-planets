//
//  ManagedCache.swift
//  Planets
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import CoreData

extension ManagedPage {
    var localFeed: [LocalFeedPlanet] {
        return planets?.compactMap { ($0 as? ManagedFeedPlanet)?.local } ?? []
    }
    
    static func page(from localPage: LocalFeedPage, in context: NSManagedObjectContext) -> ManagedPage {
        let managedPage = ManagedPage(context: context)
        managedPage.next = localPage.next
        managedPage.previous = localPage.previous
        managedPage.planets = ManagedFeedPlanet.planets(from: localPage.planets, in: context)
        return managedPage
    }
}

extension ManagedCache {
    var localPage: LocalFeedPage {
        return LocalFeedPage(next: page!.next, previous: page!.previous, planets: page!.planets?.array.map { ($0 as! ManagedFeedPlanet).local } ?? [])
    }
    
    static func find(with url: URL, in context: NSManagedObjectContext) throws -> ManagedCache? {
        let request = NSFetchRequest<ManagedCache>(entityName: entity().name!)
        request.returnsObjectsAsFaults = false
        request.predicate = NSPredicate(format: "url == %@", url as CVarArg)
        return try context.fetch(request).first
    }
    
    static func newUniqueInstance(with url: URL, in context: NSManagedObjectContext) throws -> ManagedCache {
        try find(with: url, in: context).map(context.delete)
        return ManagedCache(context: context)
    }
}
