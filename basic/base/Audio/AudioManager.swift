//
//  AudioManager.swift
//  caimmetal04
//
//  Created by 高部恭平 on 2020/08/15.
//  Copyright © 2020 TUT Creative Application. All rights reserved.
//

import Foundation
import AVFoundation
class AudioManager
{
    var audioPlyerList : [AudioPlayer] = [AudioPlayer]()
    var basePlayer, kickPlayer, hihatPlayer, pianoPlayer, pianoPlayer02, pianoPlayer03 : AudioPlayer!
    
    init()
    {
        audioPlyerList.append(AudioPlayer(fileName: "otokiso01", 0.5))
        audioPlyerList.append(AudioPlayer(fileName: "kickloop01", 0.5))
        audioPlyerList.append(AudioPlayer(fileName: "hihatloop01", 0.3))
        audioPlyerList.append(AudioPlayer(fileName: "piano01", 0.1))
        audioPlyerList.append(AudioPlayer(fileName: "pianoloop01", 0.1))
        audioPlyerList.append(AudioPlayer(fileName: "pianoloop02", 0.1))
    }
    func Play(count:Int)
    {
        if(count == 0) { return }
        if(count >= audioPlyerList.count) { return }
        if(audioPlyerList[count - 1].IsPlaying() && !audioPlyerList[count].IsPlaying())
        {
            audioPlyerList[count].play()
        }
    }
}
