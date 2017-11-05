//
//  ViewController.swift
//  MusicMVC
//
//  Created by Emilien Stremsdoerfer on 11/3/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import UIKit
import SnapKit

class ViewController: UIViewController {

    private let presenter: ViewControllerPresenter
    private let tableView = UITableView(frame: .zero)
    
    init(presenter: ViewControllerPresenter = ViewControllerPresenter()) {
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
    }
}


extension ViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return presenter.rows.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        cell.textLabel?.text = presenter.rows[indexPath.row]
        return cell
    }
}


extension ViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.row == 0 {
            self.navigationController?.pushViewController(PlaylistsViewController(), animated: true)
        }
        else if indexPath.row == 1 {
            self.navigationController?.pushViewController(TracksViewController(), animated: true)
        }
        self.tableView.deselectRow(at: indexPath, animated: true)
    }
    
}
