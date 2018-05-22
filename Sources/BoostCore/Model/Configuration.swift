//
//  Configuration.swift
//  BoostCore
//
//  Created by Ondrej Rafaj on 11/04/2018.
//

import Foundation
import DbCore
import Vapor
import Fluent
import FluentPostgreSQL
import ApiCore


public typealias Configurations = [Configuration]


final public class Configuration: DbCoreModel {
    
    public struct Theme: PostgreSQLJSONType, Content {
        public let primaryColor: String
        public let primaryBackgroundColor: String
        public let primaryButtonColor: String
        public let primaryButtonBackgroundColor: String
        
        enum CodingKeys: String, CodingKey {
            case primaryColor = "primary_color"
            case primaryBackgroundColor = "primary_background_color"
            case primaryButtonColor = "primary_button_color"
            case primaryButtonBackgroundColor = "primary_button_background_color"
        }
    }
    
    public struct Apps: PostgreSQLJSONType, Content {
        public let ios: String?
        public let android: String?
    }
    
    public var id: DbCoreIdentifier?
    public var teamId: DbCoreIdentifier?
    public var theme: Theme
    public var apps: Apps?
    
    enum CodingKeys: String, CodingKey {
        case id
        case teamId = "team_id"
        case theme
        case apps
    }
    
    public init(id: DbCoreIdentifier? = nil, teamId: DbCoreIdentifier, theme: Theme, apps: Apps? = nil) {
        self.id = id
        self.teamId = teamId
        self.theme = theme
        self.apps = apps
    }
    
}

// MARK: - Relationships

extension Configuration {
    
    var team: Parent<Configuration, Team>? {
        return parent(\Configuration.teamId)
    }
    
}

// MARK: - Migrations

extension Configuration: Migration {
    
    public static func prepare(on connection: DbCoreConnection) -> Future<Void> {
        return Database.create(self, on: connection) { (schema) in
            try schema.field(for: \Configuration.id)
            try schema.field(for: \Configuration.teamId)
            schema.addField(type: PostgreSQLColumn(type: .jsonb), name: CodingKeys.theme.stringValue)
            schema.addField(type: PostgreSQLColumn(type: .jsonb), name: CodingKeys.apps.stringValue, isOptional: true)
        }
    }
    
    public static func revert(on connection: DbCoreConnection) -> Future<Void> {
        return Database.delete(Configuration.self, on: connection)
    }
    
}
