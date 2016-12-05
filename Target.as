package {

  import flash.display.Sprite;
  import flash.events.Event;
  import flash.events.SecurityErrorEvent;
  import flash.events.IOErrorEvent;
  import flash.events.HTTPStatusEvent;
  import flash.external.ExternalInterface;
  import flash.net.URLLoader;
  import flash.net.URLLoaderDataFormat;
  import flash.net.URLRequest;

  import flash.utils.setTimeout;

  [SWF(backgroundColor="#000000", frameRate="60", width="800", height="400")]
  public class Target extends Sprite {

    private var tries: Number = 0;

    public function Target() {
      if (ExternalInterface.available) {
        ExternalInterface.addCallback('send', onMessage);
        ExternalInterface.addCallback('sendUrl', onUrl);
        ExternalInterface.call('console.log', 'ready');
      }

      stage.addEventListener(Event.RESIZE, onStageResize);
    }

    public function onMessage(data: String): void {
      var message: String;
      if (data) {
        message = 'received ' + data.length;
      } else {
        message = 'received ' + data;
      }
      ExternalInterface.call('console.log', message);
    }

    public function onUrl(url: String): void {
      var loader: URLLoader = new URLLoader();

      ExternalInterface.call('console.log', 'beginning request to ' + url);
      loader.dataFormat = URLLoaderDataFormat.BINARY;

      loader.addEventListener(Event.COMPLETE, function(): void {
        ExternalInterface.call('__flash__loadComplete', url);
      });
      loader.addEventListener(Event.OPEN, function(): void {
        ExternalInterface.call('console.log', 'urlloader open');
      });
      loader.addEventListener(SecurityErrorEvent.SECURITY_ERROR, function(event: SecurityErrorEvent): void {
        ExternalInterface.call('__flash__loadComplete', event.toString());
      });
      loader.addEventListener(IOErrorEvent.IO_ERROR, function(event: IOErrorEvent): void {
        ExternalInterface.call('__flash__loadComplete', event.toString());
      });
      loader.addEventListener(HTTPStatusEvent.HTTP_STATUS, function(event: HTTPStatusEvent): void {
        ExternalInterface.call('__flash__loadComplete', event.toString());
      });

      try {
        loader.load(new URLRequest(url));
      } catch(e: *) {
        ExternalInterface.call('console.log', 'error', e);
      }
    }

    public function onStageResize(event: Event): void {
      tries++;
      if (tries % (1024 * 1024) === 0) {
        ExternalInterface.call('console.log', 'rx 1MB');
      }
    }

  }
}
