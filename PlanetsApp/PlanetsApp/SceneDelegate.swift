//
//  SceneDelegate.swift
//  PlanetsApp
//
//  Created by Valentin Kalchev (Zuant) on 25/01/21.
//

import UIKit
import CoreData
import Planets

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    private var composer: PlanetsUIComposer?
    
    var window: UIWindow?
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        // Use this method to optionally configure and attach the UIWindow `window` to the provided UIWindowScene `scene`.
        // If using a storyboard, the `window` property will automatically be initialized and attached to the scene.
        // This delegate does not imply the connecting scene or session are new (see `application:configurationForConnectingSceneSession` instead).
        guard let _ = (scene as? UIWindowScene) else { return }
        
          
        let client = URLSessionHTTPClient()
        let remoteFeedLoader = RemoteFeedLoader(client: client)
         
        let storeURL = NSPersistentContainer.defaultDirectoryURL().appendingPathComponent("planets.sqlite")
        let store = try! CoreDataFeedStore(storeURL: storeURL)
        let localFeedLoader = LocalFeedLoader(store: store)
        
        let loader = RemoteWithLocalFallbackFeedLoader(primary:
                                                            FeedLoaderCacheDecorator(decoratee: remoteFeedLoader, cache: localFeedLoader),
                                                           fallback: localFeedLoader)
          
        window?.rootViewController = PlanetsUIComposer.viewController(with: loader)
        window?.makeKeyAndVisible()
    }
}
