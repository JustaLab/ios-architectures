//
//  PlaylistsViewController.swift
//  MusicMVC
//
//  Created by Emilien Stremsdoerfer on 11/3/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import UIKit

protocol PlaylistsPresentable {
    func bindView(_ view: PlaylistsViewable)
    func refreshPlaylists()
    var title: String { get }
    var playlists: [Playlist] { get }
}

class PlaylistsViewController: UIViewController {

    private let presenter: PlaylistsPresentable
    private let tableView = UITableView(frame: .zero)
    
    init(presenter: PlaylistsPresentable = PlaylistsPresenter()) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = presenter.title
        
        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ $0.edges.equalToSuperview() })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: "Cell")

        presenter.bindView(self)
        presenter.refreshPlaylists()
    }
}

extension PlaylistsViewController: PlaylistsViewable {
    
    func didUpdatePlaylists(){
        self.tableView.reloadData()
    }
}


extension PlaylistsViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.playlists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = presenter.playlists[indexPath.row].name
        return cell
    }
}


extension PlaylistsViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.navigationController?.pushViewController(PlaylistDetailViewController(id: presenter.playlists[indexPath.row].id), animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
