//
//  AsyncImageView.swift
//  MusicMVC
//
//  Created by Emilien Stremsdoerfer on 11/4/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import UIKit

class AsyncImageView: UIImageView {
    
    private let activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: .gray)
    private var downloadTask: URLSessionDataTask?
    
    init() {
        super.init(frame: .zero)
        self.addSubview(activityIndicator)
        activityIndicator.snp.makeConstraints({ $0.center.equalToSuperview() })
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setImage(url: URL?) {
        guard let url = url else { return }
        
        activityIndicator.startAnimating()
        downloadTask = URLSession.shared.dataTask(with: url) { (data, _, _) in
            if let imageData = data {
                DispatchQueue.main.async {
                    self.activityIndicator.stopAnimating()
                    self.image = UIImage(data: imageData)
                }
            }
        }
        downloadTask?.resume()
    }
    
    func cancelLoading(){
        downloadTask?.cancel()
    }

}
