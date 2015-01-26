//
//  AnimationAtlas.swift
//  SpriteAnimations
//
//  Created by bryn austin bellomy on 2014 Sep 21.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import Funky
import SwiftLogger


/**
    A collection of `TextureSequence`s keyed by `IAnimationType`.
 */
public struct AnimationAtlas <AnimationType : IAnimationType>
{
    public typealias Keypath = AnimationAtlasKeypath<AnimationType>
    public typealias Builder = AnimationAtlasBuilder<AnimationType>

    //
    // MARK: - Member variables
    //

    internal private(set) var textures: [String: TextureSequence]

    /** The first texture of the animation `AnimationType.defaultValue`, or nil if it does not exist. */
    public var defaultTexture: SKTexture? {
        return textureForKeypath(defaultTextureKeypath)
    }

    public var defaultTextureKeypath: Keypath = Keypath(animation:AnimationType.defaultValue, frameIndex:0)

    public var allAnimations: [AnimationType] {
        return map(textures.keys) { AnimationType(animationFilenameComponent:$0)! }
    }

    public var allKeypaths: [Keypath] {
        return reduce(textures, [Keypath]()) { current, next in
            let (animation, textureSequence) = next
            let indices  = stride(from:0, to:textureSequence.count, by:1)
            let keypaths = map(indices) { Keypath(animation:AnimationType(animationFilenameComponent:animation)!, frameIndex:$0) }
            return current + keypaths
        }
    }


    //
    // MARK: - Lifecycle
    //

    public init(textures t: [AnimationType: TextureSequence]) {
        textures = t |> mapKeys { $0.animationFilenameComponent }
    }


    public init() {
        textures = [String: TextureSequence]()
    }


    //
    // MARK: - Subscripting
    //

    public subscript(animation:AnimationType) -> TextureSequence? {
        return texturesForAnimation(animation)
    }

    public subscript(animation:AnimationType, index:Int) -> SKTexture? {
        return textureForAnimation(animation, index:index)
    }


    //
    // MARK: - Public API
    //

    /** Returns `true` if the animation exists in the atlas and `false` otherwise. */
    public func hasAnimation(animation:AnimationType) -> Bool {
        return textures.indexForKey(animation.animationFilenameComponent) != nil
    }


    /** Returns the texture at the given keypath, or nil if none was found. */
    public func textureForKeypath(keypath:Keypath) -> SKTexture? {
        return textureForAnimation(keypath.animation, index:keypath.frameIndex)
    }


    /** Returns the texture at the given keypath, or nil if none was found. */
    public func textureForAnimation(animation:AnimationType, index:Int) -> SKTexture?
    {
        if let theTextures = texturesForAnimation(animation)
        {
            if 0 ..< theTextures.count ~= index {
                return theTextures.textureAtIndex(index)
            }
        }
        return nil
    }


    /** Returns the `TextureSequence` for the given animation, or nil if none was found. */
    public func texturesForAnimation(animation:AnimationType) -> TextureSequence? {
        if let index = textures.indexForKey(animation.animationFilenameComponent) {
            return textures[index].1
        }
        return nil
    }
}

extension AnimationAtlas : Printable, DebugPrintable {
    public var description: String { return "<AnimationAtlas: \(describe(textures))>" }

    public var debugDescription: String {
        return "<AnimationAtlas: \(describe(textures))>"
    }
}











