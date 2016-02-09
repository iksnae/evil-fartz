# evil-fartz
A simple audio playback demo


## CODING EXCERSISE

We would like you to build a singleton that is responsible for playing short to medium length audio clips from an iOS 7.x application. Let's call this singleton the "Sound Manager" (for example).

The Sound Manager's purpose is to provide an API to play an audio clip immediately (you may use the clips that we send, and/or add your own). Assume that the Audio Manager is being used by a developer other than yourself and may need to be extended in the future.

Additional UI elements and sound-related features may be added at your discretion.

Notes:

- Do not use Swift; only use Objective-C for this test. (Although we are slowly migrating to Swift in our code base, it is 98% Objective-C, and so this is the skill that we care about right now.)
- Use Xcode 7.2 to make your project, with a Deployment Target of iOS 7.0 (but a Base SDK of "latest"/iOS 9.x is expected).
- Focus on "proper" naming and coding practices, syntax, and style, including class and variable naming.
- Using open-source software on this test is totally OK as long as you include relevant documentation in the project.

Test Tasklist:
- Download our pack of sound files at: https://s3-us-west-2.amazonaws.com/evilapples-scratch/Fartz.zip
- Build a singleton, with an API to play sound files.
- Build a basic UI on top of the API (i.e. to play the sound). It doesn't have to be fancy, but it should look good and represent your base level of taste and design.
- Add a fancy animation or other UI elements that represent the skills you want to show us. You may also add other features to the singleton if you feel inspired to do so.
- Send us your completed project as a link to a public GitHub repo.
