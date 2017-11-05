//
//  Result.swift
//  MusicMVC
//
//  Created by Emilien Stremsdoerfer on 11/3/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import Foundation

enum Result<Value> {
    case success(Value)
    case failure(LocalizedError)
    
    var value:Value? {
        switch self {
        case .success(let v):
            return v
        default:
            return nil
        }
    }
    var error:LocalizedError?{
        switch self {
        case .failure(let err):
            return err
        default:
            return nil
        }
    }
}
