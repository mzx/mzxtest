package
{
    import feathers.controls.ScreenNavigator;
    import feathers.controls.ScreenNavigatorItem;
    import feathers.motion.transitions.OldFadeNewSlideTransitionManager;
    import feathers.themes.MetalWorksMobileTheme;

    import screens.ListEditScreen;
    import screens.ListItemDetailsScreen;

    import screens.ListsDetailsScreen;
    import screens.ListsScreen;
    import screens.StartScreen;

    import starling.display.Sprite;
    import starling.events.Event;

    import themes.BuyListTheme;

    import util.Atlas1;
    import util.DPIUtils;

    public class Main extends Sprite
    {

        public static var navigator:ScreenNavigator;

        public function Main()
        {
            this.addEventListener(Event.ADDED_TO_STAGE, addedToStageHandler);
        }

        protected function addedToStageHandler(event:Event):void
        {

            DPIUtils.stage = stage;


            new BuyListTheme();
            new Atlas1();
            navigator = new ScreenNavigator();

            addChild(navigator);

            var _transitionManager:OldFadeNewSlideTransitionManager = new OldFadeNewSlideTransitionManager(navigator);


            //todo remove
            navigator.addScreen(StartScreen.NAME, new ScreenNavigatorItem(StartScreen));
            navigator.addScreen(ListsScreen.NAME, new ScreenNavigatorItem(ListsScreen));
            navigator.addScreen(ListsDetailsScreen.NAME, new ScreenNavigatorItem(ListsDetailsScreen, {back: ListsScreen.NAME}));
            navigator.addScreen(ListEditScreen.NAME, new ScreenNavigatorItem(ListEditScreen, {back: ListsDetailsScreen.NAME}));
            navigator.addScreen(ListItemDetailsScreen.NAME, new ScreenNavigatorItem(ListItemDetailsScreen, {back: ListsDetailsScreen.NAME}));

            navigator.showScreen(ListsScreen.NAME);

        }
    }

}