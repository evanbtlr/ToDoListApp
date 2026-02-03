//
//  DebugUtils.swift
//  ToDoListApp
//
//  Created by Evan Brother on 03.02.2026.
//

#if DEBUG

import Foundation

struct DebugUtils {
    private init() {}
    
    static func printFirstLaunchStatus() {
        let hasLoaded = UserDefaults.standard.bool(forKey: Constants.hasLoadedInitialData)
            print(hasLoaded ? "Already loaded initial data" : "First launch, will load from API")
        }
        
        static func resetFirstLaunch() {
            UserDefaults.standard.removeObject(forKey: Constants.hasLoadedInitialData)
            print("Reset first launch flag")
        }
}

#endif
