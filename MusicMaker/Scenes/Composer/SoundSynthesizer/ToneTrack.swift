//
//  RecordedTrack.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 28.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

struct NoteIndex: Hashable {
    let index: Int
    let time: Float
    func hash(into hasher: inout Hasher) {
        hasher.combine(index)
        hasher.combine(time)
    }
}

class ToneTrack: Track {
    
    private let notes: [Note] = [.C2, .Cd2, .D2, .Dd2, .E2, .F2, .Fd2, .G2, .Gd2, .A2, .Ad2, .B2, .C3, .Cd3, .D3, .Dd3, .E3, .F3, .Fd3, .G3, .Gd3, .A3, .Ad3, .B3]
    private var tracks = [PlayedTone]()
    private var playedNotes = [NoteIndex: PlayedTone]()
    var length: Float {
        return 0
    }
    private var currentTimeStamp: Float = 0
    private let sampleRate: Float
    private var timeIncrement: Float {
        1 / sampleRate
    }
    
    init(sampleRate: Float) {
        self.sampleRate = sampleRate
    }
    
    func advanceTimeAndReturnNextValue() -> Float {
        currentTimeStamp += timeIncrement
        return tracks
            .map { $0.advanceTimeAndReturnValue() }
            .reduce(0, +)
    }
    
    func addNote(at index: Int, time: Float) {
        if playedNotes[NoteIndex(index: index, time: time)] != nil {
           playedNotes[NoteIndex(index: index, time: time)] = nil
            return
        }
        let tone = PlayedTone(tone: SineWave(frequency: notes[index].frequency,
                                             amplitude: 1,
                                             phaseShift: 0),
                              ampEnvelope: LinearEnvelope(attackDuration: 0.02,
                                                          decayDuration: 0.5,
                                                          releaseDuration: 0.3,
                                                          sustainAmplitude: 0.7,
                                                          releaseTime: 0.2,
                                                          sampleRate: sampleRate),
                              freqEnvelope: LinearEnvelope(attackDuration: 0.02,
                                                           decayDuration: 0.5,
                                                           releaseDuration: 0.5,
                                                           sustainAmplitude: 0.3,
                                                           releaseTime: 0.52,
                                                           sampleRate: sampleRate),
                              sampleRate: sampleRate)
        tone.start(time: time)
//        tracks.append(tone)
        playedNotes[NoteIndex(index: index, time: time)] = tone
    }
    
    func prepareToPlay() {
        resetTime()
        tracks = Array(playedNotes.values)
    }
    
    func resetTime() {
        for track in tracks {
            track.start(time: track.startingTime)
        }
        currentTimeStamp = 0
    }
}
