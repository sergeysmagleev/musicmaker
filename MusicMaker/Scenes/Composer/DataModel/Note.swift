//
//  Note.swift
//  MusicMaker
//
//  Created by Sergey Smagleev on 28.05.20.
//  Copyright © 2020 Sergey Smagleev. All rights reserved.
//

import Foundation

enum Note {
    case C0
    case Cd0
    case Db0
    case D0
    case Dd0
    case Eb0
    case E0
    case F0
    case Fd0
    case Gb0
    case G0
    case Gd0
    case Ab0
    case A0
    case Ad0
    case Bb0
    case B0
    case C1
    case Cd1
    case Db1
    case D1
    case Dd1
    case Eb1
    case E1
    case F1
    case Fd1
    case Gb1
    case G1
    case Gd1
    case Ab1
    case A1
    case Ad1
    case Bb1
    case B1
    case C2
    case Cd2
    case Db2
    case D2
    case Dd2
    case Eb2
    case E2
    case F2
    case Fd2
    case Gb2
    case G2
    case Gd2
    case Ab2
    case A2
    case Ad2
    case Bb2
    case B2
    case C3
    case Cd3
    case Db3
    case D3
    case Dd3
    case Eb3
    case E3
    case F3
    case Fd3
    case Gb3
    case G3
    case Gd3
    case Ab3
    case A3
    case Ad3
    case Bb3
    case B3
    case C4
    case Cd4
    case Db4
    case D4
    case Dd4
    case Eb4
    case E4
    case F4
    case Fd4
    case Gb4
    case G4
    case Gd4
    case Ab4
    case A4
    case Ad4
    case Bb4
    case B4
    case C5
    case Cd5
    case Db5
    case D5
    case Dd5
    case Eb5
    case E5
    case F5
    case Fd5
    case Gb5
    case G5
    case Gd5
    case Ab5
    case A5
    case Ad5
    case Bb5
    case B5
    case C6
    case Cd6
    case Db6
    case D6
    case Dd6
    case Eb6
    case E6
    case F6
    case Fd6
    case Gb6
    case G6
    case Gd6
    case Ab6
    case A6
    case Ad6
    case Bb6
    case B6
    case C7
    case Cd7
    case Db7
    case D7
    case Dd7
    case Eb7
    case E7
    case F7
    case Fd7
    case Gb7
    case G7
    case Gd7
    case Ab7
    case A7
    case Ad7
    case Bb7
    case B7
    case C8
    case Cd8
    case Db8
    case D8
    case Dd8
    case Eb8
    case E8
    case F8
    case Fd8
    case Gb8
    case G8
    case Gd8
    case Ab8
    case A8
    case Ad8
    case Bb8
    case B8
}

let noteFrequencies: [Note : Float] = [
    .C0 : 16.35,
    .Cd0 : 17.32,
    .Db0 : 17.32,
    .D0 : 18.35,
    .Dd0 : 19.45,
    .Eb0 : 19.45,
    .E0 : 20.60,
    .F0 : 21.83,
    .Fd0 : 23.12,
    .Gb0 : 23.12,
    .G0 : 24.50,
    .Gd0 : 25.96,
    .Ab0 : 25.96,
    .A0 : 27.50,
    .Ad0 : 29.14,
    .Bb0 : 29.14,
    .B0 : 30.87,
    .C1 : 32.70,
    .Cd1 : 34.65,
    .Db1 : 34.65,
    .D1 : 36.71,
    .Dd1 : 38.89,
    .Eb1 : 38.89,
    .E1 : 41.20,
    .F1 : 43.65,
    .Fd1 : 46.25,
    .Gb1 : 46.25,
    .G1 : 49.00,
    .Gd1 : 51.91,
    .Ab1 : 51.91,
    .A1 : 55.00,
    .Ad1 : 58.27,
    .Bb1 : 58.27,
    .B1 : 61.74,
    .C2 : 65.41,
    .Cd2 : 69.30,
    .Db2 : 69.30,
    .D2 : 73.42,
    .Dd2 : 77.78,
    .Eb2 : 77.78,
    .E2 : 82.41,
    .F2 : 87.31,
    .Fd2 : 92.50,
    .Gb2 : 92.50,
    .G2 : 98.00,
    .Gd2 : 103.83,
    .Ab2 : 103.83,
    .A2 : 110.00,
    .Ad2 : 116.54,
    .Bb2 : 116.54,
    .B2 : 123.47,
    .C3 : 130.81,
    .Cd3 : 138.59,
    .Db3 : 138.59,
    .D3 : 146.83,
    .Dd3 : 155.56,
    .Eb3 : 155.56,
    .E3 : 164.81,
    .F3 : 174.61,
    .Fd3 : 185.00,
    .Gb3 : 185.00,
    .G3 : 196.00,
    .Gd3 : 207.65,
    .Ab3 : 207.65,
    .A3 : 220.00,
    .Ad3 : 233.08,
    .Bb3 : 233.08,
    .B3 : 246.94,
    .C4 : 261.63,
    .Cd4 : 277.18,
    .Db4 : 277.18,
    .D4 : 293.66,
    .Dd4 : 311.13,
    .Eb4 : 311.13,
    .E4 : 329.63,
    .F4 : 349.23,
    .Fd4 : 369.99,
    .Gb4 : 369.99,
    .G4 : 392.00,
    .Gd4 : 415.30,
    .Ab4 : 415.30,
    .A4 : 440.00,
    .Ad4 : 466.16,
    .Bb4 : 466.16,
    .B4 : 493.88,
    .C5 : 523.25,
    .Cd5 : 554.37,
    .Db5 : 554.37,
    .D5 : 587.33,
    .Dd5 : 622.25,
    .Eb5 : 622.25,
    .E5 : 659.25,
    .F5 : 698.46,
    .Fd5 : 739.99,
    .Gb5 : 739.99,
    .G5 : 783.99,
    .Gd5 : 830.61,
    .Ab5 : 830.61,
    .A5 : 880.00,
    .Ad5 : 932.33,
    .Bb5 : 932.33,
    .B5 : 987.77,
    .C6 : 1046.50,
    .Cd6 : 1108.73,
    .Db6 : 1108.73,
    .D6 : 1174.66,
    .Dd6 : 1244.51,
    .Eb6 : 1244.51,
    .E6 : 1318.51,
    .F6 : 1396.91,
    .Fd6 : 1479.98,
    .Gb6 : 1479.98,
    .G6 : 1567.98,
    .Gd6 : 1661.22,
    .Ab6 : 1661.22,
    .A6 : 1760.00,
    .Ad6 : 1864.66,
    .Bb6 : 1864.66,
    .B6 : 1975.53,
    .C7 : 2093.00,
    .Cd7 : 2217.46,
    .Db7 : 2217.46,
    .D7 : 2349.32,
    .Dd7 : 2489.02,
    .Eb7 : 2489.02,
    .E7 : 2637.02,
    .F7 : 2793.83,
    .Fd7 : 2959.96,
    .Gb7 : 2959.96,
    .G7 : 3135.96,
    .Gd7 : 3322.44,
    .Ab7 : 3322.44,
    .A7 : 3520.00,
    .Ad7 : 3729.31,
    .Bb7 : 3729.31,
    .B7 : 3951.07,
    .C8 : 4186.01,
    .Cd8 : 4434.92,
    .Db8 : 4434.92,
    .D8 : 4698.63,
    .Dd8 : 4978.03,
    .Eb8 : 4978.03,
    .E8 : 5274.04,
    .F8 : 5587.65,
    .Fd8 : 5919.91,
    .Gb8 : 5919.91,
    .G8 : 6271.93,
    .Gd8 : 6644.88,
    .Ab8 : 6644.88,
    .A8 : 7040.00,
    .Ad8 : 7458.62,
    .Bb8 : 7458.62,
    .B8 : 7902.13
]

