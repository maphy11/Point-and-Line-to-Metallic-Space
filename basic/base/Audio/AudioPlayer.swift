//
//  AudioPlayer.swift
//  caimmetal04
//
//  Created by 高部恭平 on 2020/08/15.
//  Copyright © 2020 TUT Creative Application. All rights reserved.
//

import Foundation
import AVFoundation
class AudioPlayer
{
    var player : AVAudioPlayer!
    var volume : Float
    {
        get { return player.volume }
        set { player.volume = newValue}
    }
    var defaultVolume : Float
    init(fileName : String, _ _defaultVolume : Float)
    {
        defaultVolume = _defaultVolume
        let audioPath = Bundle.main.path(forResource: fileName, ofType:"wav")!
        let file = URL(fileURLWithPath: audioPath)
        
        var audioError:NSError?
        do
        {
            
            player = try AVAudioPlayer(contentsOf: file)
            player.play()
            player.volume = 0.0
        } catch let error as NSError
        {
            audioError = error
        }
        
        
        if let error = audioError
        {
            print("Error \(error.localizedDescription)")
        }
    }
    func IsPlaying() ->Bool
    {
        return (player.volume != 0.0)
    }
    func play()
    {
        volume = defaultVolume
    }
}
