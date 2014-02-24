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

package im.siver.library.geom {

    import flash.display.DisplayObject;
    import flash.geom.Matrix;
    import flash.geom.Point;
    import flash.geom.Rectangle;

    public class Transform extends Object {

        /**
         * Calculates the scaled size based on the scaling algorithm.
         * The available width and height are the width and height of the container.
         * The intrinsic width and height are the width and height of the content.
         */
        public function getScaledSize($scaleMode:String, $availableWidth:Number, $availableHeight:Number, $intrinsicWidth:Number, $intrinsicHeight:Number):Rectangle {
            var result:Rectangle;

            switch ($scaleMode) {
                case ScaleMode.ZOOM:
                case ScaleMode.LETTERBOX:
                    var availableRatio:Number = $availableWidth / $availableHeight;
                    var componentRatio:Number = ($intrinsicWidth || $availableWidth) / ($intrinsicHeight || $availableHeight);
                    if (($scaleMode == ScaleMode.ZOOM && componentRatio < availableRatio) || ($scaleMode == ScaleMode.LETTERBOX && componentRatio > availableRatio)) {
                        result = new Rectangle(0, 0, $availableWidth, $availableWidth / componentRatio);
                    } else {
                        result = new Rectangle(0, 0, $availableHeight * componentRatio, $availableHeight);
                    }
                    break;
                case ScaleMode.STRETCH:
                    result = new Rectangle(0, 0, $availableWidth, $availableHeight);
                    break;
                case ScaleMode.NONE:
                    result = new Rectangle(0, 0, $intrinsicWidth || $availableWidth, $intrinsicHeight || $availableHeight);
                    break;
                default:
                    result = new Rectangle(0, 0, $intrinsicWidth, $intrinsicHeight);
                    break;
            }

            result.x = ($availableWidth - result.width ) >> 1;
            result.y = ($availableHeight - result.height) >> 1;

            return result;
        }

        /**
         * Scales around given point ($posX, $posY)
         */
        public function scale($target:DisplayObject, $posX:Number, $posY:Number, $scaleX:Number, $scaleY:Number):void {
            var currentMatrix:Matrix = $target.transform.matrix.clone();
            var newMatrix:Matrix = currentMatrix.clone();
            var regPoint:Point = currentMatrix.transformPoint(new Point($posX, $posY));
            newMatrix.a = $scaleX;
            newMatrix.d = $scaleY;
            var offset:Point = regPoint.subtract(newMatrix.transformPoint(new Point($posX, $posY)));
            newMatrix.tx = currentMatrix.tx + offset.x;
            newMatrix.ty = currentMatrix.ty + offset.y;

            $target.transform.matrix = newMatrix;
        }
    }
}
