//
//  TracksPresenter.swift
//  PlayerMVP
//
//  Created by Emilien Stremsdoerfer on 11/4/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import Foundation

protocol TracksViewable: class {
    func didLoadTracks(_ tracks: [Track])
}

class TracksPresenter: TracksPresentable {
    
    var tracks = [Track]()
    
    private let service: MusicService
    private weak var view: TracksViewable?
    
    init(service: MusicService = MusicService()) {
        self.service = service
    }
    
    func bindView(_ view: TracksViewable) {
        self.view = view
    }
    
    func loadTracks(searchText: String?) {
        if searchText == nil {
            service.tracks().onSuccess({ (tracks) in
                self.tracks = tracks
                self.view?.didLoadTracks(tracks)
            })
        } else {
            service.searchTrack(text: searchText!).onSuccess({ (tracks) in
                self.tracks = tracks
                self.view?.didLoadTracks(tracks)
            })
        }
    }
    
    func playNext(index: Int) {
        //NOT IMPLEMENTED
    }
    
    func playAfter(index: Int) {
        //NOT IMPLEMENTED
    }
}
