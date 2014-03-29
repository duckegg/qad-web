package hpps.qad.app.sample.stock;

import hpps.qad.base.action.BasicAction;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;

/**
 * @author Leo Liao, 2/27/14, created
 * @version 1.0
 */
public class StockAction extends BasicAction {
    private static final Logger logger = LoggerFactory.getLogger(StockAction.class);

    public String $index() {
        return getActionResult();
    }

    public String $list() {
        return getActionResult();
    }
}