let majorNotes: [Note] = [
    .C0,
    .D0,
    .E0,
    .F0,
    .G0,
    .A0,
    .B0,
    .C1,
    .D1,
    .E1,
    .F1,
    .G1,
    .A1,
    .B1,
    .C2,
    .D2,
    .E2,
    .F2,
    .G2,
    .A2,
    .B2,
    .C3,
    .D3,
    .E3,
    .F3,
    .G3,
    .A3,
    .B3,
    .C4,
    .D4,
    .E4,
    .F4,
    .G4,
    .A4,
    .B4,
    .C5,
    .D5,
    .E5,
    .F5,
    .G5,
    .A5,
    .B5,
    .C6,
    .D6,
    .E6,
    .F6,
    .G6,
    .A6,
    .B6,
    .C7,
    .D7,
    .E7,
    .F7,
    .G7,
    .A7,
    .B7,
    .C8,
    .D8,
    .E8,
    .F8,
    .G8,
    .A8,
    .B8
]

let minorNotes: [Note] = [
    .Cd0,
    .Db0,
    .Dd0,
    .Eb0,
    .Fd0,
    .Gb0,
    .Gd0,
    .Ab0,
    .Ad0,
    .Bb0,
    .Cd1,
    .Db1,
    .Dd1,
    .Eb1,
    .Fd1,
    .Gb1,
    .Gd1,
    .Ab1,
    .Ad1,
    .Bb1,
    .Cd2,
    .Db2,
    .Dd2,
    .Eb2,
    .Fd2,
    .Gb2,
    .Gd2,
    .Ab2,
    .Ad2,
    .Bb2,
    .Cd3,
    .Db3,
    .Dd3,
    .Eb3,
    .Fd3,
    .Gb3,
    .Gd3,
    .Ab3,
    .Ad3,
    .Bb3,
    .Cd4,
    .Db4,
    .Dd4,
    .Eb4,
    .Fd4,
    .Gb4,
    .Gd4,
    .Ab4,
    .Ad4,
    .Bb4,
    .Cd5,
    .Db5,
    .Dd5,
    .Eb5,
    .Fd5,
    .Gb5,
    .Gd5,
    .Ab5,
    .Ad5,
    .Bb5,
    .Cd6,
    .Db6,
    .Dd6,
    .Eb6,
    .Fd6,
    .Gb6,
    .Gd6,
    .Ab6,
    .Ad6,
    .Bb6,
    .Cd7,
    .Db7,
    .Dd7,
    .Eb7,
    .Fd7,
    .Gb7,
    .Gd7,
    .Ab7,
    .Ad7,
    .Bb7,
    .Cd8,
    .Db8,
    .Dd8,
    .Eb8,
    .Fd8,
    .Gb8,
    .Gd8,
    .Ab8,
    .Ad8,
    .Bb8
]

extension Note {
    var frequency: Float {
        noteFrequencies[self]!
    }
}
