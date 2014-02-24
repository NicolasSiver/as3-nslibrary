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
    import flash.display.LoaderInfo;
    import flash.events.Event;
    import flash.events.EventDispatcher;
    import flash.events.IEventDispatcher;
    import flash.net.URLRequest;
    import flash.system.ApplicationDomain;
    import flash.text.Font;

    public class FontLoader extends EventDispatcher {

        private const FONT_PREFIX:String = "Font";

        private var _loader:Loader;
        private var _list:Vector.<Class>;

        public function FontLoader(target:IEventDispatcher = null) {
            super(target);
            this.initiate();
        }

        public function addFonts($domain:ApplicationDomain):void {
            var domain:ApplicationDomain = $domain;
            var isSearch:Boolean = true;
            var k:int = 1;

            while (isSearch) {
                if (domain.hasDefinition(FONT_PREFIX + k)) {
                    var FontClass:Class = domain.getDefinition(FONT_PREFIX + k) as Class;
                    _list.push(FontClass);
                    k++;
                } else {
                    isSearch = false;
                }
            }
        }

        public function debugList():void {
            trace("FontLoader : Debug list", 0);
            var list:Array = Font.enumerateFonts();
            var i:int;
            var len:int = list.length;
            var font:Font;
            var info:String;

            for (i; i < len; ++i) {
                font = list[i];
                info = "Font" + "\n";
                info += "name: " + font.fontName + ", \n";
                info += "style: " + font.fontStyle + ", \n";
                info += "type: " + font.fontType + "\n";
                trace(info);
            }
        }

        public function get fontList():Vector.<Class> {
            return _list;
        }

        private function initiate():void {
            _list = new Vector.<Class>();
        }

        public function load($url:URLRequest):void {
            if (_loader == null) {
                _loader = new Loader();
                _loader.contentLoaderInfo.addEventListener(Event.COMPLETE, onComplete);
            }
            _loader.load($url);
        }

        private function onComplete(e:Event):void {
            trace("FontLoader : loading complete", 0);
            var loaderInfo:LoaderInfo = LoaderInfo(e.currentTarget);
            loaderInfo.removeEventListener(Event.COMPLETE, onComplete);
            _loader = null;
            this.addFonts(loaderInfo.applicationDomain);
            this.registerFonts();
            this.debugList();

            this.dispatchEvent(new Event(Event.COMPLETE));
        }

        public function registerFonts():void {
            trace("FontLoader : Register Fonts", 0);
            var i:int;
            var len:int = _list.length;
            var FontClass:Class;

            for (i; i < len; ++i) {
                FontClass = _list[i];
                Font.registerFont(FontClass);
            }
        }
    }
}
