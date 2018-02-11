//
//  RealmConfig.swift
//  TreadsApp
//
//  Created by Alex on 2/10/18.
//  Copyright © 2018 Alex. All rights reserved.
//

import Foundation
import RealmSwift

class RealmConfig {
    
    static var runDataConfig: Realm.Configuration {
        let realmPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0].appendingPathComponent(REALM_RUN_CONFIG)
        
        let config = Realm.Configuration(
        
            fileURL: realmPath,
            schemaVersion: 0,
            migrationBlock: {migration, oldSchemeVersion in
                if oldSchemeVersion < 0 {
                    //Realm will automatically detect new properties
                }
            }
        )
        return config

    }
    
}
