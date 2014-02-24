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

package im.siver.library.utils {

    import flash.display.*;
    import flash.events.*;

    public class KeyListener extends Object {
        private static var _isInit:Boolean;
        private static var _keys:Object;

        public function KeyListener() {
        }

        public static function clear():void {
            _keys = {};
        }

        public static function dispose($stage:Stage):void {
            if (_isInit) {
                $stage.removeEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
                $stage.removeEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
                $stage.removeEventListener(Event.DEACTIVATE, onDeactivate);
                _keys = null;
                _isInit = false;
            }
        }

        public static function initiate($stage:Stage):void {
            if (!_isInit) {
                _keys = {};

                $stage.addEventListener(KeyboardEvent.KEY_DOWN, onKeyPressed);
                $stage.addEventListener(KeyboardEvent.KEY_UP, onKeyReleased);
                $stage.addEventListener(Event.DEACTIVATE, onDeactivate);

                _isInit = true;
            }
        }

        public static function isDown($keyCode:uint):Boolean {
            if (!_isInit) throw new Error("Key Listener must be initiated");
            return ($keyCode in _keys);
        }

        private static function onDeactivate(e:Event):void {
            trace("KeyListener : Stage deactivate, all keys cleared");
            _keys = {};
        }

        private static function onKeyPressed(e:KeyboardEvent):void {
            _keys[e.keyCode] = true;
        }

        private static function onKeyReleased(e:KeyboardEvent):void {
            if (e.keyCode in _keys) {
                delete _keys[e.keyCode];
            }
        }
    }
}
