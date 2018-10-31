//
//  String+Tools.swift
//  BoostCore
//
//  Created by Ondrej Rafaj on 31/10/2018.
//

import Foundation


extension String {
    
    public func encodeURLforUseAsQuery() -> String {
        return addingPercentEncoding(withAllowedCharacters: CharacterSet.init(charactersIn: "?&").inverted) ?? "badUrl"
    }
    
}
