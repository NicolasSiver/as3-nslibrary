/*
 * The MIT License (MIT)
 *
 * Copyright (c) 2014. Nicolas Siver (http://siver.im)
 *
 * Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated
 * documentation files (the "Software"), to deal in the Software without restriction, including without
 * limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of
 * the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 *
 * The above copyright notice and this permission notice shall be included in all copies or substantial portions
 * of the Software.
 *
 * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED
 * TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
 * THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF
 * CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS
 * IN THE SOFTWARE.
 */

package im.siver.library.sound {

    import flash.display.Sprite;
    import flash.events.MouseEvent;
    import flash.media.Sound;
    import flash.media.SoundChannel;
    import flash.media.SoundTransform;
    import flash.text.TextField;

    import im.siver.library.data.DebugColors;
    import im.siver.library.logging.ILogger;
    import im.siver.library.logging.TraceLogger;

    public class SFXEngine extends Object {

        protected var _sfxChannels:Object;
        protected var _logger:ILogger;
        protected var _channelNameCursor:int;
        protected var _channels:int;

        public function SFXEngine($logger:ILogger) {
            _logger = $logger;
            this.initiate();
        }

        public function clearChannel($sfxChannelName:String):int {
            var sfxChannel:SFXChannel = this.getSFXChannel($sfxChannelName);
            var cleared:int = sfxChannel.clear();
            _logger.log("SFXChannel clear, removed: " + cleared, DebugColors.SFX);
            return cleared;
        }

        public function createChannel($sfxChannelName:String):Boolean {
            _sfxChannels[$sfxChannelName] = new SFXChannel($sfxChannelName);
            _channels++;
            _logger.log("SFXChannel created, name: " + $sfxChannelName, DebugColors.SFX);
            return true;
        }

        public function createSoundChannel($sfxChannelName:String, $id:Object, $sound:Sound, $startTime:Number = 0, $loops:int = 0, $soundTransform:SoundTransform = null, $isParallel:Boolean = false):Object {
            var sfxChannel:SFXChannel;
            var soundChannel:SoundChannel;
            var soundTransform:SoundTransform;
            var settings:SoundChannelSettings;
            var id:Object;

            _logger.log("Creating sound channel, Sound: " + $sound + ", length: " + $sound.length + ", start time: " + $startTime + ", loops: " + $loops + ", is paralllel " + $isParallel, DebugColors.SFX);

            if ($sound == null) throw new Error("Sound can't be null");

            sfxChannel = this.getSFXChannel($sfxChannelName);

            id = $id || this.createSoundChannelID();
            _logger.log("Creating sound channel, ID: " + $id, DebugColors.SFX);
            soundChannel = sfxChannel.channels[id];

            $soundTransform = $soundTransform || new SoundTransform(1);

            if (soundChannel != null) {
                soundTransform = soundChannel.soundTransform;
                settings = sfxChannel.channelsSettings[id];

                if (!$isParallel && soundChannel != null) {
                    soundChannel.stop();
                    soundChannel = null;
                }

                settings.sound = $sound;
                settings.volume = $soundTransform.volume;
                settings.pan = $soundTransform.pan;
                settings.position = $startTime;
                settings.loops = $loops;
                settings.isPaused = false;

                soundTransform.volume = Math.min($soundTransform.volume, sfxChannel.masterVolume);
                soundTransform.pan = $soundTransform.pan;
                soundChannel = $sound.play($startTime, $loops, soundTransform);

                sfxChannel.channels[id] = soundChannel;
                sfxChannel.channelsSettings[id] = settings;

            } else {
                settings = new SoundChannelSettings();

                settings.sound = $sound;
                settings.volume = $soundTransform.volume;
                settings.pan = $soundTransform.pan;
                settings.position = $startTime;
                settings.loops = $loops;
                settings.isPaused = false;

                soundTransform = new SoundTransform(Math.min($soundTransform.volume, sfxChannel.masterVolume), $soundTransform.pan);
                soundChannel = $sound.play($startTime, $loops, soundTransform);
                sfxChannel.channels[id] = soundChannel;
                sfxChannel.channelsSettings[id] = settings;
            }

            if (soundChannel == null) {
                _logger.log($sfxChannelName + ": Channel " + $id + " didn't create", DebugColors.WARNING);
            }

            return id;
        }

        protected function createSoundChannelID():int {
            return ++_channelNameCursor;
        }

        protected function getSFXChannel($sfxChannelName:String):SFXChannel {
            var sfxChannel:SFXChannel = _sfxChannels[$sfxChannelName];
            if (sfxChannel == null) throw new Error("Create SFX Channel first");
            return sfxChannel;
        }

        public function getChannelNames():Array {
            var result:Array = [];

            for each(var channel:SFXChannel in _sfxChannels) {
                result.push(channel.name);
            }

            return result;
        }

        public function getChannelVolume($sfxChannelName:String):Number {
            var sfxChannel:SFXChannel = this.getSFXChannel($sfxChannelName);
            return sfxChannel.masterVolume;
        }

        public function getSoundChannel($sfxChannelName:String, $id:Object):SoundChannel {
            var sfxChannel:SFXChannel = this.getSFXChannel($sfxChannelName);
            return sfxChannel.channels[$id];
        }

        protected function initiate():void {
            _sfxChannels = {};
            if (_logger == null) {
                _logger = new TraceLogger();
            }
            _logger.target = this;
        }

        public function pauseSoundChannel($sfxChannelName:String, $id:Object):void {
            var sfxChannel:SFXChannel = this.getSFXChannel($sfxChannelName);
            _logger.log($sfxChannelName + ": Pause sound channel " + $id, DebugColors.SFX);
            sfxChannel.pauseChannel($id);
        }

        public function removeSoundChannel($sfxChannelName:String, $id:Object):void {
            var sfxChannel:SFXChannel = this.getSFXChannel($sfxChannelName);
            _logger.log($sfxChannelName + ": Remove sound channel " + $id, DebugColors.SFX);
            sfxChannel.removeChannel($id);
        }

        public function resumeSoundChannel($sfxChannelName:String, $id:Object):void {
            var sfxChannel:SFXChannel = this.getSFXChannel($sfxChannelName);
            _logger.log($sfxChannelName + ": Resume sound channel " + $id, DebugColors.SFX);
            sfxChannel.resumeChannel($id);
        }

        public function setChannelTransform($sfxChannelName:String, $volume:Number = 1):void {
            _logger.log($sfxChannelName + ": Channel changing transform, volume: " + $volume, DebugColors.SFX);
            var sfxChannel:SFXChannel = this.getSFXChannel($sfxChannelName);
            sfxChannel.masterVolume = $volume;

            sfxChannel.updateMasterTransform();
        }

        public function updateSoundChannel($sfxChannelName:String, $id:Object, $volume:Number = 1, $pan:Number = 0):void {
            var sfxChannel:SFXChannel = this.getSFXChannel($sfxChannelName);
            _logger.log($sfxChannelName + ": Update sound channel " + $id + ", to volume: " + $volume + ", pan: " + $pan, DebugColors.SFX);
            sfxChannel.updateChannel($id, $volume, $pan);


        }

        /*
         * Getters
         */

        public function get channels():int {
            return _channels;
        }
    }
}

