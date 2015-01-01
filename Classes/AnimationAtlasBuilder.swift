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
import BrynSwift
import SwiftLogger
import LlamaKit


public struct AnimationAtlasBuilder <AnimationType: IAnimationType>
{
    private typealias BuiltType = AnimationAtlas<AnimationType>
    private typealias Keypath   = BuiltType.Keypath
    private typealias Entry     = AnimationAtlasBuilderEntry<AnimationType>

    private typealias BuilderCollection = [AnimationType: TextureSequence.Builder]
    private var textureSequenceBuilders = BuilderCollection()

    private var entries = [Result<Entry, NSError>]()


    public init() {
    }


    public mutating func setTexture(texture:SKTexture, forKeypath keypath:Keypath) {
        let entry = Entry(keypath:keypath, texture:texture)
        entries.append(success(entry))
    }



    public mutating func useTexturesFromAtlas(atlas:SKTextureAtlas)
    {
        func getKeypath(textureName:String) -> Result<Keypath, NSError> {
            return Keypath(textureName:textureName) ?± failure("Cannot create AnimationAtlasKeypath from texture name '\(textureName)'")
        }

        func loadTexture(keypath:Keypath) -> Result<Entry, NSError> {
            if !contains(atlas.textureNames as [String], keypath.textureName) {
                return failure("Could not load texture for name: '\(keypath.textureName)'")
            }
            return success(Entry(keypath:keypath, texture:atlas.textureNamed(keypath.textureName)))
        }

        func addEntry(result:Result<Entry, NSError>) {
            if let entry = result.value? { setTexture(entry.texture, forKeypath:entry.keypath) }
        }

        atlas.textureNames as [String] |> mapr(getKeypath />> loadTexture)
                                       |> do_each(addEntry)
    }


    public mutating func build() -> Result<BuiltType, NSError>
    {
        func buildTextureSequences(buildGroups:[AnimationType: [Entry]]) -> [(AnimationType, TextureSequence)]
        {
            return buildGroups |> mapr { animation, entryList in
                                   var builder = TextureSequence.Builder()
                                   entryList |> do_each { builder.setTexture($0.texture, atIndex:$0.keypath.frameIndex) }
                                   return (animation, builder.build())
                               }
        }

        return entries  |> map_filter(unwrap_value)
                        |> group_by { $0.keypath.animation }
                        |> buildTextureSequences
                        |> mapToDictionary(id)
                        |> do_side(lllog(.Debug, prefix:"AnimationAtlasBuilder"))
                        |> { AnimationAtlas(textures:$0) } >>> success
    }
}




private struct AnimationAtlasBuilderEntry <AnimationType: IAnimationType> : Printable, Equatable, Comparable
{
    typealias BuilderType = AnimationAtlasBuilder <AnimationType>
    typealias Keypath = BuilderType.Keypath

    let keypath : Keypath
    let texture : SKTexture

    var description: String { return "<AtlasEntry: { keypath = \(keypath), texture = \(texture) }>" }
}

private func <  <A: IAnimationType> (lhs:AnimationAtlasBuilderEntry<A>, rhs:AnimationAtlasBuilderEntry<A>) -> Bool { return lhs.keypath <  rhs.keypath }
private func == <A: IAnimationType> (lhs:AnimationAtlasBuilderEntry<A>, rhs:AnimationAtlasBuilderEntry<A>) -> Bool { return lhs.keypath == rhs.keypath }




