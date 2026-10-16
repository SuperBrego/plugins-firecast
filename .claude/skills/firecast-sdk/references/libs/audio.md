# Biblioteca audio

> Extraído de `docs/Firecast_SDK_-_Single formatado.pdf` (texto automático; tabelas podem ter colunas desalinhadas). 

```text
Audio library

       The Audio library provides functions for playing and handling audio. All features are contained
       in the “Audio” Lua table found in the “audio.lua” unit.
       Usage example:

    -- First, you need to require the “audio.lua” unit
    require("audio.lua");

    -- Now you can access the functions of the library.
    Audio.LIBRARY_FUNCTION(Argument1, Argument2, ...);

Properties and attributes

    Audio.defaultPlayer

       This attribute contains the Audio Player object used for playing audio to the user's default
       audio device
       Remarks:

                                 ○ Audio played through this object is not broadcasted to other users. For
                                      audio transmission, consider using mesa.audioPlayer instead.

Functions

    function Audio.asyncLoadAudioStream(source)

       Asynchronously creates an AudioStream object using the content of an audio file.
       Arguments:
Return:   ○ source - The source of the audio file. You can provide:
Remarks:                      ■ A string containing the external URL of the audio.
                                   Example:
                                   "https://www.domain.com/my/audioFile.mp3"
                              ■ A string containing the file address in the plugin VHD .
                                   Example: "/audios/kick.wav"
                              ■ A Stream object with the audio file content.

          ○ A promise for an AudioStream object.

          ○ An AudioStream object represents a source of audio signal.
          ○ As a source of audio signal, an AudioStream object does not play audio

               by itself. To play it, you must also create an AudioTrack object using the
               "asyncAddTrack" method of the target AudioPlayer object.

function Audio.play(source[, volume])

   Plays an audio file using the user's default audio device.

   Arguments:

                             ○ source - The source of the audio to be played. You can provide:
                                                  ■ A string containing the external URL of the audio.
                                                       Example:
                                                       "https://www.domain.com/my/audioFile.mp3"
                                                  ■ A string containing the file address in the plugin VHD .
                                                       Example: "/audios/kick.wav"
                                                  ■ A Stream object with the audio file content.

                             ○ (Optional) volume - A number representing the volume at which the
                                  audio should be played. This number functions as a multiplication
                                  factor, where 0.0 means total silence, and 2.0 means double the original
                                  audio volume. The default value is 1.0.

   Return:

                             ○ A promise for an AudioTrack object.

   Remarks:

                             ○ This function is a convenient alias and is equivalent to calling
                                  "Audio.defaultPlayer:play(address, volume)"

                             ○ Refer to the AudioPlayer:play method for a deeper understanding of
                                  how this function operates.
AudioPlayer object

  This object represents a target capable of playing audio and offers methods to do so.

  You can retrieve instances of AudioPlayer by using "Audio.defaultPlayer" attribute or
  "room.audioPlayer" attributte.

Characteristics

Methods                               Descrição
   Método

audioPlayer:asyncAddTrack(audioStrea  Creates an AudioTrack object responsible for
m[, params])                          playing the audio signal from an AudioStream
                                      object.

                                      Arguments:

                                                ● audioStream - an AudioStream object
                                                     representing the source of the audio
                                                     signal to be played. It can be obtained
                                                     by calling the
                                                     Audio.asyncLoadAudioStream method.

                                                ● (Optional) params - A Lua table with the
                                                     AudioTrack parameters and may
                                                     contain the following attributes:
                                                                     ○ autoRemoveOnEOF - A
                                                                          boolean; when true,
                                                                          Firecast will
                                                                          automatically remove
                                                                          the track once the
                                                                          provided audioStream
                                                                          reaches its EOF.
                                                                          Default: false;

                                      Return:

                                                ● A promise for an AudioTrack object.

                                      Remarks

                                                ● While an AudioStream object
                                                     represents the source of an audio
                                                     signal, an AudioTrack handles the actual
                                                     playback of the audio signal.

                                                ● An AudioTrack resides within the
                                                     AudioPlayer, and while active, it
                                                     continually retrieves audio signals from
                                                     the provided AudioStream, playing
audioPlayer:play(source[, volume])                 them in real-time.
                                              ● Since the AudioTrack retrieves and

                                                   plays audio in real-time, any changes
                                                   made to the provided AudioStream
                                                   object will also be perceived in real-
                                                   time during playback. This means you
                                                   can adjust the volume, pause, and seek
                                                   audio position using the appropriate
                                                   AudioStream object properties and
                                                   methods while the AudioTrack is active.

                                    Plays an audio file.

                                    Arguments:

                                              ● source - The source of the audio to be
                                                   played. You can provide:
                                                                   ○ A string containing the
                                                                        external URL of the
                                                                        audio. Example:
                                                                        "https://www.domain.c
                                                                        om/my/audioFile.mp3"
                                                                   ○ A string containing the
                                                                        file address in the plugin
                                                                        VHD . Example:
                                                                        "/audios/kick.wav"
                                                                   ○ A Stream object with
                                                                        the audio file content.

                                              ● (Optional) volume - A number
                                                   representing the volume at which the
                                                   audio should be played. This number
                                                   functions as a multiplication factor,
                                                   where 0.0 means total silence, and 2.0
                                                   means double the original audio
                                                   volume. The default value is 1.0.

                                    Return:

                                              ● A promise for an AudioTrack object.

                                    Remarks:

                                              ● The returned promise will be resolved
                                                   as soon as the audio starts to play.

                                              ● This function will play the audio from
                                                   start to end only once.

                                              ● You can use the AudioTrack object
                                                   returned by this function to stop the
                                                   playback if you wish.

                                              ● The AudioTrack created by this
                                                   function will be automatically removed
                                                   from the player once the audio reaches
                                                   the end.
                                   ● This function maintains a strong
                                        reference to the created AudioTrack
                                        object while the audio is playing,
                                        preventing Lua from garbage collecting
                                        it during playback.

AudioStream object

  An AudioStream object represents a source of audio signal and can be created by calling the
  Audio.asyncLoadAudioStream() function. However, it does not play audio on its own. To play it, you
  must also create an AudioTrack object using the "asyncAddTrack" method of a target AudioPlayer
  object.

  During playback of an AudioStream through an AudioTrack object, any alterations made to the
  AudioStream object are immediately reflected in real-time. This allows you to adjust parameters
  such as volume, pause, and audio position using the pertinent AudioStream object properties and
  methods while the AudioTrack is actively playing.

Characteristics

Propertys and attributes

Propriedade               Tipo     Descrição

enabled                   Boolean  Indicates whether the AudioStream
                                   can output audio signal.

                                   If the AudioStream is being played by
                                   an AudioTrack, setting this attribute
                                   to false will pause the playback, as no
                                   audio signal will be outputted. Setting
                                   it back to true will resume the
                                   playback.

                                   Default: True

eof                       Boolean  (Read-only) Indicates whether the
length                    Float    AudioStream has reached its EOF
                                   (end of file).

                                   (Read-only) If the duration of the
                                   audio is known, this attribute contains
                                   its duration in seconds; otherwise, it is
                                   set to nil.

                                   Remarks:

                                             ● Please be aware that this
position  Float                                             attribute may be nil
                                                            instead of a number, so
volume    Float                                             make sure to handle this
                                                            possibility in your code.
Methods
   Método                                   If the current audio stream is seekable
   audioStream:setPosition(newPosition)     and its position is defined, this
                                            contains the stream position in
                                            seconds; otherwise, it is set to nil.

                                            Remarks:

                                                       ● When setting a value to
                                                            this attribute, Firecast will
                                                            seek the audio stream to
                                                            the closest keyframe, and
                                                            its true audio position can
                                                            be slightly earlier than
                                                            desired.

                                                       ● Please be aware that this
                                                            attribute may be nil
                                                            instead of a number, so
                                                            make sure to handle this
                                                            possibility in your code.

                                                       ● Additionally, when the
                                                            audio stream is being
                                                            played by an AudioTrack
                                                            in real-time, this value will
                                                            be updated dynamically,
                                                            allowing you to track the
                                                            playback progress

                                            A numerical value representing the
                                            output volume level of the audio
                                            signal from the AudioStream. This
                                            value acts as a multiplication factor,
                                            with 0.0 indicating complete silence,
                                            and 2.0 indicating twice the original
                                            audio volume. The default value is 1.0

                                         Descrição

                                         Seeks the audio stream to a specified
                                         position.

                                         Arguments:

                                                   ● newPosition - A number
   audioStream:waitEOF();                 indicating the desired
Events                                    position, in seconds, to which
                                          Firecast should seek the
                                          audio stream.

                           Return:

                                     ● A boolean value indicating
                                          whether the audio seek was
                                          successful.

                           Remarks:

                                     ● Firecast will seek the audio
                                          stream to the nearest
                                          keyframe, which may result
                                          in the true audio position
                                          being slightly earlier than
                                          desired.

                                     ● If the audio stream is not
                                          seekable, the method will
                                          return false.

                                     ● Calling this method is
                                          equivalent to setting the
                                          "position" property, but with
                                          the added benefit of being
                                          able to check the success of
                                          the seek operation.

                           Sets up a monitoring that waits for the
                           AudioStream to reach its end of file
                           (EOF).

                           Arguments:

                           None

                           Return:

                                     ● A promise that will be
                                          resolved when the
                                          AudioStream reaches its end
                                          of file (EOF).

                           Remarks:

                                     ● If the AudioStream is already
                                          at the EOF, the returned
                                          promise will be resolved
                                          immediately.
Nome do evento                  Descrição
onEOF
                                This event is triggered by Firecast when the
                                AudioStream reaches its end of file (EOF).

AudioTrack object

  An AudioTrack object serves as a real-time agent that continuously fetches audio signals from an
  AudioStream and plays them. While AudioStream objects provide audio signals, it's the AudioTrack
  objects residing within an AudioPlayer that actually play them.

Lifecycle

  AudioTracks are created using the AudioPlayer's asyncAddTrack method.

  While active, AudioTracks continuously retrieve audio signals from their associated AudioStream,
  playing them in real-time. As AudioTracks retrieve and play audio in real-time, any changes made to
  their associated AudioStream objects will also be immediately reflected in the playback. This allows
  you to adjust the volume, pause, and seek audio position using the relevant AudioStream object
  properties and methods while the AudioTrack is in operation.

  AudioTracks can be stopped by calling their "remove" method. If the Lua Garbage Collector collects
  an AudioTrack object, it will also be automatically stopped.

  Additionally, AudioTracks can be forcibly removed by Firecast. For example, when a user leaves the
  room, all audio transmission to that room must cease. You can use waitRemoval method, removed
  attribute, and/or onRemove event to monitor when this occurs.

Characteristics

Propertys and attributes

Propriedade               Tipo                Descrição

audioStream               AudioStream object  (Read-only) The associated
                                              AudioStream object providing audio
                                              signal to the AudioTrack.

                                              Remarks:

                                                        ● As AudioTracks retrieve
                                                             and play audio in real-
                                                             time, any changes made
                                                             to this AudioStream
                                                             object will also be
                                                             immediately reflected in
removed                 Boolean                               the playback. This allows
                                                              you to adjust the volume,
Methods                                                       pause, and seek audio
   Método                                                     position using the
   audioTrack:remove()                                        relevant AudioStream
                                                              object properties and
                                                              methods while the
                                                              AudioTrack is in
                                                              operation.

                                              (Read-only) Indicates whether the
                                              track has been removed from its
                                              AudioPlayer object.

                                              Remarks

                                                        ● Once a track is removed,
                                                              it cannot be reactivated.
                                                              However, its associated
                                                              AudioStream object can
                                                              be reused.

                                 Descrição

                                 Removes the AudioTrack from its AudioPlayer,
                                 halting the playback.

                                 Arguments:

                                 None

                                 Return:

                                           ● A promise that can be used to track
                                                the asynchronous process of
                                                AudioTrack removal.

                                 Remarks

                                           ● Once a track is removed, it cannot
                                                be reactivated. However, its
                                                associated AudioStream object can
                                                be reused.
   audioTrack:waitRemoval()  Sets up a wait that monitors the removal state
                             of the AudioTrack.
Events
   Nome do evento            Arguments:
   onRemoved
                             None

                             Return:

                                       ● A promise that will be resolved
                                             when the AudioTrack is removed
                                             from its AudioPlayer.

                             Remarks:

                                       ● This function does not remove the
                                             AudioTrack; it simply monitors
                                             when it happens.

                                       ● If the AudioTrack is already
                                             removed, the returned promise will
                                             be resolved immediately.

                                       ● Once a track is removed, it cannot
                                             be reactivated. However, its
                                             associated AudioStream object can
                                             be reused.

                             Descrição

                             This event is triggered by Firecast when the
                             AudioTrack is removed from its AudioPlayer.

                             Remarks:

                                       ● Once a track is removed, it cannot
                                            be reactivated. However, its
                                            associated AudioStream object can
                                            be reused.
```
