//
//  IGMediaTests.swift
//  IGLocationTests
//
//  Created by Jesus De Meyer on 30/8/18.
//  Copyright © 2018 e dot studios. All rights reserved.
//

import XCTest
@testable import IGLocation

class IGMediaTests: XCTestCase {
    override func setUp() {
        super.setUp()
    }

    override func tearDown() {
        super.tearDown()
    }

    func testCreateMediaTypeFromString() {
        let videoType = IGMediaType(rawString: "video")

        XCTAssert(videoType == .video, "videoType should be .video")

        let imageType = IGMediaType(rawString: "image")

        XCTAssert(imageType == .image, "videoType should be .image")
    }
}
