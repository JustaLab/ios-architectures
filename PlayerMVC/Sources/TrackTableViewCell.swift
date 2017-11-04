//
//  TrackTableViewCell.swift
//  MusicMVC
//
//  Created by Emilien Stremsdoerfer on 11/4/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import UIKit
import SnapKit

class TrackTableViewCell: UITableViewCell {

    let coverImageView = AsyncImageView()
    let titleLabel = UILabel()
    
    private var longPressClosure:(()->Void)?
    
    override init(style: UITableViewCellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        self.contentView.addSubview(coverImageView)
        self.coverImageView.snp.makeConstraints({
            $0.top.left.bottom.equalToSuperview()
            $0.width.equalTo(self.coverImageView.snp.height)
        })
        
        self.contentView.addSubview(titleLabel)
        self.titleLabel.snp.makeConstraints({
            $0.top.bottom.right.equalToSuperview()
            $0.left.equalTo(self.coverImageView.snp.right).offset(10)
        })
        
        self.addGestureRecognizer(UILongPressGestureRecognizer(target: self, action: #selector(longPress)))
    }
    
    func configure(forTrack track: Track) {
        self.coverImageView.setImage(url: track.album?.cover)
        self.titleLabel.text = track.name
    }
    
    func onLongPress(_ closure: @escaping (() -> Void)) {
        self.longPressClosure = closure
    }
    
    @objc func longPress(){
        self.longPressClosure?()
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
