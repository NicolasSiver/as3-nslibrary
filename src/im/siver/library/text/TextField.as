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

package im.siver.library.text {

    import flash.display.BlendMode;
    import flash.display.Sprite;
    import flash.events.Event;
    import flash.text.TextFieldType;
    import flash.utils.Dictionary;

    import flashx.textLayout.container.ContainerController;
    import flashx.textLayout.conversion.TextConverter;
    import flashx.textLayout.edit.EditManager;
    import flashx.textLayout.edit.SelectionFormat;
    import flashx.textLayout.edit.SelectionManager;
    import flashx.textLayout.elements.Configuration;
    import flashx.textLayout.elements.TextFlow;
    import flashx.textLayout.formats.TextLayoutFormat;

    public class TextField extends Sprite {
        public static var inCallLaterPhase:Boolean = false;
        public var version:String = "1.0.0";
        // General
        protected var _callLaterMethods:Dictionary;
        protected var _enabled:Boolean = true;
        protected var _invalidHash:Object;
        protected var _width:Number;
        protected var _height:Number;
        protected var _x:Number;
        protected var _y:Number;
        protected var _startWidth:Number;
        protected var _startHeight:Number;
        protected var _textHolder:Sprite;
        protected var _rawContent:String;
        protected var _isMultiline:Boolean;
        protected var _isSelectable:Boolean;
        protected var _textFieldType:String;
        protected var _contentType:String;
        // TLF
        protected var _container:ContainerController;
        protected var _configuration:Configuration;
        protected var _textFlow:TextFlow;
        protected var _textFormat:TextLayoutFormat;
        protected var _defaultLinkActiveFormat:TextLayoutFormat;
        protected var _defaultLinkHoverFormat:TextLayoutFormat;
        protected var _defaultLinkNormalFormat:TextLayoutFormat;
        protected var _focusedSelectionFormat:SelectionFormat;
        protected var _unfocusedSelectionFormat:SelectionFormat;
        protected var _inactiveSelectionFormat:SelectionFormat;
        protected var _selectionManager:SelectionManager;
        protected var _editManager:EditManager;

        public function TextField() {
            _invalidHash = {};
            _callLaterMethods = new Dictionary();
            this.initiate();
            invalidate(InvalidationType.ALL);
        }

        protected function callLater($fn:Function):void {
            if (TextField.inCallLaterPhase) {
                return;
            }

            _callLaterMethods[$fn] = true;

            if (this.stage != null) {
                this.stage.addEventListener(Event.RENDER, onCallLater, false, 0, true);
                this.stage.invalidate();
            } else {
                this.addEventListener(Event.ADDED_TO_STAGE, onCallLater, false, 0, true);
            }
        }

        protected function draw():void {
            if (isInvalid(InvalidationType.ALL)) {
                this.updateSize();
                this.updateStyle();
            }
            if (isInvalid(InvalidationType.STYLES)) {
                this.updateStyle();
            }
            if (isInvalid(InvalidationType.DATA)) {
                this.updateStyle();
            }
            if (isInvalid(InvalidationType.SIZE)) {
                this.updateSize();
            }

            this.validate();
        }

        public function drawNow():void {
            this.draw();
        }

        protected function initiate():void {
            var w:Number = super.width;
            var h:Number = super.height;

            _textHolder = new Sprite();
            _configuration = new Configuration(true);
            _container = new ContainerController(_textHolder, NaN, NaN);
            _textFlow = new TextFlow();
            _textFormat = new TextLayoutFormat();
            _selectionManager = new SelectionManager();
            _editManager = new EditManager();
            _textFieldType = TextFieldType.DYNAMIC;
            _focusedSelectionFormat = new SelectionFormat(0xFFFFFF, 1, BlendMode.DIFFERENCE);
            _rawContent = "";
            _startWidth = w;
            _startHeight = h;

            this.addChild(_textHolder);
        }

        public function invalidate($property:String = "all", $callLater:Boolean = true):void {
            _invalidHash[$property] = true;
            if ($callLater) {
                this.callLater(this.draw);
            }
        }

        protected function isInvalid(property:String, ...properties:Array):Boolean {
            if (_invalidHash[property] || _invalidHash[InvalidationType.ALL]) {
                return true;
            }
            while (properties.length > 0) {
                if (_invalidHash[properties.pop()]) {
                    return true;
                }
            }
            return false;
        }

        protected function getScaleY():Number {
            return super.scaleY;
        }

        protected function setScaleY($value:Number):void {
            super.scaleY = $value;
        }

        protected function getScaleX():Number {
            return super.scaleX;
        }

        protected function setScaleX($value:Number):void {
            super.scaleX = $value;
        }

        public function move($x:Number, $y:Number):void {
            _x = $x;
            _y = $y;
            super.x = Math.round($x);
            super.y = Math.round($y);
        }

        public function setSize($width:Number, $height:Number):void {
            _width = $width;
            _height = $height;
            this.invalidate(InvalidationType.SIZE);
        }

        public function setDefaultLinkFormat($normalFormat:TextLayoutFormat = null, $hoverFormat:TextLayoutFormat = null, $activeFormat:TextLayoutFormat = null):void {
            _defaultLinkActiveFormat = $activeFormat;
            _defaultLinkHoverFormat = $hoverFormat;
            _defaultLinkNormalFormat = $normalFormat;
            this.invalidate(InvalidationType.STYLES);
        }

        public function setSelectionFormat($focusedFormat:SelectionFormat = null, $unfocusedFormat:SelectionFormat = null, $inactiveFormat:SelectionFormat = null):void {
            _focusedSelectionFormat = $focusedFormat;
            _unfocusedSelectionFormat = $unfocusedFormat;
            _inactiveSelectionFormat = $inactiveFormat;
            this.invalidate(InvalidationType.STYLES);
        }

        protected function updateSize():void {
            _container.setCompositionSize((!isNaN(_width) && _width > 0 && _isMultiline) ? _width : NaN, _height);
            _textFlow.flowComposer.updateAllControllers();
        }

        protected function updateStyle():void {
            _configuration.textFlowInitialFormat = _textFormat;
            _configuration.defaultLinkActiveFormat = _defaultLinkActiveFormat;
            _configuration.defaultLinkHoverFormat = _defaultLinkHoverFormat;
            _configuration.defaultLinkNormalFormat = _defaultLinkNormalFormat;
            _configuration.focusedSelectionFormat = _focusedSelectionFormat;
            _configuration.unfocusedSelectionFormat = _unfocusedSelectionFormat;
            _configuration.inactiveSelectionFormat = _inactiveSelectionFormat;
            _textFlow = TextConverter.importToFlow(_rawContent, _contentType, _configuration);

            switch (_textFieldType) {
                case TextFieldType.DYNAMIC:
                    (_isSelectable) ? _textFlow.interactionManager = _selectionManager : _textFlow.interactionManager = null;
                    break;
                case TextFieldType.INPUT:
                    _textFlow.interactionManager = _editManager;
                    break;
            }
            _textFlow.flowComposer.addController(_container);
            _textFlow.flowComposer.updateAllControllers();
        }

        protected function validate():void {
            _invalidHash = {};
        }

        public function validateNow():void {
            this.invalidate(InvalidationType.ALL, false);
            this.draw();
        }

        /*
         * Events
         */
        private function onCallLater(e:Event):void {
            if (e.type == Event.ADDED_TO_STAGE) {
                this.removeEventListener(Event.ADDED_TO_STAGE, onCallLater);
                // now we can listen for render event:
                this.stage.addEventListener(Event.RENDER, onCallLater, false, 0, true);
                this.stage.invalidate();
                return;
            } else {
                e.target.removeEventListener(Event.RENDER, onCallLater);
                if (this.stage == null) {
                    // received render, but the stage is not available, so we will listen for addedToStage again:
                    this.addEventListener(Event.ADDED_TO_STAGE, onCallLater, false, 0, true);
                    return;
                }
            }

            TextField.inCallLaterPhase = true;

            var methods:Dictionary = _callLaterMethods;
            for (var method:Object in methods) {
                Function(method)();
                delete(methods[method]);
            }
            TextField.inCallLaterPhase = false;
        }

        /*
         * Getters / Setters
         */
        public function set defaultTextFormat($format:TextLayoutFormat):void {
            _textFormat = $format;
            this.invalidate(InvalidationType.STYLES);
        }

        override public function get width():Number {
            return ( isNaN(_width) ) ? super.width : _width;
        }

        override public function set width($value:Number):void {
            if (_width == $value) {
                return;
            }
            setSize($value, _height);
        }

        override public function get height():Number {
            return ( isNaN(_height) ) ? super.height : _height;
        }

        override public function set height($value:Number):void {
            if (_height == $value) {
                return;
            }
            setSize(_width, $value);
        }

        public function set htmlText($value:String):void {
            _contentType = TextConverter.TEXT_FIELD_HTML_FORMAT;
            _rawContent = $value;
            this.invalidate(InvalidationType.STYLES);
        }

        public function set tlfText($value:String):void {
            _contentType = TextConverter.TEXT_LAYOUT_FORMAT;
            _rawContent = $value;
            this.invalidate(InvalidationType.STYLES);
        }

        public function set multiline($state:Boolean):void {
            _isMultiline = $state;
            this.invalidate(InvalidationType.SIZE);
        }

        public function set selectable($state:Boolean):void {
            _isSelectable = $state;
            this.invalidate(InvalidationType.STYLES);
        }

        override public function get scaleX():Number {
            return _width / _startWidth;
        }

        override public function set scaleX($value:Number):void {
            setSize(_startWidth * $value, _height);
        }

        override public function get scaleY():Number {
            return _height / _startHeight;
        }

        override public function set scaleY($value:Number):void {
            setSize(_width, _startHeight * $value);
        }

        public function get text():String {
            return _rawContent;
        }

        public function set text($value:String):void {
            _contentType = TextConverter.PLAIN_TEXT_FORMAT;
            _rawContent = $value;
            this.invalidate(InvalidationType.STYLES);
        }

        public function get textFlow():TextFlow {
            return _textFlow;
        }

        public function set type($value:String):void {
            if (_textFieldType == $value) return;
            _textFieldType = $value;
            this.invalidate(InvalidationType.STYLES);
        }

        override public function get x():Number {
            return ( isNaN(_x) ) ? super.x : _x;
        }

        override public function set x($value:Number):void {
            move($value, _y);
        }

        override public function get y():Number {
            return ( isNaN(_y) ) ? super.y : _y;
        }

        override public function set y($value:Number):void {
            move(_x, $value);
        }
    }
}
internal class InvalidationType {
    public static const ALL:String = "all";
    public static const SIZE:String = "size";
    public static const STYLES:String = "styles";
    public static const STATE:String = "state";
    public static const DATA:String = "data";
}
