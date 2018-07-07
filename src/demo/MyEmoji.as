// =================================================================================================
//
//	Created by Rodrigo Lopez [roipeker™] on 07/07/2018.
//
// =================================================================================================

/**
 * Just a wrapper for the Image class that includes a pool ...
 */
package demo {
import starling.core.Starling;
import starling.display.DisplayObjectContainer;
import starling.display.Image;
import starling.textures.Texture;

public class MyEmoji extends Image {

    //============================
    // POOL stuffs --
    //============================

    private static var _used:Array = [];
    private static var _pool:Array = [];

    public static function get(texture:Texture, parent:DisplayObjectContainer):MyEmoji {
        var emoji:MyEmoji = _pool.length == 0 ? new MyEmoji() : _pool.pop();
        emoji.texture = texture;
        emoji.readjustSize();
        _used[_used.length] = emoji;
        if (parent) {
            parent.addChild(emoji);
        }
        return emoji;
    }

    public function put():void {
        reset();
        if (_pool.indexOf(this) == -1) {
            _pool[_pool.length] = this;
        }
        var idx:int = _used.indexOf(this);
        if (idx > -1) _used.removeAt(idx);
    }

    public function isUsing():Boolean {
        return _used.indexOf(this) > -1;
    }

    private function reset():void {

        if (Starling.juggler.containsTweens(this)) {
            Starling.juggler.removeTweens(this);
        }

        removeFromParent(false);
        texture = null;
        color = 0xffffff;
        alpha = scaleX = scaleY = 1;
        skewX = skewY = x = y = rotation = pivotX = pivotY = 0;
        visible = true;
        mask = null;
        filter = null;
        name = null;
    }


    /**
     * CONSTRUCTOR.
     * @param texture
     */
    public function MyEmoji(texture:Texture = null) {
        super(texture);
    }

    public function adjustWidth(expectedWidth:Number):void {
        // adjust size ...
        if (expectedWidth == 0) {
            // by default constrain size to 26px.
            scale = 26 / texture.width;
        } else {
            scale = expectedWidth / texture.width;
        }
    }

    public function funnyMove():void {
        Starling.juggler.tween(this, .4, {repeatCount: 0, repeatDelay: .1, reverse: true, rotation: .4});
    }
}
}
