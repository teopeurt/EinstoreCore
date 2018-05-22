//
//  AppPlist.swift
//  ApiCore
//
//  Created by Ondrej Rafaj on 22/02/2018.
//

import Foundation
import Vapor
import ErrorsCore


/// Applications Info.plist data struct
public struct AppPlist: Codable {
    
    public struct Item: Codable {
        
        public struct Asset: Codable {
            
            let kind: String = "software-package"
            let url: String
            
            public init(app: App, request req: Request) throws {
                let serverUrl = req.serverURL()
                self.url = serverUrl.appendingPathComponent("app.boost").absoluteString
            }
            
        }
        
        public struct Metadata: Codable {
            
            let bundleIdentifier: String
            let bundleVersion: String
            let kind: String = "software"
            let title: String
            
            enum CodingKeys: String, CodingKey {
                case bundleIdentifier = "bundle-identifier"
                case bundleVersion = "bundle-version"
                case kind
                case title
            }
            
            public init(app: App) {
                self.bundleIdentifier = app.identifier
                self.bundleVersion = app.version
                self.title = app.name
            }
            
        }
        
        let assets: [Asset]
        let metadata: Metadata
        
        public init(app: App, request req: Request) throws {
            self.assets = [
                try Asset(app: app, request: req)
            ]
            self.metadata = Metadata(app: app)
        }
        
    }
    
    let items: [Item]
    
    public init(app: App, request req: Request) throws {
        self.items = [
            try Item(app: app, request: req)
        ]
    }
    
}
