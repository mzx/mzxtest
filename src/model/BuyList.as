/**
 * Created with IntelliJ IDEA.
 * User: mzx
 * Date: 9/27/13
 * Time: 2:14 AM
 * To change this template use File | Settings | File Templates.
 */
package model
{
    import starling.textures.Texture;

    import util.Atlas1;
    import util.ColorUtils;

    [RemoteClass]
    public class BuyList extends Version
    {
        public function BuyList()
        {

        }

        public var color:uint = ColorUtils.BEIGE;
        public var items:Vector.<ListItem> = new Vector.<ListItem>();

        //noinspection JSUnusedGlobalSymbols
        private var accIcon:Texture;

        public function get accessoryTexture():Texture
        {

            if (accIcon == null)
            {
                // var frame:Rectangle = new Rectangle(-64, -64, 192, 192);
//                accIcon = Texture.fromTexture(Atlas1.forward,null,frame);
                accIcon = Atlas1.forward;
            }
            return accIcon
        }
    }
}
