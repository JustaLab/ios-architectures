//
//  Service.swift
//  MusicMVC
//
//  Created by Emilien Stremsdoerfer on 11/3/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import Foundation
import Nikka

class MusicProvider:HTTPProvider {
    var baseURL = URL(string:"http://localhost:8080")!
}

extension Route {
    static let playlists = Route(path:"/playlists")
    static let playlist = {(id: Int) in Route(path: "/playlist/\(id)")}
    static let tracks = Route(path:"/tracks")
    static let searchTracks = {(query: String) in Route(path: "/tracks", params: ["search": query]) }
    static let addTrack = {(name: String, albumId: Int) in Route(path: "/tracks", method: .post, params: ["name": name, "album_id": albumId]) }
    static let addTrackToPlaylist = {(playlistId: Int, trackId: Int) in Route(path: "/playlists/\(playlistId)/tracks/\(trackId)", method: .put) }
    static let track = {(id: Int) in Route(path: "/tracks/\(id)")}
}

struct MusicService {
    
    let provider: MusicProvider
    
    init(provider: MusicProvider = MusicProvider()) {
        self.provider = provider
    }
    
    func playlists() -> Future<[Playlist]> {
        return provider.request(.playlists).responseObject()
    }
    
    func playlist(id: Int) -> Future<Playlist> {
        return provider.request(.playlist(id)).responseObject()
    }

    func searchTrack(text: String) -> Future<[Track]> {
        let escapedtext = text.addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)!
        return provider.request(.searchTracks(escapedtext)).responseObject()
    }
    
    func tracks() -> Future<[Track]> {
        return provider.request(.tracks).responseObject()
    }
    
    func track(id: Int) -> Future<Track> {
        return provider.request(.track(id)).responseObject()
    }
    
    func addTrack(name: String, albumId: Int) -> Future<Void> {
        return provider.request(.addTrack(name, albumId)).response()
    }
    
    func addTrack(id: Int, toPlaylist playlistId: Int) -> Future<Void> {
        return provider.request(.addTrackToPlaylist(id, playlistId)).response()
    }
}

extension Request {

    func responseObject<T: Decodable>() -> Future<T> {
        let future = Future<T>()
        self.downloadProgress({ (receivedSize, expectedSize) in
            future.fill(downloadProgress: (receivedSize, expectedSize))
        }).uploadProgress({ (bytesSent, totalBytes) in
            future.fill(uploadProgress: (bytesSent, totalBytes))
        }).response { (_, data, error) in
            guard error == nil else {
                future.fill(result: .failure(AppError.nikkaError))
                return
            }
            if let object = try? JSONDecoder().decode(T.self, from: data) {
                future.fill(result: .success(object))
            } else {
                future.fill(result: .failure(AppError.jsonError))
            }
        }
        return future
    }
    
    func response() -> Future<Void> {
        let future = Future<Void>()
        self.downloadProgress({ (receivedSize, expectedSize) in
            future.fill(downloadProgress: (receivedSize, expectedSize))
        }).uploadProgress({ (bytesSent, totalBytes) in
            future.fill(uploadProgress: (bytesSent, totalBytes))
        }).response { (_, data, error) in
            guard error == nil else {
                future.fill(result: .failure(AppError.nikkaError))
                return
            }
            future.fill(result: .success(()))
        }
        return future
    }
}
