//
//  Track.swift
//  MusicMVC
//
//  Created by Emilien Stremsdoerfer on 11/3/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import Foundation

struct Track: Decodable {
    let id: Int
    let name: String
    let album: Album?
}
