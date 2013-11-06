/**
 * Created with IntelliJ IDEA.
 * User: mzx
 * Date: 9/28/13
 * Time: 10:12 PM
 * To change this template use File | Settings | File Templates.
 */
package util
{
    import flash.display.BitmapData;

    import starling.textures.Texture;
    import starling.textures.TextureAtlas;

    public class Atlas1
    {
        [Embed(source="/../assets/categories.png")]
        protected static const ATLAS_IMAGE:Class;
        [Embed(source="/../assets/categories.xml", mimeType="application/octet-stream")]
        protected static const ATLAS_XML:Class;
        public static var back:Texture;
        public static var cancel:Texture;
        public static var camera:Texture;
        public static var menu:Texture;
        public static var ok:Texture;
        public static var plus:Texture;
        public static var ring:Texture;
        public static var forward:Texture;
        public static var glassButton:Texture;
        public static var mintButton:Texture;
        public static var settings:Texture;

        public function Atlas1()
        {
            const atlasBitmapData:BitmapData = (new ATLAS_IMAGE()).bitmapData;
            atlas = new TextureAtlas(Texture.fromBitmapData(atlasBitmapData, false), XML(new ATLAS_XML()));

            back = atlas.getTexture("back");
            cancel = atlas.getTexture("cancel");
            camera = atlas.getTexture("camera");
            menu = atlas.getTexture("menu");
            ok = atlas.getTexture("ok");
            forward = atlas.getTexture("forward");
            plus = atlas.getTexture("plus");
            ring = atlas.getTexture("ring");
            glassButton = atlas.getTexture("glassbutton");
            mintButton = atlas.getTexture("mintButton");
            settings = atlas.getTexture("settings");

        }

        //noinspection JSFieldCanBeLocal
        private var atlas:TextureAtlas;
    }
}
