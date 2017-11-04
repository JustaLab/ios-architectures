//
//  PlaylistsViewController.swift
//  MusicMVC
//
//  Created by Emilien Stremsdoerfer on 11/3/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import UIKit

class PlaylistsViewController: UIViewController {

    private let tableView = UITableView(frame: .zero)
    private var playlists = [Playlist]()
    private let service: MusicService
    
    init(service: MusicService = MusicService()) {
        self.service = service
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ $0.edges.equalToSuperview() })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        //TODO check for a potential memory leak here?
        service.playlists().onSuccess { (playlists) in
            self.playlists = playlists
            self.tableView.reloadData()
        }
    }
}


extension PlaylistsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = playlists[indexPath.row].name
        return cell
    }
}


extension PlaylistsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(PlaylistDetailViewController(id: playlists[indexPath.row].id), animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
