//
//  TextureSequence.swift
//  SpriteAnimations
//
//  Created by bryn austin bellomy on 2014 Dec 27.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import class SpriteKit.SKTexture
import Funky


//
// MARK: - struct TextureSequence
//

public struct TextureSequence: Printable, DebugPrintable
{
    public typealias Builder = TextureSequenceBuilder

    private var textures: [SKTexture]
    public  var count: Int { return textures.count }

    // MARK: - Lifecycle

    public init(textures t:[SKTexture]) {
        textures = Array(t)
    }

    // MARK: - Accessors

    public func textureAtIndex(index:Int) -> SKTexture? {
        if textures.startIndex ..< textures.endIndex ~= index {
            let texture = textures[index]
            return texture
        }
        return nil
    }

    public func toArray() -> [SKTexture] {
        return Array(textures)
    }

    public var description: String {
        let contents = textures.description.stringByReplacingOccurrencesOfString(",", withString: ",\n\t")
        return "<TextureSequence: count = \(textures.count), contents = [\n\t\(contents)\n]>"
    }

    public var debugDescription: String { return description }
}



//
// MARK: - struct TextureSequence.Builder
//

public extension TextureSequence
{
}


public struct TextureSequenceBuilder
{
    public typealias BuiltType = TextureSequence

    private var textures = [Int: SKTexture]()

    public init() {}
    public init(textures t: [Int: SKTexture]) { textures = t }

    public mutating func setTexture(s:SKTexture, atIndex index:Int) {
        textures[index] = s
    }

    public func build() -> TextureSequence {
        return Array(textures.keys) |> sorted
                                    |> mapFilter { self.textures[$0] }
                                    |> { TextureSequence(textures:$0) }
    }
}

