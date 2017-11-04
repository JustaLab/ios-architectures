//
//  AppError.swift
//  MusicMVC
//
//  Created by Emilien Stremsdoerfer on 11/3/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import Foundation

struct AppError: LocalizedError, Equatable {
    let identifier:String
    
    var errorDescription: String? {
        return "App.Error.\(identifier)"
    }
    
    init(identifier:String) {
        self.identifier = identifier
    }
    
    static func ==(lhs: AppError, rhs: AppError) -> Bool {
        return lhs.identifier == rhs.identifier
    }
}

extension AppError {
    
    static let nikkaError = AppError(identifier: "NikkaError")
    static let jsonError = AppError(identifier: "JSONError")

}
