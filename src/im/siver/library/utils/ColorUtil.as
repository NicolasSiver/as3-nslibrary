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

    public class ColorUtil {

        /**
         * Convert HSV representation of the color to RGB.
         * @param hue [0°, 360°]
         * @param saturation [0, 1]
         * @param value [0, 1]
         * @return RGB color
         */
        public static function HSVtoRGB(hue:Number, saturation:Number, value:Number):uint {
            var r:Number = 0;
            var g:Number = 0;
            var b:Number = 0;

            var hi:int = Math.floor(hue / 60) % 6;
            var f:Number = hue / 60 - Math.floor(hue / 60);
            var p:Number = (value * (1 - saturation));
            var q:Number = (value * (1 - f * saturation));
            var t:Number = (value * (1 - (1 - f) * saturation));

            switch (hi) {
                case 0:
                    r = value;
                    g = t;
                    b = p;
                    break;
                case 1:
                    r = q;
                    g = value;
                    b = p;
                    break;
                case 2:
                    r = p;
                    g = value;
                    b = t;
                    break;
                case 3:
                    r = p;
                    g = q;
                    b = value;
                    break;
                case 4:
                    r = t;
                    g = p;
                    b = value;
                    break;
                case 5:
                    r = value;
                    g = p;
                    b = q;
                    break;
            }

            return (Math.round(r * 255) << 16 | Math.round(g * 255) << 8 | Math.round(b * 255));
        }
    }
}
