//
//  AnimationComponent.swift
//  SpriteAnimations
//
//  Created by bryn austin bellomy on 2014 Nov 28.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftConfig
import LlamaKit
import Funky


public enum AnimationComponentState: String {
    case Animating = "Animating"
    case NotAnimating = "NotAnimating"
}

private let CurrentAnimationKey = "current animation"

public class AnimationComponent <A: IAnimationType>
{
    public typealias AnimationType = A

    public typealias AtlasType = AnimationAtlas<A>
    public typealias Builder   = AnimationComponentBuilder<A>
    public typealias Keypath   = AtlasType.Keypath
    public typealias State     = AnimationComponentState


    // MARK: Animations

    public var defaultAnimation: A = AnimationType.defaultValue
    public let defaultKeypath = Keypath(animation: AnimationType.defaultValue, frameIndex: 0)

    /** The sprite node on which the animations will be played.  Add this node to your node hierarchy. */
    public var spriteNode: SKSpriteNode

    /** The AnimationAtlas from which to read the animations. */
    public var animationAtlas: AtlasType

    /** The speed of the animation in frames per second. */
    public var framesPerSecond : NSTimeInterval {
        get { return 1 / animationSpeed }
        set { animationSpeed = 1 / newValue }
    }

    /** Expressed as "1 / FPS", where FPS is the desired frames per second. */
    private var animationSpeed : NSTimeInterval = (1 / 3)

    /** The currently running animation (or the animation that was running the last time the Component was animating).  You can set this value to change the animation as it's running. */
    public private(set) var currentAnimation : A = .defaultValue

    /** The current state of the Component (animating or not animating). */
    public private(set) var state: State = .NotAnimating



    //
    // MARK: - Lifecycle
    //

    public init(animationAtlas a:AtlasType, defaultTexture d:SKTexture?, anchorPoint p:CGPoint, framesPerSecond fps:NSTimeInterval) {
        animationAtlas = a
        animationSpeed = 1 / fps

        spriteNode = SKSpriteNode(texture:d)
        spriteNode.anchorPoint = p
    }



    //
    // MARK: - Public API
    //

    public func setCurrentAnimation(animation:A) -> Result<()>
    {
        if currentAnimation != animation {
            currentAnimation = animation

            if state == .Animating {
                return startAnimating()
            }
        }
        return success()
    }

    public func setState(newState:State) -> Result<()>
    {
        let oldState = state
        state = newState

        switch (oldState, newState)
        {
            case (.Animating, .NotAnimating):    return stopAnimating()
            case (.NotAnimating, .Animating):    return startAnimating()
            default: return success()
        }
    }

    //
    // MARK: - Private helper methods
    //

    /**
        Removes any running animations from the Component's `spriteNode`.
    */
    private func stopAnimating() -> Result<()> {
        spriteNode.removeActionForKey(CurrentAnimationKey)
        return success()
    }

    private func startAnimating() -> Result<()>
    {
        if let textures = animationAtlas.texturesForAnimation(currentAnimation)
        {
            var textureArray = textures.toArray()
            let animationAction         = SKAction.animateWithTextures(textureArray, timePerFrame:animationSpeed, resize:true, restore:false)
            let repeatedAnimationAction = SKAction.repeatActionForever(animationAction)

            spriteNode.runAction(repeatedAnimationAction, withKey:CurrentAnimationKey)
            return success()
        }
        else {
            return failure("AnimationType changed, but the new TextureSequence could not be found (keypath: \(currentAnimation))")
        }
    }
}


