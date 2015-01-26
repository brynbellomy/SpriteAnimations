//
//  AnimationAtlasBuilder.swift
//  SpriteAnimations
//
//  Created by bryn austin bellomy on 2014 Dec 27.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import class SpriteKit.SKTextureAtlas
import class SpriteKit.SKTexture
import Funky
import LlamaKit


public struct AnimationAtlasBuilder <A: IAnimationType>
{
    private typealias BuiltType = AnimationAtlas<A>
    private typealias Keypath   = BuiltType.Keypath
    private typealias Entry     = AnimationAtlasBuilderEntry<A>

    private typealias BuilderCollection = [A: TextureSequence.Builder]
    private var textureSequenceBuilders = BuilderCollection()

    private var entries = [Result<Entry>]()


    public init() {
    }


    public mutating func setTexture(texture:SKTexture, forKeypath keypath:Keypath) {
        let entry = Entry(keypath:keypath, texture:texture)
        entries.append(success(entry))
    }



    public mutating func useTexturesFromAtlas(atlas:SKTextureAtlas, fileExtension:String)
    {
        func getKeypath(textureName:String) -> Result<Keypath> {
            return Keypath(textureName:textureName) ?± failure("Cannot create AnimationAtlasKeypath from texture name '\(textureName)'")
        }

        func loadTexture(keypath:Keypath) -> Result<Entry>
        {
            let textureName = "\(keypath.textureName).\(fileExtension)"
            if let textureNames = atlas.textureNames as? [String]
            {
                if let index = find(textureNames, textureName) {
                    let texture = atlas.textureNamed(textureNames[index])
                    return Entry(keypath:keypath, texture:texture) |> success
                }
            }
            return failure("Could not load texture for name: '\(textureName)'")
        }

        atlas.textureNames as [String] |> mapr(getKeypath />> loadTexture)
                                       |> doEach(entries.append)
    }


    public mutating func build() -> Result<BuiltType>
    {
        func buildTextureSequences(buildGroups:[A: [Entry]]) -> [A: TextureSequence]
        {
            return buildGroups |> mapValues { entryList in
                                   entryList |> reducer(TextureSequence.Builder()) { (var current, next) in current.addEntry(next) }
                                             |> { $0.build() }
                               }
        }

        return coalesce(entries) >>- { entries in

                entries |> groupBy { $0.keypath.animation }
                        |> buildTextureSequences
                        |> { AnimationAtlas<A>(textures:$0) } |> success
            }
    }
}


private extension TextureSequence.Builder
{
    mutating func addEntry <A: IAnimationType> (entry:AnimationAtlasBuilder<A>.Entry) -> TextureSequence.Builder {
        setTexture(entry.texture, atIndex:entry.keypath.frameIndex)
        return self
    }
}






private struct AnimationAtlasBuilderEntry <A: IAnimationType> : Printable, Equatable, Comparable
{
    typealias BuilderType = AnimationAtlasBuilder<A>
    typealias Keypath = BuilderType.Keypath

    let keypath : Keypath
    let texture : SKTexture

    var description: String { return "<AtlasEntry: { keypath = \(keypath), texture = \(texture) }>" }
}

private func <  <A: IAnimationType> (lhs:AnimationAtlasBuilderEntry<A>, rhs:AnimationAtlasBuilderEntry<A>) -> Bool { return lhs.keypath <  rhs.keypath }
private func == <A: IAnimationType> (lhs:AnimationAtlasBuilderEntry<A>, rhs:AnimationAtlasBuilderEntry<A>) -> Bool { return lhs.keypath == rhs.keypath }




