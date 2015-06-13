package com.leonel {	import flash.display.Loader;	import flash.net.URLRequest;	import flash.display.MovieClip;	import flash.events.Event;	import flash.text.AntiAliasType;	import flash.text.TextField;	import flash.text.TextFieldAutoSize;	import flash.text.TextFormat;	import flash.text.TextFormatAlign;	import flash.text.TextLineMetrics;		//CustomLoader		/**	 * This classes makes a TextField with special formatting	 * @author Leonel Serra	 */	public class MakeTextField extends MovieClip {				private var fontLoader:Loader;		private var myTextField:TextField = new TextField();		private var myFormat:TextFormat = new TextFormat();				private var _text:String;		private var _fontName:String;		private var _color:Number;		private var _size:Number;		private var _bold:Boolean;		private var _italic:Boolean;		private var _underline:Boolean;		private var _width:Number;		private var _height:Number;				private var _align:String;		private var _antiAlias:String;		private var _wordwrap:Boolean;		private var _multiline:Boolean;		private var _selectable:Boolean;		private var _htmlText:Boolean;		private var _autosize:String;		private var _name:String;		private var _border:Boolean;				/**		 * Main constructor		 * @param	_text			String of text you want to show. If this text is HTML see the last option		 * @param	_fontContainer	String with the URL to load the SWF with the font file		 * @param	_fontName		String with the name of the font inside the SWF		 * @param	_size			Number with the font size		 * @param	_color			Number with the color of the font		 * @param	_bold			Boolean		 * @param	_italic			Boolean		 * @param	_underline		Boolean		 * @param	_width			Number with the width of the TextField generated		 * @param	_height			Number with the height of the TextField generated		 * @param	_align			String with the alignment: "left", "right", "center" and "justify"		 * @param	_antiAlias		String with the type of anti-alias: "normal" and "advanced"		 * @param	_wordwrap		Boolean		 * @param	_multiline		Boolean		 * @param	_selectable		Boolean		 * @param	_htmlText		Boolean This makes the _text be interpreted as HTML		 * @param	_autosize		String for textfield autosize : "none", "left", "right" and "center"		 */		public function MakeTextField(_text:String = null, _fontContainer:String = "Arial.swf", _fontName:String = "Arial", _size:Number = 10, _color:Number = 0xFFFFFF, _bold:Boolean = false, _italic:Boolean = false, _underline:Boolean = false, _width:Number = 10, _height:Number = 10, _align:String = "left", _antiAlias:String = "normal", _wordwrap:Boolean = false, _multiline:Boolean = false, _selectable:Boolean = false, _htmlText:Boolean = false, _autosize:String = "none", _border:Boolean = false):void {			this.fontLoader = new Loader();			var fontRequest:URLRequest = new URLRequest(_fontContainer);			fontLoader.load(fontRequest);						if (_text == null) {				this._text = "";			}else {				this._text = _text;			}						this._fontName = _fontName;			this._color = _color;			this._size = _size;			this._bold = _bold;			this._underline = _underline;			this._italic = _italic;			this._width = _width;			this._height = _height;						this._align = _align;			this._antiAlias = _antiAlias;			this._wordwrap = _wordwrap;			this._multiline = _multiline;			this._selectable = _selectable;			this._htmlText = _htmlText;			this._autosize = _autosize;			this._border = _border;						this.fontLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, fontLoaded);					}				/**		 * When the font is loaded starts the formatting		 * @param	e		 */		private function fontLoaded(e:Event):void {			myTextField.mouseEnabled = false;			//ALIGN			if (this._align == "left") {				myFormat.align = TextFormatAlign.LEFT;			} else if (this._align == "right") {				myFormat.align = TextFormatAlign.LEFT;			} else if (this._align == "center") {				myFormat.align = TextFormatAlign.CENTER;			} else if (this._align == "justify") {				myFormat.align = TextFormatAlign.JUSTIFY;			}						//FONT, SIZE, BOLD, ITALIC, UNDERLINE, COLOR			myFormat.font = this._fontName;			myFormat.size = this._size;			myFormat.bold = this._bold;			myFormat.italic = this._italic;			myFormat.underline = this._underline;			myFormat.color = this._color;						//WIDTH AND HEIGHT			myTextField.width = this._width;			myTextField.height = this._height;						//ANTI-ALIAS			if (_antiAlias == "normal") {				myTextField.antiAliasType = AntiAliasType.NORMAL;			} else if (_antiAlias == "advanced") {				myTextField.antiAliasType = AntiAliasType.ADVANCED;			} else {				myTextField.antiAliasType = AntiAliasType.NORMAL;			}			myTextField.embedFonts = true; //In the SWF the font must be embeded with embedAsCFF="false"						//WORDWRAP, MULTILINE, SELECTABLE			myTextField.wordWrap = _wordwrap;			myTextField.multiline = _multiline;			myTextField.selectable = _selectable;			myTextField.border = _border;						//DEFAULT FORMAT			//myTextField.setTextFormat(myFormat);			myTextField.defaultTextFormat = myFormat;						//HTML OR NOT			if (this._htmlText) {				myTextField.htmlText = this._text;			} else {				myTextField.text = this._text;			}						//AUTOSIZE			switch (this._autosize) {				case "none":					myTextField.autoSize = TextFieldAutoSize.NONE;					break;				case "left":					myTextField.autoSize = TextFieldAutoSize.LEFT;					break;				case "right":					myTextField.autoSize = TextFieldAutoSize.RIGHT;					break;				case "center":					myTextField.autoSize = TextFieldAutoSize.CENTER;					break;			}						addTextField();		}				/**		 * Adds the textfield to the stage		 */		private function addTextField():void {			myTextField.addEventListener(Event.ADDED_TO_STAGE, textAddedToStage, false, 0, true);			addChild(myTextField);		}				private function textAddedToStage(e:Event):void {			removeEventListener(Event.ADDED_TO_STAGE, textAddedToStage);		}				/**		 * Returns the number of lines inside the textfield		 */		public function get numberLines():Number {			return myTextField.numLines;		}				/**		 * Changes the text in the textfield		 */		public function set setText(value:String):void {			if (this._htmlText) {				myTextField.htmlText = value;			} else {				myTextField.text = value;			}		}				/**		 * Returns the textfield text		 */		public function get getText():String {			return myTextField.text;		}				/**		 * Returns the textfield width		 */		public function get getWidth():Number {			return this._width;		}				public function get getTextWidth():Number {			var metrics:TextLineMetrics = myTextField.getLineMetrics(0);			var startX:Number = metrics.width;			return startX;		}				/**		 * Returns the textfield		 */		public function get getTextField():TextField {			return myTextField;		}				/**		 * Overrides the name function to name this object		 */		override public function set name(value:String):void {			this._name = value;		}				/**		 * Overrides the name function to name this object		 */		override public function get name():String {			return this._name;		}				/**		 * Change font size		 */		public function set fontSize(value:Number):void {			myFormat.size = value;			this._size = value;						myTextField.defaultTextFormat = myFormat;		}				/**		 * Return font size		 */		public function get fontSize():Number {			return this._size;		}	}}