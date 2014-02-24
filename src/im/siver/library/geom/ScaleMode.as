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

    public final class ScaleMode {
        /**
         * <code>NONE</code> implies that the media size is set to match its intrinsic size.
         */
        public static const NONE:String = "none";
        /**
         * <code>STRETCH</code> sets the width and the height of the content to the
         * container width and height, possibly changing the content aspect ratio.
         */
        public static const STRETCH:String = "stretch";
        /**
         * <code>LETTERBOX</code> sets the width and height of the content as close to the container width and height
         * as possible while maintaining aspect ratio.  The content is stretched to a maximum of the container bounds,
         * with spacing added inside the container to maintain the aspect ratio if necessary.
         */
        public static const LETTERBOX:String = "letterbox";
        /**
         * <code>ZOOM</code> is similar to <code>LETTERBOX</code>, except that <code>ZOOM</code> stretches the
         * content past the bounds of the container, to remove the spacing required to maintain aspect ratio.
         * This has the effect of using the entire bounds of the container, but also possibly cropping some content.
         */
        public static const ZOOM:String = "zoom";
    }
}