//
//  TextureSequence.swift
//  SpriteAnimations
//
//  Created by bryn austin bellomy on 2014 Dec 27.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import class SpriteKit.SKTexture
import BrynSwift


//
// MARK: - struct TextureSequence
//

public struct TextureSequence
{
    private var textures : [SKTexture]
    public  var count : Int { return textures.count }

    // MARK: - Lifecycle

    public init(textures t:[SKTexture]) {
        textures = t
    }

    // MARK: - Accessors

    public func textureAtIndex(index:Int) -> SKTexture? {
        if textures.startIndex <= index && index <= textures.endIndex.predecessor() {
            return textures[index]
        }
        return nil
    }

    public func toArray() -> [SKTexture] {
        return textures
    }
}



//
// MARK: - struct TextureSequence.Builder
//

public extension TextureSequence
{
    public struct Builder
    {
        public typealias BuiltType = TextureSequence

        private var textures = [Int : SKTexture]()

        public init() {}
        public init(textures t: [Int: SKTexture]) { textures = t }

        public mutating func setTexture(s:SKTexture, atIndex index:Int) {
            textures[index] = s
        }

        public func build() -> TextureSequence {
            let sortedTextures = Array(textures.keys) |> sorted |> map_filter { self.textures[$0] }
            return TextureSequence(textures:sortedTextures)
        }
    }
}



