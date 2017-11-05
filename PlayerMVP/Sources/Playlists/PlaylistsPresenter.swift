//
//  PlaylistsPresenter.swift
//  PlayerMVP
//
//  Created by Emilien Stremsdoerfer on 11/4/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import Foundation

protocol PlaylistsViewable: class {
    func didUpdatePlaylists()
}

class PlaylistsPresenter: PlaylistsPresentable {
    
    let title = "Playlists"
    var playlists = [Playlist]()

    private let service: MusicService
    private weak var view: PlaylistsViewable?
    
    init(service: MusicService = MusicService()) {
        self.service = service
    }
    
    func bindView(_ view: PlaylistsViewable){
        self.view = view
    }
    
    func refreshPlaylists(){
        service.playlists().onSuccess { (playlists) in
            self.playlists = playlists
            self.view?.didUpdatePlaylists()
        }
    }
}
