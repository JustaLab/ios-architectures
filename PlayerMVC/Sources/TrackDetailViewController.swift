//
//  TrackDetailViewController.swift
//  MusicMVC
//
//  Created by Emilien Stremsdoerfer on 11/4/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import UIKit

class TrackDetailViewController: UIViewController {

    private let trackId: Int
    private let service: MusicService
    
    private let imageView = AsyncImageView()
    private let artistLabel = UILabel()
    private let albumLabel = UILabel()
    private let trackLabel = UILabel()
    
    init(trackId: Int, service: MusicService = MusicService()) {
        self.trackId = trackId
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .white
        
        self.view.addSubview(imageView)
        self.view.addSubview(artistLabel)
        self.view.addSubview(albumLabel)
        self.view.addSubview(trackLabel)
        
        imageView.snp.makeConstraints({
            $0.center.equalToSuperview()
            $0.width.height.equalTo(200)
        })
        
        artistLabel.textAlignment = .center
        artistLabel.font = UIFont.systemFont(ofSize: 16)
        artistLabel.snp.makeConstraints({
            $0.top.equalTo(imageView.snp.bottom).offset(10)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
        })
        
        albumLabel.textAlignment = .center
        albumLabel.font = UIFont.systemFont(ofSize: 16)
        albumLabel.snp.makeConstraints({
            $0.top.equalTo(artistLabel.snp.bottom).offset(10)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
        })
        
        trackLabel.textAlignment = .center
        trackLabel.font = UIFont.boldSystemFont(ofSize: 20)
        trackLabel.snp.makeConstraints ({
            $0.top.equalTo(albumLabel.snp.bottom).offset(10)
            $0.left.equalTo(20)
            $0.right.equalTo(-20)
        })

        service.track(id: trackId).onSuccess { (track) in
            self.title = track.name
            self.artistLabel.text = track.album?.artist?.name
            self.albumLabel.text = track.album?.name
            self.trackLabel.text = track.name
            
            self.imageView.setImage(url: track.album?.cover)
        }
    }
}
