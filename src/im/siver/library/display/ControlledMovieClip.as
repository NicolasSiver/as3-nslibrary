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

package im.siver.library.display {

    import flash.display.MovieClip;
    import flash.events.Event;

    public class ControlledMovieClip extends MovieClip {

        public static const START:String = "start";
        public static const END:String = "end";

        protected var _isAnimate:Boolean;
        protected var _state:Object;

        public function ControlledMovieClip() {
            _isAnimate = false;

            this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove, false, 0, true);
            this.gotoAndStop(1);
        }

        public function clear():void {
            this.removeEventListener(Event.ENTER_FRAME, onEFrame);
            this.removeEventListener(Event.ENTER_FRAME, onUFrame);
        }

        override public function dispatchEvent(e:Event):Boolean {
            if (hasEventListener(e.type) || e.bubbles) {
                return super.dispatchEvent(e);
            }
            return true;
        }

        public function goTo($state:String):void {
            _state = $state;
            this.addEventListener(Event.ENTER_FRAME, onEFrame, false, 0, true);
        }

        override public function play():void {
            this.clear();
            super.play();
        }

        public function playUntil($frame:int):void {
            _state = $frame;
            this.addEventListener(Event.ENTER_FRAME, onUFrame, false, 0, true);
        }

        override public function stop():void {
            this.clear();
            super.stop();
        }

        /**
         * Events
         */
        private function onEFrame(e:Event):void {
            _isAnimate = true;

            if (_state == ControlledMovieClip.END) {
                this.nextFrame();
                if (this.currentFrame == this.totalFrames) _isAnimate = false;
            } else if (_state == ControlledMovieClip.START) {
                this.prevFrame();
                if (this.currentFrame == 1) _isAnimate = false;
            }

            if (!_isAnimate) {
                this.removeEventListener(Event.ENTER_FRAME, onEFrame);
                this.dispatchEvent(new Event(Event.COMPLETE));
            }
        }

        private function onRemove(e:Event):void {
            this.clear();
        }

        private function onUFrame(e:Event):void {
            if (_state == this.currentFrame) {
                this.stop();
                this.removeEventListener(Event.ENTER_FRAME, onUFrame);
            }
        }
    }
}
