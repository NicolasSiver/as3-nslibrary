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

    import flash.text.AntiAliasType;
    import flash.text.TextField;
    import flash.text.TextFieldAutoSize;
    import flash.text.TextFormat;

    public class DF3TextFieldFactory {
        public function createTextField($text:String, $format:TextFormat, $width:int = 0, $isHTML:Boolean = false):TextField {
            var textField:TextField = new TextField();
            textField.defaultTextFormat = $format;
            textField.autoSize = TextFieldAutoSize.LEFT;
            textField.antiAliasType = AntiAliasType.ADVANCED;
            textField.embedFonts = true;
            textField.multiline = Boolean($width);
            textField.wordWrap = Boolean($width);
            if ($width > 0) textField.width = $width;
            if ($isHTML) {
                textField.htmlText = $text;
            } else {
                textField.text = $text;
            }
            textField.mouseWheelEnabled = false;

            return textField;
        }
    }
}
