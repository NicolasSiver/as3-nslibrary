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

package im.siver.library.events {

    import flash.events.Event;

    public class QueueLoaderEvent extends Event {

        public static const COMPLETE:String = "queueLoaderEventComplete";

        private var _id:int;
        private var _data:Object;

        public function QueueLoaderEvent(type:String, $id:int, $data:Object, bubbles:Boolean = false, cancelable:Boolean = false) {
            _id = $id;
            _data = $data;
            super(type, bubbles, cancelable);
        }

        override public function clone():Event {
            return new QueueLoaderEvent(type, id, data, bubbles, cancelable);
        }

        /**
         * Getters
         */
        public function get id():int {
            return _id;
        }

        public function get data():Object {
            return _data;
        }
    }
}
