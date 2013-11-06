package model
{
    import feathers.data.ListCollection;

    import flash.events.EventDispatcher;
    import flash.events.NetStatusEvent;
    import flash.net.SharedObject;
    import flash.net.SharedObjectFlushStatus;
    import flash.net.registerClassAlias;

    public class Model extends EventDispatcher
    {

        private static const APPLICATION_STORAGE_KEY:String = "skeleton";//new Date().hours+ "tttt";
        public static var instance:Model = PrivateConstructor();
        private static var registeredClassesAliases:Boolean = registerClassAliases();
        private static var singletonflag:Boolean;
        private static var so:SharedObject;

        private static var _lists:ListCollection;

        public static var selectedList:BuyList;
        public static var selectedListItem:ListItem;

        public static function get lists():ListCollection
        {
            if (_lists == null)
                loadLists();

            return _lists;
        }

        public static function set lists(value:ListCollection):void
        {
            if (_lists !== value)
            {
                _lists = value;
                //instance.dispatchEvent(new Event("listsChange"));
            }
        }

        public static function registerClassAliases():Boolean
        {
            registerClassAlias("model.BuyList", BuyList);
            registerClassAlias("model.Category", Category);
            registerClassAlias("model.ListItem", ListItem);
            registerClassAlias("model.Version", Version);
            return true
        }

        public static function savelists():void
        {
            so = SharedObject.getLocal(APPLICATION_STORAGE_KEY);
            so.data.lists = (_lists.data as Array);

            flush();
        }

        private static function PrivateConstructor():Model
        {
            singletonflag = true;
            var result:Model = new Model();
            singletonflag = false;
            return result;
        }

        private static function loadLists():void
        {
            so = SharedObject.getLocal(APPLICATION_STORAGE_KEY);

            var r:Array = so.data.lists as Array;
            _lists = new ListCollection(r);

            if (_lists == null || _lists.length == 0)
            {
                _lists = new ListCollection([]);
            }

            trace("loadlists")

        }

        private static function flush():void
        {
            var flushStatus:String = null;
            try
            {
                flushStatus = so.flush();
            } catch (error:Error)
            {
                trace("Error...Could not write SharedObject to disk\n");
            }

            if (flushStatus != null)
            {
                switch (flushStatus)
                {
                    case SharedObjectFlushStatus.PENDING:
                        trace("Requesting permission to save object...\n");
                        so.addEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
                        break;
                    case SharedObjectFlushStatus.FLUSHED:
                        trace("Value flushed to disk.\n");
                        break;
                }
            }

        }

        public function Model()
        {
            if (!singletonflag)
                throw new Error("use Model.instance")
        }

        public var selectedList:BuyList;

        static private function onFlushStatus(event:NetStatusEvent):void
        {
            trace("User closed permission dialog...\n");
            switch (event.info.code)
            {
                case "SharedObject.Flush.Success":
                    trace("User granted permission -- value saved.\n");
                    break;
                case "SharedObject.Flush.Failed":
                    trace("User denied permission -- value not saved.\n");
                    break;
            }

            so.removeEventListener(NetStatusEvent.NET_STATUS, onFlushStatus);
        }

    }
}