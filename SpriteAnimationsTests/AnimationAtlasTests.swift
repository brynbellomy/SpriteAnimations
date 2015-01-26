//
//  AnimationAtlasTests.swift
//  SpriteAnimations
//
//  Created by bryn austin bellomy on 2015 Jan 1.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Cocoa
import XCTest
import SpriteKit
import SpriteAnimations


enum Animation: String, IAnimationType
{
    case WalkingUp = "walking-up"
    case WalkingDown = "walking-down"
    case WalkingLeft = "walking-left"
    case WalkingRight = "walking-right"

    case NonexistentAnimation = "xyzzy"

    static let defaultValue: Animation = .WalkingDown
    var animationFilenameComponent: String { return rawValue }
    init?(animationFilenameComponent:String) { self.init(rawValue:animationFilenameComponent) }
    var description: String { return "Animation(\(rawValue))" }
}




class AnimationAtlasTests: XCTestCase
{
    typealias Keypath = AnimationAtlas<Animation>.Keypath

    var atlas: AnimationAtlas<Animation>?

    override func setUp()
    {
        super.setUp()

        let textureAtlas = buildTextureAtlas(bundleClass:self.dynamicType)

        var builder = AnimationAtlasBuilder<Animation>()
        builder.useTexturesFromAtlas(textureAtlas!)

        let maybeAtlas = builder.build()

        atlas = maybeAtlas.value
        XCTAssert(atlas != nil, "Could not build texture atlas from test bundle.")
    }


    func testBuilder()
    {
        let textureAtlas = buildTextureAtlas(bundleClass:self.dynamicType)
        XCTAssert(textureAtlas != nil)
        XCTAssert(textureAtlas!.textureNames.count > 0)

        var builder = AnimationAtlasBuilder<Animation>()
        builder.useTexturesFromAtlas(textureAtlas!)

        let maybeAtlas = builder.build()
        XCTAssertTrue(maybeAtlas.isSuccess)
    }



    func testHasAnimation()
    {
        XCTAssertTrue(atlas!.hasAnimation(.WalkingDown))
        XCTAssertFalse(atlas!.hasAnimation(.NonexistentAnimation))
    }



    func testTexturesForAnimation()
    {
        let textures = atlas!.texturesForAnimation(.WalkingDown)
        XCTAssert(textures != nil)
        XCTAssertEqual(textures!.count, 4)
    }



    func testAllKeypathsProperty()
    {
        let allKeypaths = atlas!.allKeypaths

        func assertContains(a:Animation, i:Int) {
            let keypath = Keypath(animation:a, frameIndex:i)
            XCTAssertTrue(contains(allKeypaths, keypath), "Does not contain texture \(keypath.textureName)")
        }

        for anim in [Animation.WalkingDown, .WalkingUp, .WalkingLeft, .WalkingRight] {
            for i in 0 ... 3 {
                assertContains(anim, i)
            }
        }

    }
}




