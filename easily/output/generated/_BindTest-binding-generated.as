

import flash.events.Event;
import flash.events.EventDispatcher;
import flash.events.IEventDispatcher;
import mx.core.IPropertyChangeNotifier;
import mx.events.PropertyChangeEvent;
import mx.utils.ObjectProxy;
import mx.utils.UIDUtil;

import org.easily.test.*;

class BindableProperty
{
	/*
	 * generated bindable wrapper for property str (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'str' moved to '_114225str'
	 */

    [Bindable(event="propertyChange")]
    public function get str():String
    {
        return this._114225str;
    }

    public function set str(value:String):void
    {
    	var oldValue:Object = this._114225str;
        if (oldValue !== value)
        {
            this._114225str = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "str", oldValue, value));
        }
    }

	/*
	 * generated bindable wrapper for property obj2 (public)
	 * - generated setter
	 * - generated getter
	 * - original public var 'obj2' moved to '_3404315obj2'
	 */

    [Bindable(event="propertyChange")]
    public function get obj2():BindObjTest
    {
        return this._3404315obj2;
    }

    public function set obj2(value:BindObjTest):void
    {
    	var oldValue:Object = this._3404315obj2;
        if (oldValue !== value)
        {
            this._3404315obj2 = value;
           if (this.hasEventListener("propertyChange"))
               this.dispatchEvent(mx.events.PropertyChangeEvent.createUpdateEvent(this, "obj2", oldValue, value));
        }
    }



}
