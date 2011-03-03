package org.tinytlf.layout {
import flash.display.Sprite;

import org.tinytlf.ITextEngine;

public class TinytlfSprite extends Sprite implements EngineProvider {
  private var _engine:ITextEngine;
  
  public function TinytlfSprite(engine:ITextEngine) {
    _engine = engine;
  }

  public function get engine():ITextEngine {
    return _engine;
  }
}
}