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
    import flash.events.MouseEvent;

    public class RollButton extends MovieClip {

        protected var _animation:MovieClip;
        protected var _isAnimate:Boolean;
        protected var _state:String;

        public function RollButton($wrappedElement:MovieClip = null) {
            _animation = this;
            _isAnimate = false;
            if ($wrappedElement) {
                this.addChild($wrappedElement);
                _animation = $wrappedElement;
            }

            this.addEventListener(MouseEvent.ROLL_OVER, onOver, false, 0, true);
            this.addEventListener(MouseEvent.ROLL_OUT, onOut, false, 0, true);
            this.addEventListener(Event.REMOVED_FROM_STAGE, onRemove, false, 0, true);

            _animation.gotoAndStop(1);

            this.buttonMode = true;
            this.tabEnabled = false;
            this.mouseChildren = false;
        }

        public function clear():void {
            this.removeEventListener(MouseEvent.ROLL_OVER, onOver);
            this.removeEventListener(MouseEvent.ROLL_OUT, onOut);
            this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemove);
            this.removeEventListener(Event.ENTER_FRAME, onEFrame);
        }

        override public function dispatchEvent(e:Event):Boolean {
            if (hasEventListener(e.type) || e.bubbles) {
                return super.dispatchEvent(e);
            }
            return true;
        }

        /**
         * Events
         */
        private function onEFrame(e:Event):void {
            _isAnimate = true;

            if (_state == MouseEvent.ROLL_OVER) {
                _animation.nextFrame();
                if (_animation.currentFrame == _animation.totalFrames) _isAnimate = false;
            } else if (_state == MouseEvent.ROLL_OUT) {
                _animation.prevFrame();
                if (_animation.currentFrame == 1) _isAnimate = false;
            }

            if (!_isAnimate) {
                this.removeEventListener(Event.ENTER_FRAME, onEFrame);
                this.dispatchEvent(new Event(Event.COMPLETE));
            }
        }

        private function onOver(e:MouseEvent):void {
            _state = e.type;
            this.addEventListener(Event.ENTER_FRAME, onEFrame, false, 0, true);
        }

        private function onOut(e:MouseEvent):void {
            _state = e.type;
            this.addEventListener(Event.ENTER_FRAME, onEFrame, false, 0, true);
        }

        private function onRemove(e:Event):void {
            this.clear();
        }
    }
}
