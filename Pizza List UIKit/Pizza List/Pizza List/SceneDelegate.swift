//
//  SceneDelegate.swift
//
//  Created by Gianluca Posca
//  Copyright © Gianluca Posca. All rights reserved.
//

import UIKit

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?
    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
                
        guard let _ = (scene as? UIWindowScene) else { return }
    }
    
    /// # MODIFICA TODAY
    func scene(_ scene: UIScene, openURLContexts URLContexts: Set<UIOpenURLContext>) {
        
        guard let urlo = URLContexts.first else { return }

        /// lavoriamo l'url per estrarre il valore passato alla query
        if let urlComponents = URLComponents(url: urlo.url, resolvingAgainstBaseURL: false) {
            if let queryItems = urlComponents.queryItems {
                for queryItem in queryItems {
                    if queryItem.name == "q" {
                        if let value = queryItem.value {
                            ///ok abbiamo il valore che è l'indice della pizza
                            
                            /// accediamo al navigation che sta alla radice dell'App
                            let navController = self.window!.rootViewController as! UINavigationController
                            
                            /// controlliamo se il controller visibile è MasterViewController
                            if let controller = navController.topViewController as? ListController {
                                /// invochiamo il metodo appositamente preparato per questo e gli passiamo l'indice della pizza
                                controller.mostraDettaglioConPizzaIndex(Int(value))
                                
                                /// se il controller visibile NON è ListController allora controlliamo che sia visibile DetailViewController
                            } else if let dettaglioController = navController.visibleViewController as? DetailController {
                                /// invochiamo il metodo appositamente preparato per questo e gli passiamo l'indice della pizza
                                dettaglioController.aggiornaInterfacciaConIndex(Int(value))
                            }
                            
                            /// fermiamo il ciclo for
                            break
                        }
                    }
                }
            }
        }
    }

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not neccessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

