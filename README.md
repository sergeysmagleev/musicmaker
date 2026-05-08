## Drum Machine
A drum machine that plays a 100% synthesized drums loop with a kick, a snare and a hi-hat drums.

<img width="2622" height="1206" alt="Simulator Screenshot - iPhone 17 Pro - 2026-05-08 at 14 57 10" src="https://github.com/user-attachments/assets/49d1d372-9cc9-41b8-bfb1-75d494931f5d" />

I initially coded this project in 2020 as experimentation with AVAudioEngine. The audio processing core, all sound synthesis and playback logic are written purely in C++ without any third party libraries.
The app is written in Swift with an Objective-C layer serving as a bridge between C++ and Swift.

## Usage
Run the project and hit play. You can play around with the drum pattern do get a different drum beat. You can also change the BPM at the top. You have to stop and hit play again for the changes to make effect.

## Disclaimer
You can find more features and screens in this app, such as a piano roll, audio recording playback, audio wave and frequency visualizers etc. Also, there are different intruments and effects other than drums. However, these are experiments and aren't finished products.
