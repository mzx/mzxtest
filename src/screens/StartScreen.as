/**
 * Created with IntelliJ IDEA.
 * User: mzx
 * Date: 9/26/13
 * Time: 7:09 PM
 * To change this template use File | Settings | File Templates.
 */
package screens
{
    import feathers.controls.Button;
    import feathers.controls.PanelScreen;

    import starling.events.Event;

    public class StartScreen extends PanelScreen
    {


        public function StartScreen()
        {
            super();
        }

        override protected function initialize():void
        {
            super.initialize();
            headerProperties.title = "StartScreen";
            var button:Button = new Button();
            button.addEventListener(Event.TRIGGERED, onTriggered);

            addChild(button)
        }

        private function onTriggered(event:Event):void
        {
            owner.showScreen(ListsScreen.NAME)
        }

        public static const NAME:String = "StartScreen";
    }
}
