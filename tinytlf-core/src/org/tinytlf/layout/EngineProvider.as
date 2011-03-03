package org.tinytlf.layout {
import org.tinytlf.ITextEngine;

public interface EngineProvider {
  /**
   * Reference to the central <code>ITextEngine</code> facade for this
   * <code>container</code>.
   *
   * @see org.tinytlf.ITextEngine
   */
  function get engine():ITextEngine;
}
}
