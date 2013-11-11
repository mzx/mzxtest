/**
 * Created with IntelliJ IDEA.
 * User: mzx
 * Date: 9/28/13
 * Time: 3:13 PM
 * To change this template use File | Settings | File Templates.
 */
package model
{
    import util.ColorUtils;

    [RemoteClass]
    public class ListItem extends Version
    {
        public var done:Boolean;

        public var category:Category;


        public var qty:Number = 1;
        public var price:String = "0";

        public var color:uint = ColorUtils.TUSCAN;
    }
}
