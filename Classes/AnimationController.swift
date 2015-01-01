//
//  AnimationController.swift
//  SpriteAnimations
//
//  Created by bryn austin bellomy on 2014 Nov 28.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import SpriteKit
import SwiftLogger
import SwiftConfig
import LlamaKit


public enum AnimationControllerState: String {
    case Animating = "Animating"
    case NotAnimating = "NotAnimating"
}

private let CurrentAnimationKey = "current animation"

public class AnimationController <AnimationType: IAnimationType>
{
    public typealias AtlasType = AnimationAtlas<AnimationType>
    public typealias Builder = AnimationControllerBuilder<AnimationType>
    public typealias Keypath = AtlasType.Keypath
    public typealias State = AnimationControllerState


    private func log(string:String) {
        lllog(.Debug, "(\(spriteNode.name)) \(string)")
    }


    // MARK: Animations

    public var defaultAnimation: AnimationType = AnimationType.defaultValue
    public let defaultKeypath = Keypath(animation: AnimationType.defaultValue, frameIndex: 0)

    /** The sprite node on which the animations will be played.  Add this node to your node hierarchy. */
    public var spriteNode = SKSpriteNode()

    /** The AnimationAtlas from which to read the animations. */
    public var animationAtlas = AtlasType()

    /** The speed of the animation in frames per second. */
    public var framesPerSecond : NSTimeInterval {
        get { return 1 / animationSpeed }
        set { animationSpeed = 1 / newValue }
    }

    /** Expressed as "1 / FPS", where FPS is the desired frames per second. */
    private var animationSpeed : NSTimeInterval = (1 / 3)

    /** The currently running animation (or the animation that was running the last time the controller was animating).  You can set this value to change the animation as it's running. */
    public var currentAnimation : AnimationType = .defaultValue {
        didSet {
            log("[current animation] set to '\(currentAnimation.description)' (old value = \(oldValue.description))")
            if currentAnimation != oldValue && state == .Animating {
                startAnimating()
            }
        }
    }

    /** The current state of the controller (animating or not animating). */
    public private(set) var state: State = .NotAnimating

    //
    // MARK: - Lifecycle
    //

    public init() {
    }

    public init(animationAtlas a:AtlasType, defaultTexture d:SKTexture?, anchorPoint p:CGPoint, framesPerSecond fps:NSTimeInterval) {
        animationAtlas = a
        animationSpeed = 1 / fps

        spriteNode = SKSpriteNode(texture:d)
        spriteNode.anchorPoint = p
    }

    //
    // MARK: - Public API
    //

    public func setState(newState:State)
    {
        log("[setState called] new state = \(newState.rawValue) [current state = \(state.rawValue)]")
        if newState != state
        {
            switch state {
                case .Animating:    stopAnimating()
                case .NotAnimating: startAnimating()
            }
            state = newState
        }
    }

    //
    // MARK: - Private helper methods
    //

    /**
        Removes any running animations from the controller's `spriteNode`.
    */
    private func stopAnimating()
    {
        log("stopAnimating()")
        spriteNode.removeActionForKey(CurrentAnimationKey)

        if let texture = animationAtlas[ currentAnimation, 0 ]? {
            spriteNode.runAction(SKAction.setTexture(texture))
        }
    }

    private func startAnimating()
    {
        log("startAnimating()")
//        spriteNode.removeActionForKey("current animation")
        if let textures = animationAtlas[ currentAnimation ]?
        {
            let animationAction         = SKAction.animateWithTextures(textures.toArray(), timePerFrame:animationSpeed, resize:true, restore:false)
            let repeatedAnimationAction = SKAction.repeatActionForever(animationAction)

            spriteNode.runAction(repeatedAnimationAction, withKey:CurrentAnimationKey)
        }
        else {
            lllog(.Warning, "AnimationType changed, but the new TextureSequence could not be found (keypath: \(currentAnimation))")
        }
    }
}


