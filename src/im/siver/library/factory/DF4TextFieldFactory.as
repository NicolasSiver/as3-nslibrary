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

package im.siver.library.factory {

    import flash.text.engine.FontLookup;

    import flashx.textLayout.conversion.TextConverter;
    import flashx.textLayout.formats.TextLayoutFormat;

    import im.siver.library.text.TextField;

    public class DF4TextFieldFactory {
        public function createTextField($text:String, $format:TextLayoutFormat, $width:Number = 0, $contentType:String = TextConverter.PLAIN_TEXT_FORMAT):TextField {
            var textField:TextField = new TextField();

            textField.defaultTextFormat = $format;

            switch ($contentType) {
                case TextConverter.PLAIN_TEXT_FORMAT:
                    textField.text = $text;
                    break;
                case TextConverter.TEXT_FIELD_HTML_FORMAT:
                    textField.htmlText = $text;
                    break;
                case TextConverter.TEXT_LAYOUT_FORMAT:
                    textField.tlfText = $text;
                    break;
            }

            if ($width > 0) {
                textField.width = $width;
                textField.multiline = true;
            }

            textField.drawNow();

            return textField;
        }

        public function createTextFormat($font:String = null, $size:Object = null, $color:Object = null, $bold:Object = null, $italic:Object = null, $underline:Object = null, $align:String = null, $lineHeight:Object = null):TextLayoutFormat {
            var format:TextLayoutFormat = new TextLayoutFormat();
            format.color = $color;
            format.fontFamily = $font;
            format.fontLookup = FontLookup.EMBEDDED_CFF;
            format.fontSize = $size;
            format.fontWeight = $bold;
            format.fontStyle = $italic;
            format.textDecoration = $underline;
            format.textAlign = $align;
            format.lineHeight = $lineHeight;
            return format;
        }
    }
}
