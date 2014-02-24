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

package im.siver.library.net {

    import flash.display.Loader;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.net.URLRequest;

    import im.siver.library.events.QueueLoaderEvent;

    public class QueueLoader extends EventDispatcher {

        private static var _instance:QueueLoader = new QueueLoader();

        private var _list:Array;
        private var _cursor:int;
        private var _isLoading:Boolean;

        public function QueueLoader(target:IEventDispatcher = null) {
            super(target);
            if (_instance) throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
            this.initiate();
        }

        /**
         * Adds item the queue list. Before adding you should add listener for QueueLoaderEvent.COMPLETE and check ID.
         *
         * @param $data Complex Object with "url" property. After $data will contain data and id properties.
         * @return unique ID of added item
         */
        public function addItem($data:Object):int {
            $data.id = ++_cursor;
            _list.push($data);
            this.loadNext();
            return $data.id;
        }

        override public function dispatchEvent(evt:Event):Boolean {
            if (hasEventListener(evt.type) || evt.bubbles) {
                return super.dispatchEvent(evt);
            }
            return true;
        }

        private function initiate():void {
            _list = [];
        }

        public static function getInstance():QueueLoader {
            return _instance;
        }

        protected function loadNext():void {
            if (_list.length > 0 && !_isLoading) {
                var loader:Loader = new Loader();
                var data:Object = _list[0];
                var request:URLRequest = new URLRequest(data.url);
                loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete, false, 0, true);
                loader.load(request);
                _isLoading = true;
            }
        }

        private function onComplete(e:Event):void {
            var data:Object = _list.shift();
            data.content = e.currentTarget.content;
            this.dispatchEvent(new QueueLoaderEvent(QueueLoaderEvent.COMPLETE, data.id, data));
            _isLoading = false;
            this.loadNext();
        }
    }
}
