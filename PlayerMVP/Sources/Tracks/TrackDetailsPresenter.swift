//
//  TrackDetailsPresenter.swift
//  PlayerMVP
//
//  Created by Emilien Stremsdoerfer on 11/4/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import Foundation

protocol TrackDetailsViewable: class {
    func didLoadTrack(_ track: Track)
}

class TrackDetailsPresenter: TrackDetailsPresentable {
    
    private let service: MusicService
    private let trackId: Int
    private weak var view: TrackDetailsViewable?
    
    init(trackId: Int, service: MusicService = MusicService()) {
        self.service = service
        self.trackId = trackId
    }
    
    func bindView(_ view: TrackDetailsViewable) {
        self.view = view
    }
    
    func loadTrack() {
        service.track(id: trackId).onSuccess { (track) in
            self.view?.didLoadTrack(track)
        }
    }
}
