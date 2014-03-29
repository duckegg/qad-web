package hpps.qad.app.sample.stock;

import java.io.IOException;
import java.io.Reader;

/**
 * @author Leo Liao, 14-2-27, created
 * @version 1.0
 */
public interface StockService {
    int importQuoteFromCsv(Reader csv, boolean tabSeparated, String symbol) throws IOException;

    int importStockFromCsv(Reader csv, boolean tabSeparated) throws IOException;
}
