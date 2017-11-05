//
//  TracksViewController.swift
//  MusicMVC
//
//  Created by Emilien Stremsdoerfer on 11/4/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import UIKit

protocol TracksPresentable {
    func bindView(_ view: TracksViewable)
    func loadTracks(searchText: String?)
    func playAfter(index: Int)
    func playNext(index: Int)
    var tracks:[Track] { get }
}

class TracksViewController: UIViewController {

    private let presenter: TracksPresentable
    private let tableView = UITableView(frame: .zero)
    private let refreshControl = UIRefreshControl()
    private let searchController = UISearchController(searchResultsController: nil)
    
    init(presenter: TracksPresentable = TracksPresenter()) {
        self.presenter = presenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Tracks"
        self.view.backgroundColor = .white
        self.tableView.backgroundColor = .white

        self.view.addSubview(tableView)
        tableView.snp.makeConstraints({ $0.edges.equalToSuperview() })
        tableView.delegate = self
        tableView.dataSource = self
        tableView.register(TrackTableViewCell.self, forCellReuseIdentifier: "TrackCell")
        tableView.rowHeight = 50
        tableView.tableHeaderView = searchController.searchBar
        
        refreshControl.addTarget(self, action: #selector(refreshView), for: .valueChanged)
        refreshControl.backgroundColor = .white
        tableView.addSubview(refreshControl)
        
        searchController.searchBar.delegate = self
        searchController.searchBar.barTintColor = .white
        searchController.searchBar.searchBarStyle = .minimal
        searchController.hidesNavigationBarDuringPresentation = false
        searchController.dimsBackgroundDuringPresentation = false
        definesPresentationContext = true
        
        presenter.bindView(self)
        presenter.loadTracks(searchText: nil)
    }
    
    @objc func refreshView() {
        presenter.loadTracks(searchText: nil)
    }
}

extension TracksViewController: TracksViewable {
    func didLoadTracks(_ tracks: [Track]) {
        self.tableView.reloadData()
        DispatchQueue.main.asyncAfter(deadline: .now() + 0.5, execute: {
            self.refreshControl.endRefreshing()
        })
    }
}

extension TracksViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.tracks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let track = presenter.tracks[indexPath.row]
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "TrackCell", for: indexPath) as! TrackTableViewCell
        cell.coverImageView.setImage(url: track.album?.cover)
        cell.titleLabel.text = track.name
        cell.onLongPress {
            let sheet = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)
            sheet.addAction(UIAlertAction(title: "Play Next", style: .default, handler: { _ in
                self.presenter.playNext(index: indexPath.row)
            }))
            sheet.addAction(UIAlertAction(title: "Play After", style: .default, handler: { _ in
                self.presenter.playAfter(index: indexPath.row)
            }))
            sheet.addAction(UIAlertAction(title: "Cancel", style: .cancel, handler: nil))
            self.present(sheet, animated: true, completion: nil)
        }
        return cell
    }
}


extension TracksViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let trackId = presenter.tracks[indexPath.row].id
        self.navigationController?.pushViewController(TrackDetailViewController(trackId: trackId), animated: true)
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
    func tableView(_ tableView: UITableView, didEndDisplaying cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let cell = cell as? TrackTableViewCell {
            cell.coverImageView.cancelLoading()
        }
    }
}


extension TracksViewController: UISearchBarDelegate {
    
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        presenter.loadTracks(searchText: searchText)
    }
    
}
