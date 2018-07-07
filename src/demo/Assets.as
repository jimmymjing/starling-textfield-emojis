// =================================================================================================
//
//	Created by Rodrigo Lopez [roipeker™] on 07/07/2018.
//
// =================================================================================================

package demo {
import starling.textures.Texture;

public class Assets {


    [Embed(source="../assets/ico1.png")]
    private static const Ico1:Class;
    public static var ico1Texture:Texture;

    [Embed(source="../assets/ico2.png")]
    private static const Ico2:Class;
    public static var ico2Texture:Texture;

    [Embed(source="../assets/smile.png")]
    private static const IcoSmile:Class;
    public static var smileTexture:Texture;

    [Embed(source="../assets/starling.png")]
    private static const IcoStarling:Class;
    public static var starlingTexture:Texture;

    public static function init():void {
        ico1Texture = Texture.fromEmbeddedAsset(Ico1);
        ico2Texture = Texture.fromEmbeddedAsset(Ico2);
        starlingTexture = Texture.fromEmbeddedAsset(IcoStarling);
        smileTexture = Texture.fromEmbeddedAsset(IcoSmile);
    }

    public function Assets() {}
}
}
