//
//  PlaylistDetailsPresenter.swift
//  PlayerMVP
//
//  Created by Emilien Stremsdoerfer on 11/4/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import Foundation

protocol PlaylistDetailsViewable: class {
    func didUpdatePlaylist(_ playlist: Playlist)
}

class PlaylistDetailsPresenter: PlaylistDetailsPresentable {
    
    var playlist:Playlist?
    private let playlistId: Int
    private weak var view: PlaylistDetailsViewable?
    private let service: MusicService
    
    init(playlistId: Int, service: MusicService = MusicService()) {
        self.service = service
        self.playlistId = playlistId
    }
    
    func bindView(_ view: PlaylistDetailsViewable) {
        self.view = view
    }
    
    func refreshPlaylist() {
        service.playlist(id: playlistId).onSuccess { (playlist) in
            self.playlist = playlist
            self.view?.didUpdatePlaylist(playlist)
        }
    }
}
