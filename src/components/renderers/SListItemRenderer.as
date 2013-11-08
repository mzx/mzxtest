/**
 * Created with IntelliJ IDEA.
 * User: mzx
 * Date: 10/13/13
 * Time: 7:15 PM
 * To change this template use File | Settings | File Templates.
 */
package components.renderers
{
    import feathers.controls.renderers.DefaultListItemRenderer;

    import util.CBW;
    import util.ColorUtils;

    public class SListItemRenderer extends DefaultListItemRenderer
    {
        public function SListItemRenderer()
        {
            super()
        }

        override protected function draw():void
        {
            super.draw();
            accessoryImage.color = ColorUtils.BEIGE;
            accessoryImage.width = accessoryImage.height = CBW(32);
            super.draw();
        }
    }
}
