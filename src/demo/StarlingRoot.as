// =================================================================================================
//
//	Created by Rodrigo Lopez [roipeker™] on 06/07/2018.
//
// =================================================================================================

package demo {
import flash.geom.Rectangle;

import starling.core.Starling;
import starling.display.Quad;
import starling.display.Sprite;
import starling.events.Event;
import starling.events.Touch;
import starling.events.TouchEvent;
import starling.events.TouchPhase;
import starling.text.TextField;
import starling.text.TextFormat;
import starling.textures.Texture;
import starling.utils.Align;
import starling.utils.Color;

import textcompositors.MyCustomTrueTypeCompositor;

public class StarlingRoot extends Sprite {

    private var message_tf:TextField;
    private var msgContainer:Sprite;
    private var emojiMap:Object = {};

    public function StarlingRoot() {
        addEventListener(Event.ADDED_TO_STAGE, init);
    }

    private function init(event:Event):void {

        var compositor:MyCustomTrueTypeCompositor = new MyCustomTrueTypeCompositor();
        TextField.registerCompositor(compositor, "_sans");
        TextField.registerCompositor(compositor, "_serif");
        TextField.registerCompositor(compositor, "_typewriter");
        // if you use other fonts that u need to "measure", add them as well.

        Assets.init();

        // Lets create a map for the ids ...
        createEmojiMap();

        msgContainer = new Sprite();

        var bg:Quad = new Quad(stage.stageWidth, 160, 0x0);

        message_tf = new TextField(stage.stageWidth, bg.height, "Hello", new TextFormat("_sans", 26, Color.WHITE));
//        message_tf.autoSize = TextFieldAutoSize.VERTICAL;
        message_tf.format.horizontalAlign = Align.CENTER;
        message_tf.format.verticalAlign = Align.CENTER;
        message_tf.isHtmlText = true;
        message_tf.border = true;

        message_tf.x = bg.width - message_tf.width >> 1;
        msgContainer.y = stage.stageHeight - bg.height >> 1;

        msgContainer.addChild(bg);
        msgContainer.addChild(message_tf);
        addChild(msgContainer);

        message_tf.addEventListener("textRendered", onTextRendered);
        message_tf.addEventListener(TouchEvent.TOUCH, onTextTouch);
        showNextMessage();

//        testAnimation();
    }

    // just to see the benefit of containing the emojis/icons inside
    // the TextField
    private function testAnimation():void {
        message_tf.alignPivot();
        message_tf.x += message_tf.pivotX;
        message_tf.y += message_tf.pivotY;
        Starling.juggler.tween(message_tf, 1, {rotation: 0.3, scale: 1.4, repeatCount: 0, reverse: true});
    }

    private function showNextMessage():void {
        applyText(LangData.getNextLang());
//        applyText(LangData.MSG_GR);
    }

    private function onTextTouch(event:TouchEvent):void {
        var t:Touch = event.getTouch(message_tf, TouchPhase.ENDED);
        if (t) {
            showNextMessage();
        }
    }

    // we use a high unicode value (miscellaneous symbols) ... to avoid confilcts on replacements.
    // taken from https://en.wikipedia.org/wiki/List_of_Unicode_characters
    private function createEmojiMap():void {
        addEmojiKey("{ico1}", 0x2600, Assets.ico1Texture, 30);
        addEmojiKey("{ico2}", 0x2601, Assets.ico2Texture, 30);
        addEmojiKey("{starling}", 0x2602, Assets.starlingTexture, 25, 40);
        addEmojiKey("{:)}", 0x2603, Assets.smileTexture, 20);
    }

    private function addEmojiKey(key:String, unicodeReplacer:uint, texture:Texture, spacing:Number, expectedWidth:Number = 0) {
        // we create a SPACE char with the specified size...
        // play around with the width for the spacing.
        emojiMap[key] = {
            key: key,
            texture: texture,
            expectedWidth: expectedWidth,
            unicodeReplacer: String.fromCharCode(unicodeReplacer),
            replacer: '<FONT letterspacing="' + spacing + '"> </FONT>'
        };
    }

    private function applyText(msg:String):void {
        // reuse emojis, put all back to pool.
        // you can store them in an array as well.
        for (var i:int = message_tf.numChildren - 1; i >= 0; i--) {
            var emoji:MyEmoji = message_tf.getChildAt(i) as MyEmoji;
            if (emoji) emoji.put();
        }


        // search and replace the keys with special unicodes chars (irrelevant which, as long as
        // they don't appear in the original text, and are not repeated).
        for (var key:String in emojiMap) {
            var o:Object = emojiMap[key];
            msg = msg.split(key).join(o.unicodeReplacer);
        }
        message_tf.text = msg;
    }

    private function onTextRendered(event:Event, data:Object):void {
        var tf:TextField = event.target as TextField;
        // parse each emoji and each coincidence:
        for (var key:String in emojiMap) {
            var o:Object = emojiMap[key];
            var bounds:Array = LineMetrics.getEmojiBounds(data.nativeTextField, o);
            for each(var bound:Rectangle in bounds) {
                addEmoji(o, bound, tf);
            }
        }
    }

    private function addEmoji(emojiData:Object, charBounds:Rectangle, tf:TextField):void {
        // As this is executed before the Starling TextField is finish creating itself.
        // we have to apply a delay to avoid the "ArrayIndexOutOfBoundsException" trying to get
        // the textBounds... so you could store the charBounds somewhere and avoid the delay
        // looking the position after assign ::text
        // This is a dirty way of showing the example.
        Starling.juggler.delayCall(function () {

            var emoji:MyEmoji = MyEmoji.get(emojiData.texture, tf);
            var tfBounds:Rectangle = tf.getTextBounds(tf);
            emoji.alignPivot();
            emoji.adjustWidth(emojiData.expectedWidth);
            emoji.x = tfBounds.x + charBounds.x + charBounds.width / 2;
            emoji.y = tfBounds.y + charBounds.y + charBounds.height / 2;
            if (emojiData.key == "{starling}") {
                emoji.color = 0x777777;
                emoji.funnyMove();
            }

        }, 0);
    }

}
}