import flash.media.Sound;
import flash.media.SoundChannel;
import flash.media.SoundTransform;
import flash.utils.Dictionary;

internal class SFXChannel extends Object {

    public var name:String;
    public var masterVolume:Number;
    public var channels:Dictionary;
    public var channelsSettings:Dictionary;

    public function SFXChannel($name:String) {
        this.name = $name;
        this.masterVolume = 1;
        this.channels = new Dictionary();
        this.channelsSettings = new Dictionary();
    }

    public function clear():int {
        var channels:int;
        var soundChannel:SoundChannel;

        for (var id:Object in this.channels) {
            soundChannel = channels[id];
            soundChannel.stop();
            channels++;
        }

        this.channels = new Dictionary();

        return channels;
    }

    public function updateMasterTransform():void {
        var soundChannel:SoundChannel;
        var settings:SoundChannelSettings;
        var soundTransform:SoundTransform;

        for (var id:Object in channels) {
            soundChannel = this.channels[id];
            settings = this.channelsSettings[id];
            soundTransform = soundChannel.soundTransform;
            soundTransform.volume = Math.min(settings.volume, this.masterVolume);
            soundChannel.soundTransform = soundTransform;
        }
    }

    public function pauseChannel($id:Object):void {
        var soundChannel:SoundChannel = this.channels[$id];
        var settings:SoundChannelSettings = this.channelsSettings[$id];
        if (soundChannel != null) {
            soundChannel.stop();
            if (settings.position != soundChannel.position) settings.isPaused = true;
            settings.position = soundChannel.position;
        }
    }

    public function removeChannel($id:Object):void {
        var soundChannel:SoundChannel = this.channels[$id];
        var settings:SoundChannelSettings = this.channelsSettings[$id];
        if (soundChannel != null) {
            soundChannel.stop();
            settings.sound = null;
            delete this.channels[$id];
            delete this.channelsSettings[$id];
        }
    }

    public function resumeChannel($id:Object):void {
        var soundChannel:SoundChannel = this.channels[$id];
        var settings:SoundChannelSettings = this.channelsSettings[$id];

        if (soundChannel != null) {
            var soundTransform:SoundTransform = soundChannel.soundTransform;
            if (settings.isPaused) {
                soundChannel = settings.sound.play(settings.position, settings.loops, soundTransform);
                this.channels[$id] = soundChannel;
            }
            settings.isPaused = false;
        }
    }

    public function updateChannel($id:Object, $volume:Number, $pan:Number):void {
        var soundChannel:SoundChannel = this.channels[$id];
        var settings:SoundChannelSettings = this.channelsSettings[$id];
        var volume:Number = Math.min($volume, this.masterVolume);
        var soundTransform:SoundTransform = soundChannel.soundTransform;

        settings.volume = $volume;
        settings.pan = $pan;

        soundTransform.volume = volume;
        soundTransform.pan = $pan;
        soundChannel.soundTransform = soundTransform;
    }
}

internal class SoundChannelSettings extends Object {

    public var position:Number = 0;
    public var volume:Number = 1;
    public var pan:Number = 0;
    public var isPaused:Boolean;
    public var sound:Sound;
    public var loops:int;
}