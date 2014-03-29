package hpps.qad.app.sample.stock;

import hpps.qad.core.search.indexer.EsIndexer;

/**
 * @author Leo Liao, 14-3-6, created
 * @version 1.0
 */
public class SimpleDemoIndexer extends EsIndexer{
    @Override
    public String getDescription() {
        return "";
    }

    @Override
    protected String getDbConn() {
        return "mysql";
    }

    @Override
    protected String getDeleteIndexAckSql() {
        return null;
    }

    @Override
    protected String getLastIndexTimeSql() {
        return null;
    }
}
