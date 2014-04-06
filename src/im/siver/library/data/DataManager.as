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

package im.siver.library.data {

    import flash.net.SharedObject;

    import im.siver.library.logging.ILogger;
    import im.siver.library.logging.TraceLogger;

    public final class DataManager extends Object {
        private static var _instance:DataManager = new DataManager();
        private var _dynamicVars:Object;
        private var _languageVars:Object;
        private var _logger:ILogger;

        public function DataManager() {
            if (_instance) throw new Error("Singleton and can only be accessed through Singleton.getInstance()");
            _dynamicVars = {};
            _languageVars = {};
            _logger = new TraceLogger();

        }

        public static function getInstance():DataManager {
            return _instance;
        }

        public function getValue($key:String, $sharedDomain:Object = null):* {
            var result:*;

            if ($sharedDomain) {
                try {
                    var so:SharedObject = SharedObject.getLocal(String($sharedDomain));
                    var data:Object = so.data;

                    if ($key in data) {
                        result = data[$key];
                    } else {
                        _logger.log($key + " doesn't present in Shared Object", DebugColors.WARNING);
                    }
                } catch (e:*) {
                    _logger.log("SharedObject, Error occured: " + $sharedDomain, DebugColors.ERROR);
                }
            } else {
                if ($key in _dynamicVars) {
                    result = _dynamicVars[$key];
                } else {
                    _logger.log($key + " doesn't present in Dynamic Object", DebugColors.IMPORTANT);
                }
            }
            return result;
        }

        public function getData($key:String, $language:String):* {
            var result:*;
            if ($key in _languageVars) {
                result = _languageVars[$key];

                if ($language in result) {
                    result = result[$language];
                } else {
                    result = null;
                    _logger.log($language + " doesn't present in Language Object", DebugColors.IMPORTANT);
                }
            } else {
                _logger.log($key + " doesn't present in Language Object", DebugColors.IMPORTANT);
            }
            return result;
        }

        public function registerVar($value:*, $key:String = "key", $sharedDomain:Object = null):void {
            if ($sharedDomain) {
                try {
                    var so:SharedObject = SharedObject.getLocal(String($sharedDomain));
                    so.data[$key] = $value;
                    so.flush();
                    _logger.log("Global Shared Value Register: " + $key, DebugColors.IMPORTANT);
                } catch (e:*) {
                    _logger.log("SharedObject, Error occured for: " + $key + ", text: " + e, DebugColors.ERROR);
                }
            } else {
                _logger.log("Global Value Register: " + $key, DebugColors.IMPORTANT);
                _dynamicVars[$key] = $value;
            }
        }

        public function registerData($value:*, $key:String, $language:String):void {
            _logger.log("Global Data Register: " + $key, DebugColors.IMPORTANT);
            var data:Object = _languageVars[$key];
            if (data) {
                data[$language] = $value;
            } else {
                data = {};
                data[$language] = $value;
                _languageVars[$key] = data;
            }
        }

        public function removeVar($key:String):* {
            var result:* = this.getValue($key);
            if (result == undefined) {
                throw new Error("Variable with " + $key + "doesnt present in Dynamic Object");
            } else {
                delete _dynamicVars[$key];
            }
            return result;
        }

        public function setLogger($logger:ILogger):void {
            _logger = $logger;
        }
    }
}