import flash.geom.Rectangle;
import flash.text.TextField;

import starling.core.Starling;

class LineMetrics {

    public static function getEmojiBounds(tf:TextField, emojiData:Object):Array {
        // Flash TextField has to be on Stage to read metrics...
        if (!tf.parent) Starling.current.nativeOverlay.addChild(tf);

        var text:String = tf.text;
        var search:String = emojiData.unicodeReplacer;

        var indices:Array = [];
        var bounds:Array = [];
        var index:int = -1;
        var textComplete:Boolean = false;

        while (!textComplete) {
            index = text.indexOf(search, index + 1);
            if (index > -1) {
                indices.push(index);
            } else {
                textComplete = true;
                break;
            }
        }

        // we have the indices now, replace the final space character.
        tf.htmlText = tf.htmlText.split(search).join(emojiData.replacer);

        // adjust to Starling's scale.
        const invScale:Number = 1 / Starling.contentScaleFactor;

        for each(index in indices) {

            var charBounds:Rectangle = tf.getCharBoundaries(index);
            charBounds.x *= invScale;
            charBounds.y *= invScale;
            charBounds.width *= invScale;
            charBounds.height *= invScale;

            bounds.push(charBounds);
        }


        if (!Starling.juggler.containsDelayedCalls(removeNativeTextField)) {
            // remove the native textfield from Stage on next frame...
            Starling.juggler.delayCall(removeNativeTextField, 0, tf);
        }
        return bounds;
    }

    private static function removeNativeTextField(tf:TextField):void {
        if (tf.parent) tf.parent.removeChild(tf);
    }
}