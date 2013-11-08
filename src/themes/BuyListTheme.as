/**
 * Created with IntelliJ IDEA.
 * User: mzx
 * Date: 10/13/13
 * Time: 7:56 PM
 * To change this template use File | Settings | File Templates.
 */
package themes
{
    import components.renderers.SListItemRenderer;

    import feathers.controls.Button;

    import feathers.controls.renderers.BaseDefaultItemRenderer;
    import feathers.display.Scale3Image;
    import feathers.skins.SmartDisplayObjectStateValueSelector;
    import feathers.textures.Scale3Textures;

    import feathers.themes.MetalWorksMobileTheme;

    import starling.display.DisplayObjectContainer;
    import starling.textures.Texture;

    import util.Atlas1;

    public class BuyListTheme extends MetalWorksMobileTheme
    {
        public function BuyListTheme(container:DisplayObjectContainer = null, scaleToDPI:Boolean = true)
        {
            super(container, scaleToDPI);
        }


        override protected function initialize():void
        {
            super.initialize();

            this.setInitializerForClass(SListItemRenderer, itemRendererInitializer);
        }

        override protected function itemRendererInitializer(renderer:BaseDefaultItemRenderer):void
        {
              super.itemRendererInitializer(renderer)
        }


        override protected function buttonInitializer(button:Button):void
        {

            const skinSelector:SmartDisplayObjectStateValueSelector = new SmartDisplayObjectStateValueSelector();

            var scale3Textures:Scale3Textures = new Scale3Textures(Atlas1.mintButton, 24, 84);
            skinSelector.defaultValue = scale3Textures;
            skinSelector.defaultSelectedValue = scale3Textures;
            skinSelector.setValueForState(scale3Textures, Button.STATE_DOWN, false);
            skinSelector.setValueForState(scale3Textures, Button.STATE_DISABLED, false);
            skinSelector.setValueForState(scale3Textures, Button.STATE_DISABLED, true);
            skinSelector.displayObjectProperties =
            {
                width: 60 * this.scale,
                height: 60 * this.scale,
                textureScale: this.scale
            };
            button.stateToSkinFunction = skinSelector.updateValue;
            this.baseButtonInitializer(button);

        }
    }
}
