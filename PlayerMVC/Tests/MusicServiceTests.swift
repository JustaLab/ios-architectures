//
//  MusicServiceTests.swift
//  MusicMVCTests
//
//  Created by Emilien Stremsdoerfer on 11/3/17.
//  Copyright © 2017 Justalab. All rights reserved.
//

import XCTest
@testable import PlayerMVC

let timeout: TimeInterval = 5

class MusicServiceTests: XCTestCase {
    
    var service: MusicService!
    
    override func setUp() {
        super.setUp()
        service = MusicService()
    }
    
    override func tearDown() {
        service = nil
        super.tearDown()
    }
    
    
    func testPlaylists() {
        let future = service.playlists()
        
        let expectation = self.expectation(description: "JSON request should succeed")
        
        future.onComplete { (result: Result<[Playlist]>) in
            expectation.fulfill()
            switch result {
            case .success(let playlists):
                XCTAssertTrue(playlists.count > 0)
            case .failure(let error):
                XCTFail(error.errorDescription!)
            }
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testPlaylistId() {
        let future = service.playlist(id: 1)
        
        let expectation = self.expectation(description: "JSON request should succeed")
        
        future.onComplete { (result: Result<Playlist>) in
            expectation.fulfill()
            switch result {
            case .success(let playlists):
                XCTAssertTrue(playlists.id == 1)
                XCTAssertTrue(playlists.tracks?.count ?? 0 > 0)
            case .failure(let error):
                XCTFail(error.errorDescription!)
            }
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
    
    func testSearchTracks() {
        let future = service.searchTrack(text: "w")
        
        let expectation = self.expectation(description: "JSON request should succeed")
        
        future.onComplete { (result: Result<[Track]>) in
            expectation.fulfill()
            switch result {
            case .success(let tracks):
                XCTAssertTrue(tracks.count > 0)
                XCTAssertTrue(tracks[0].name.lowercased().contains("w"))
            case .failure(let error):
                XCTFail(error.errorDescription!)
            }
        }
        waitForExpectations(timeout: timeout, handler: nil)
    }
}
