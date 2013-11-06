/**
 * Created with IntelliJ IDEA.
 * User: mzx
 * Date: 10/12/13
 * Time: 5:07 PM
 * To change this template use File | Settings | File Templates.
 */
package components
{
    import starling.display.Button;
    import starling.textures.Texture;

    public class SButton extends Button
    {
        public function SButton(upState:Texture, text:String="", downState:Texture=null)
        {
            super(upState, text, downState);
        }
    }
}
