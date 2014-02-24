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

package im.siver.library.graphics {

    import flash.display.GraphicsPathCommand;

    public class CurvedPath extends Object {
        private var _commands:Vector.<int>;
        private var _data:Vector.<Number>;
        private var _anchors:Vector.<CurvedPoint>;
        private var _posX:Number;
        private var _posY:Number;

        private function calculatePoint($point:CurvedPoint):void {
            var nextPoint:CurvedPoint = this.getNextPoint($point);
            var prevPoint:CurvedPoint = this.getPrevPoint($point);
            var dxn:Number = nextPoint.x - $point.x;
            var dyn:Number = nextPoint.y - $point.y;
            var xsn:Number = this.sign(dxn);
            var ysn:Number = this.sign(dyn);
            var dxp:Number = $point.x - prevPoint.x;
            var dyp:Number = $point.y - prevPoint.y;
            var xsp:Number = this.sign(dxp);
            var ysp:Number = this.sign(dyp);

            if ($point.curved > 0) {
                _posX += xsp * $point.curved;
                _posY += ysp * $point.curved;
                _data.push(_posX, _posY);
                _posX += xsn * $point.curved;
                _posY += ysn * $point.curved;
                _commands.push(GraphicsPathCommand.CURVE_TO);
                _data.push(_posX, _posY);
            }

            _posX += (dxn != 0) ? (dxn - nextPoint.curved * xsn - $point.curved * xsn) : 0;
            _posY += (dyn != 0) ? (dyn - nextPoint.curved * ysn - $point.curved * ysn) : 0;
            _commands.push(GraphicsPathCommand.LINE_TO);
            _data.push(_posX, _posY);
        }

        public function create($anchors:Vector.<CurvedPoint>):void {
            var i:int;
            var len:int = $anchors.length;

            _commands = new Vector.<int>();
            _data = new Vector.<Number>();
            _anchors = $anchors;

            this.setupPosition();

            for (i; i < len; ++i) {
                this.calculatePoint($anchors[i]);
            }
        }

        private function getNextPoint($current:CurvedPoint):CurvedPoint {
            var index:int = _anchors.indexOf($current);
            if (++index >= _anchors.length) {
                return _anchors[0];
            }
            return _anchors[index];
        }

        private function getPrevPoint($current:CurvedPoint):CurvedPoint {
            var index:int = _anchors.indexOf($current);
            if (--index < 0) {
                return _anchors[_anchors.length - 1];
            }
            return _anchors[index];
        }

        private function sign($value:Number):int {
            return int($value > 0) - int($value < 0);
        }

        private function setupPosition():void {
            var point:CurvedPoint = _anchors[0];
            var nextPoint:CurvedPoint = _anchors[_anchors.length - 1];
            var dx:Number = nextPoint.x - point.x;
            var dy:Number = nextPoint.y - point.y;
            var xs:Number = this.sign(dx);
            var ys:Number = this.sign(dy);

            _posX = point.x + xs * point.curved;
            _posY = point.y + ys * point.curved;
            _commands.push(GraphicsPathCommand.MOVE_TO);
            _data.push(_posX, _posY);
        }

        /*
         * Getters
         */
        public function get commands():Vector.<int> {
            return _commands;
        }

        public function get data():Vector.<Number> {
            return _data;
        }
    }
}
