//
//  AnimationAtlas.swift
//  SpriteAnimations
//
//  Created by bryn austin bellomy on 2014 Sep 21.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import func SwiftLogger.lllog
import BrynSwift


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

    private var textures = [AnimationType: TextureSequence]()

    /** The first texture of the animation `AnimationType.defaultValue`, or nil if it does not exist. */
    public var defaultTexture: SKTexture? {
        return textureForKeypath(defaultTextureKeypath) //self[ AnimationType.defaultValue, 0 ]
    }

    public var defaultTextureKeypath: Keypath = Keypath(animation:AnimationType.defaultValue, frameIndex:0)

    public var animations: [AnimationType] { return Array(textures.keys) }


    //
    // MARK: - Lifecycle
    //

    public init(textures t: [AnimationType: TextureSequence]) {
        lllog(.Debug, "AnimationAtlas.init => textures = \(t.description)")
        textures = t
    }


    public init() {
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
        return textures.indexForKey(animation) != nil
    }


    /** Returns the texture at the given keypath, or nil if none was found. */
    public func textureForKeypath(keypath:Keypath) -> SKTexture? {
        return textureForAnimation(keypath.animation, index:keypath.frameIndex)
    }


    /** Returns the texture at the given keypath, or nil if none was found. */
    public func textureForAnimation(animation:AnimationType, index:Int) -> SKTexture?
    {
        if let theTextures = texturesForAnimation(animation)?
        {
            if 0 <= index && index < theTextures.count {
                return theTextures.textureAtIndex(index)
            }
        }
        return nil
    }


    /** Returns the `TextureSequence` for the given animation, or nil if none was found. */
    public func texturesForAnimation(animation:AnimationType) -> TextureSequence? {
        if hasAnimation(animation) {
            if let t = textures[animation]? {
                return t
            }
        }
        lllog(.Error, "Could not find textures for animation '\(animation.description)'")
        return nil
    }
}











