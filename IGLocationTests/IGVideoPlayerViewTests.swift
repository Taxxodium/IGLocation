//
//  IGVideoPlayerViewTests.swift
//  IGLocationTests
//
//  Created by Jesus De Meyer on 31/8/18.
//  Copyright © 2018 e dot studios. All rights reserved.
//

import XCTest
@testable import IGLocation

class IGVideoPlayerViewTests: XCTestCase {
    
    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }
    
    func testAutoplay() {
        let playerView = IGVideoPlayerView(frame: .zero)
        let containerView = UIView(frame: .zero)

        playerView.url = URL(string: "https://instagram.fcul1-1.fna.fbcdn.net/vp/dc5b543f4604ce6b22e6d67f1f3f9ef2/5B8B8AB5/t50.2886-16/39763708_1125629140923851_3933432015767994368_n.mp4")!

        playerView.attach(to: containerView)

        let exp = self.expectation(description: "video loading")

        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            exp.fulfill()
        }

        self.wait(for: [exp], timeout: 20)

        XCTAssert(playerView.player.timeControlStatus == .playing, "Player should be playing when in autoplay")
    }

    func testAutoplayDisabled() {
        let playerView = IGVideoPlayerView(frame: .zero)
        let containerView = UIView(frame: .zero)
        playerView.autoplay = false
        playerView.url = URL(string: "https://instagram.fcul1-1.fna.fbcdn.net/vp/dc5b543f4604ce6b22e6d67f1f3f9ef2/5B8B8AB5/t50.2886-16/39763708_1125629140923851_3933432015767994368_n.mp4")!

        playerView.attach(to: containerView)

        XCTAssertFalse(playerView.player.timeControlStatus == .playing, "Player should not be playing when autoplay is disabled")
    }
    
}
