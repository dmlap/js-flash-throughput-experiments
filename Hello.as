package {

  import flash.display.Sprite;
  import flash.events.Event;
  import flash.external.ExternalInterface;

  [SWF(backgroundColor="#000000", frameRate="60", width="800", height="400")]
  public class Hello extends Sprite {

    public function Hello() {
      if (ExternalInterface.available) {
        ExternalInterface.call('console.log', 'Hello world.');
      }
    }
  }
}
